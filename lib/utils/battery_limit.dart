import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BatteryLimitNotifier extends AsyncNotifier<int> {
  @override
  Future<int> build() async {
    final result = await shell.run("asusctl", [
      "battery",
      "info",
    ]); // Current battery charge limit: 80%

    if (result.exitCode != 0) {
      throw Exception("asusctl exited with code ${result.exitCode}");
    }

    final output = result.stdout;
    final regex = RegExp(r"Current battery charge limit:\s+(\d+)%");
    final match = regex.firstMatch(output);
    if (match == null) {
      throw Exception("Failed to parse battery limit from output");
    }

    final limit = int.parse(match.group(1)!);
    return limit;
  }

  Future<void> setBatteryLimit(int limit) async {
    final result = await shell.run("asusctl", [
      "battery",
      "limit",
      limit.toString(),
    ]);

    if (result.exitCode != 0) {
      throw Exception("Failed to set battery limit: ${result.stderr}");
    }

    state = AsyncValue.data(limit);
  }
}

final batteryLimitNotifierProvider =
    AsyncNotifierProvider<BatteryLimitNotifier, int>(
      () => BatteryLimitNotifier(),
    );
