import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class ThemeProvider extends Notifier<ThemeMode> {
  GetStorage storage = GetStorage();

  @override
  ThemeMode build() {
    String mode = storage.read("theme-mode") ?? ThemeMode.system.name;
    return ThemeMode.values.firstWhere((e) => e.name == mode);
  }

  void setTheme(ThemeMode mode) {
    storage.write("theme-mode", mode.name);
    state = mode;
  }
}

final themeProvider = NotifierProvider<ThemeProvider, ThemeMode>(
  () => ThemeProvider(),
);
