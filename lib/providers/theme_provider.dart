import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  final _storage = GetStorage();
  static const _keyMode = 'theme_mode';

  @override
  ThemeMode build() {
    final modeIndex = _storage.read<int>(_keyMode);
    if (modeIndex != null) {
      if (modeIndex >= 0 && modeIndex < ThemeMode.values.length) {
        return ThemeMode.values[modeIndex];
      }
    }
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _storage.write(_keyMode, mode.index);
  }
}

final themeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  () => ThemeModeNotifier(),
);
