import 'package:asusctl_gui/main.dart';
import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Aura { static, breathe, rainbowCycle, rainbowWave, highlight }

class AuraState {
  final Aura mode;
  final String color;

  const AuraState({required this.mode, required this.color});

  AuraState copyWith({Aura? mode, String? color}) {
    return AuraState(mode: mode ?? this.mode, color: color ?? this.color);
  }
}

class AuraNotifier extends AsyncNotifier<AuraState> {
  @override
  Future<AuraState> build() async {
    String mode = storage.read("aura-mode") ?? Aura.static.name;
    String color = storage.read("aura-color") ?? "ffffff";

    return AuraState(
      mode: Aura.values.firstWhere((e) => e.name == mode),
      color: color,
    );
  }

  Future<void> setAura(Aura aura) async {
    final currentState = state.value;
    final color = currentState?.color ?? "ffffff";

    final auraName = aura.name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    );

    final args = ["aura", auraName];

    switch (aura) {
      case Aura.static:
        args.addAll(["-c", color]);
        break;
      case Aura.breathe:
        args.addAll([
          "--colour",
          "ff0000",
          "--colour2",
          "000000",
          "--speed",
          "low",
        ]);
        break;
      case Aura.rainbowCycle:
        args.addAll(["--speed", "low"]);
        break;
      case Aura.rainbowWave:
        args.addAll(["--direction", "right", "--speed", "low"]);
        break;
      case Aura.highlight:
        args.addAll(["-c", color, "--speed", "low"]);
        break;
    }

    final result = await shell.run("asusctl", args);

    if (result.exitCode != 0) {
      throw Exception("Failed to set aura: ${result.stderr}");
    }

    storage.write("aura-mode", aura.name);
    storage.write("aura-color", color);

    state = AsyncValue.data(
      currentState?.copyWith(mode: aura) ?? AuraState(mode: aura, color: color),
    );
  }

  Future<void> setColor(String color) async {
    final currentState = state.value;
    final mode = currentState?.mode ?? Aura.static;

    // Use static mode if current mode doesn't support single color or is complex
    final targetMode = (mode == Aura.static || mode == Aura.highlight)
        ? mode
        : Aura.static;

    final auraName = targetMode.name.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '-${match.group(0)!.toLowerCase()}',
    );

    final args = ["aura", auraName];

    if (targetMode == Aura.static) {
      args.addAll(["-c", color]);
    } else if (targetMode == Aura.highlight) {
      args.addAll(["-c", color, "--speed", "low"]);
    }

    final result = await shell.run("asusctl", args);

    if (result.exitCode != 0) {
      throw Exception("Failed to set aura color: ${result.stderr}");
    }

    storage.write("aura-mode", targetMode.name);
    storage.write("aura-color", color);

    state = AsyncValue.data(
      currentState?.copyWith(mode: targetMode, color: color) ??
          AuraState(mode: targetMode, color: color),
    );
  }
}

final auraNotifierProvider = AsyncNotifierProvider<AuraNotifier, AuraState>(
  () => AuraNotifier(),
);
