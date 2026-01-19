import 'dart:io';
import 'package:asusctl_gui/utils/aura.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuraColorNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return "ffffff";
  }

  Future<void> setAuraColor(Aura aura, String color) async {
    final result = await Process.run("asusctl", [
      "aura",
      "set",
      aura.name,
      "--colour",
      color,
    ]);

    if (result.exitCode != 0) {
      throw Exception("Failed to set aura color: ${result.stderr}");
    }

    state = AsyncValue.data(color);
  }
}

final auraColorNotifierProvider =
    AsyncNotifierProvider<AuraColorNotifier, String>(() => AuraColorNotifier());
