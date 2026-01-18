import 'dart:io';

import 'package:asusctl_gui/utils/profiles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FanCurvePoint {
  final int temperature;
  final int percentage;

  FanCurvePoint(this.temperature, this.percentage);

  @override
  String toString() => '$temperature:$percentage';
}

class FanCurveData {
  final Profile profile;
  final String fan; // 'cpu', 'gpu', 'mid'
  final bool enabled;
  final List<FanCurvePoint> points;

  FanCurveData({
    required this.profile,
    required this.fan,
    required this.enabled,
    required this.points,
  });

  FanCurveData copyWith({
    Profile? profile,
    String? fan,
    bool? enabled,
    List<FanCurvePoint>? points,
  }) {
    return FanCurveData(
      profile: profile ?? this.profile,
      fan: fan ?? this.fan,
      enabled: enabled ?? this.enabled,
      points: points ?? this.points,
    );
  }
}

class FanCurveNotifier extends AsyncNotifier<FanCurveData> {
  @override
  Future<FanCurveData> build() async {
    // Default initial state
    return _fetchData(Profile.performance, 'cpu');
  }

  Future<FanCurveData> _fetchData(Profile profile, String fan) async {
    // Check if enabled first?
    // The command `asusctl fan-curve --mod-profile <profile> --fan <fan>` returns data like:
    // "Fan curve for Performance (cpu): 30c:0%,40c:5%,..."
    // or checks enabled status.

    // Let's try to get data.
    final result = await Process.run('asusctl', [
      'fan-curve',
      '--mod-profile',
      _profileName(profile),
      '--fan',
      fan,
    ]);

    if (result.exitCode != 0) {
      // If it fails (e.g. not supported), we throw to let the UI handle it.
      throw Exception(result.stderr.toString());
    }

    final output = result.stdout as String;
    // Parse output.
    // Example output (hypothetical based on standard asusctl, need to be robust):
    // "Fan curve for Performance (cpu) enabled: true"
    // "30c:0%, 40c:5%, ..." -> this might come from --data or just implied?
    // Actually, looking at help: "--mod-profile ... shows data if no options provided"

    // Let's assume the output contains "enabled: true/false" and the points.
    // If parsing fails, return safe defaults.

    // Mock parsing for now as we don't have exact output of a working system
    // But we know the user's system errors out, so this will mostly throw.

    // Check for enabled status in output
    bool enabled = output.toLowerCase().contains("enabled: true");

    // Parse points: look for patterns like "30c:1%"
    final points = <FanCurvePoint>[];
    final regex = RegExp(r'(\d+)c:(\d+)%?');
    final matches = regex.allMatches(output);

    for (final match in matches) {
      final temp = int.parse(match.group(1)!);
      final percent = int.parse(match.group(2)!);
      points.add(FanCurvePoint(temp, percent));
    }

    if (points.isEmpty) {
      // Fallback default points if none parsed (or unexpected format)
      points.addAll([
        FanCurvePoint(30, 0),
        FanCurvePoint(40, 5),
        FanCurvePoint(50, 10),
        FanCurvePoint(60, 20),
        FanCurvePoint(70, 35),
        FanCurvePoint(80, 55),
        FanCurvePoint(90, 75),
        FanCurvePoint(100, 100),
      ]);
    }

    return FanCurveData(
      profile: profile,
      fan: fan,
      enabled: enabled,
      points: points,
    );
  }

  String _profileName(Profile p) {
    switch (p) {
      case Profile.performance:
        return "Performance";
      case Profile.balanced:
        return "Balanced";
      case Profile.quiet:
        return "Quiet";
    }
  }

  Future<void> load(Profile profile, String fan) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchData(profile, fan));
  }

  Future<void> setEnabled(bool enabled) async {
    final current = state.value;
    if (current == null) return;

    final result = await Process.run('asusctl', [
      'fan-curve',
      '--mod-profile',
      _profileName(current.profile),
      '--enable-fan-curve',
      enabled.toString(),
      '--fan',
      current.fan,
    ]);

    if (result.exitCode != 0) {
      throw Exception("Failed to set enabled: ${result.stderr}");
    }

    // Reload to verify
    await load(current.profile, current.fan);
  }

  Future<void> applyCurve(List<FanCurvePoint> points) async {
    final current = state.value;
    if (current == null) return;

    // Format: 30c:1%,49c:2%,...
    final dataStr = points
        .map((p) => "${p.temperature}c:${p.percentage}%")
        .join(",");

    final result = await Process.run('asusctl', [
      'fan-curve',
      '--mod-profile',
      _profileName(current.profile),
      '--fan',
      current.fan,
      '--data',
      dataStr,
    ]);

    if (result.exitCode != 0) {
      throw Exception("Failed to apply curve: ${result.stderr}");
    }

    await load(current.profile, current.fan);
  }
}

final fanCurveNotifierProvider =
    AsyncNotifierProvider<FanCurveNotifier, FanCurveData>(() {
      return FanCurveNotifier();
    });
