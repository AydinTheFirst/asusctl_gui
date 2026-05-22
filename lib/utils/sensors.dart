import 'dart:async';
import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SensorState {
  final int cpuSpeed;
  final int gpuSpeed;
  final double cpuTemp;
  final double gpuTemp;

  const SensorState({
    this.cpuSpeed = 0,
    this.gpuSpeed = 0,
    this.cpuTemp = 0.0,
    this.gpuTemp = 0.0,
  });
}

class SensorNotifier extends StreamNotifier<SensorState> {
  @override
  Stream<SensorState> build() {
    return Stream.periodic(const Duration(seconds: 2), (_) async {
      return _readSensors();
    }).asyncMap((event) => event);
  }

  Future<SensorState> _readSensors() async {
    try {
      // Try sysfs first (works on Fedora and most Linux distros without lm-sensors)
      final sensors = await _readFromSysfs();
      if (sensors != null) return sensors;

      // Fall back to sensors command if sysfs fails
      return await _readFromSensorsCommand();
    } catch (e) {
      return const SensorState();
    }
  }

  Future<SensorState?> _readFromSysfs() async {
    try {
      int cpuSpeed = 0;
      int gpuSpeed = 0;
      double cpuTemp = 0.0;
      double gpuTemp = 0.0;

      // Read fan speeds from ASUS hwmon
      // Find the asus hwmon device
      final hwmonPath = await _findHwmonByName('asus');
      if (hwmonPath != null) {
        cpuSpeed = await _readSysfsInt('$hwmonPath/fan1_input');
        gpuSpeed = await _readSysfsInt('$hwmonPath/fan2_input');
      }

      // Read CPU temperature from coretemp
      final coretempPath = await _findHwmonByName('coretemp');
      if (coretempPath != null) {
        final tempMilliCelsius = await _readSysfsInt('$coretempPath/temp1_input');
        cpuTemp = tempMilliCelsius / 1000.0;
      }

      // Read GPU temperature from nvidia-smi
      try {
        final result = await shell.run('nvidia-smi', [
          '--query-gpu=temperature.gpu',
          '--format=csv,noheader',
        ]);
        final output = result.stdout.toString().trim();
        if (output.isNotEmpty) {
          gpuTemp = double.tryParse(output) ?? 0.0;
        }
      } catch (e) {
        // nvidia-smi not available or failed
      }

      return SensorState(
        cpuSpeed: cpuSpeed,
        gpuSpeed: gpuSpeed,
        cpuTemp: cpuTemp,
        gpuTemp: gpuTemp,
      );
    } catch (e) {
      return null;
    }
  }

  Future<String?> _findHwmonByName(String name) async {
    try {
      // Use grep to find the hwmon device with matching name
      final result = await shell.run('sh', [
        '-c',
        'grep -l "^$name\$" /sys/class/hwmon/hwmon*/name 2>/dev/null | head -1 | xargs dirname',
      ]);
      final path = result.stdout.toString().trim();
      return path.isEmpty ? null : path;
    } catch (e) {
      return null;
    }
  }

  Future<int> _readSysfsInt(String path) async {
    try {
      final result = await shell.run('cat', [path]);
      final value = result.stdout.toString().trim();
      return int.tryParse(value) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<SensorState> _readFromSensorsCommand() async {
    try {
      final result = await shell.run('sensors', []);
      final output = result.stdout.toString();

      final cpuFanRegex = RegExp(r'cpu_fan:\s+(\d+)');
      final gpuFanRegex = RegExp(r'gpu_fan:\s+(\d+)');

      final cpuTempRegex = RegExp(r'Package id 0:\s+\+?(\d+\.\d+)');

      final gpuTempRegex = RegExp(r'(edge|Composite|GPU):\s+\+?(\d+\.\d+)');

      final cpuFanMatch = cpuFanRegex.firstMatch(output);
      final gpuFanMatch = gpuFanRegex.firstMatch(output);

      final cpuTempMatch = cpuTempRegex.firstMatch(output);
      final gpuTempMatch = gpuTempRegex.firstMatch(output);

      return SensorState(
        cpuSpeed: cpuFanMatch != null ? int.parse(cpuFanMatch.group(1)!) : 0,
        gpuSpeed: gpuFanMatch != null ? int.parse(gpuFanMatch.group(1)!) : 0,
        cpuTemp: cpuTempMatch != null
            ? double.parse(cpuTempMatch.group(1)!)
            : 0.0,
        gpuTemp: gpuTempMatch != null
            ? double.parse(gpuTempMatch.group(2)!)
            : 0.0,
      );
    } catch (e) {
      return const SensorState();
    }
  }
}

final sensorsProvider = StreamNotifierProvider<SensorNotifier, SensorState>(() {
  return SensorNotifier();
});
