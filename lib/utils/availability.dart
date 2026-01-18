import 'package:asusctl_gui/services/shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final asusctlAvailabilityProvider = FutureProvider<bool>((ref) async {
  try {
    final result = await shell.run('asusctl', ['info']);
    return result.exitCode == 0;
  } catch (e) {
    return false;
  }
});
