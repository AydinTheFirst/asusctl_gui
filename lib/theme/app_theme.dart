import 'package:flutter/material.dart';

class AppTheme {
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _white,
      appBarTheme: const AppBarTheme(
        backgroundColor: _white,
        foregroundColor: _black,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _black,
        onPrimary: _white,
        secondary: Color(0xFF2E2E31),
        onSecondary: _white,
        surface: Color(0xFF222325),
        onSurface: _white,
        error: Color(0xFFB3261E),
        onError: _white,
      ),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: _black)),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _black,
      appBarTheme: const AppBarTheme(
        backgroundColor: _black,
        foregroundColor: _white,
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: _white,
        onPrimary: _black,
        secondary: Color(0xFF2E2E31),
        onSecondary: _white,
        surface: Color(0xFF222325),
        onSurface: _white,
        error: Color(0xFFB3261E),
        onError: _white,
      ),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: _white)),
    );
  }
}
