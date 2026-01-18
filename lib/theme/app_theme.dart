import 'package:flutter/material.dart';

class AppTheme {
  // Core Colors
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);

  // Light Theme Specific
  static const Color _lightSurface = Color(
    0xFFF5F5F7,
  ); // Subtle off-white for cards
  static const Color _lightBackground = Color(0xFFFFFFFF);
  static const Color _lightSecondary = Color(0xFFE5E5EA);

  // Dark Theme Specific
  static const Color _darkSurface = Color(
    0xFF1C1C1E,
  ); // Apple-style dark surface
  static const Color _darkBackground = Color(0xFF000000);
  static const Color _darkSecondary = Color(0xFF2C2C2E);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: _black,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: _black,
        onPrimary: _white,
        secondary: _lightSecondary,
        onSecondary: _black,
        surface: _lightSurface,
        onSurface: _black,
        error: Color(0xFFB3261E),
        onError: _white,
        outline: Color(0xFFE0E0E0),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E5EA), width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _black),
        bodyMedium: TextStyle(color: _black),
      ),
      iconTheme: const IconThemeData(color: _black),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: _white,
        onPrimary: _black,
        secondary: _darkSecondary,
        onSecondary: _white,
        surface: _darkSurface,
        onSurface: _white,
        error: Color(0xFFCF6679),
        onError: _black,
        outline: Color(0xFF2C2C2E),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF2C2C2E), width: 1),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: _white),
        bodyMedium: TextStyle(color: _white),
      ),
      iconTheme: const IconThemeData(color: _white),
    );
  }
}
