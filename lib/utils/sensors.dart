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
