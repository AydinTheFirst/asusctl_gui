import 'dart:io';

import 'package:asusctl_gui/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LedsLevel { off, low, med, high }

class LedsNotifier extends AsyncNotifier<LedsLevel> {
  @override
  Future<LedsLevel> build() async {
    String level = storage.read("leds-level") ?? LedsLevel.high.name;

    return LedsLevel.values.firstWhere((e) => e.name == level);
  }

  Future<void> setLedsLevel(LedsLevel level) async {
    final result = await Process.run("asusctl", ["leds", "set", level.name]);

    if (result.exitCode != 0) {
      throw Exception("Failed to set LEDs level: ${result.stderr}");
    }

    storage.write("leds-level", level.name);

    state = AsyncValue.data(level);
  }
}

final ledsNotifierProvider = AsyncNotifierProvider<LedsNotifier, LedsLevel>(
  () => LedsNotifier(),
);
