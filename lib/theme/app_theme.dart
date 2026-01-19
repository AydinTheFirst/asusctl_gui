import 'package:flutter/material.dart';

class AppTheme {
  static const Color _white = Color(0xFFFAFAFA);
  static const Color _black = Color(0xFF1A1A1A);

  // Light Palette
  static const Color _lightBg = _white;
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightBorder = Color(0xFFE5E5E5);

  // Dark Palette
  static const Color _darkBg = _black;
  static const Color _darkSurface = Color(0xFF262626);
  static const Color _darkBorder = Color(0x1AFFFFFF);

  static ThemeData get lightTheme {
    final lightScheme = ColorScheme.light(
      surface: _lightBg,
      onSurface: _black,
      surfaceContainer: _lightSurface,
      outlineVariant: _lightBorder,
      primary: _black,
      secondary: _black,
      secondaryContainer: Color(0xFFF0F0F0),
      onSecondaryContainer: _black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: lightScheme,
      cardTheme: _cardTheme(_lightSurface, _lightBorder),
      filledButtonTheme: _filledButtonTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      segmentedButtonTheme: _segmentedButtonTheme(lightScheme),
    );
  }

  static ThemeData get darkTheme {
    final darkScheme = ColorScheme.dark(
      surface: _darkBg,
      onSurface: _white,
      surfaceContainer: _darkSurface,
      outlineVariant: _darkBorder,
      primary: _white,
      secondary: _white,
      secondaryContainer: Color(0xFF303030),
      onSecondaryContainer: _white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkScheme,
      cardTheme: _cardTheme(_darkSurface, _darkBorder),
      filledButtonTheme: _filledButtonTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      segmentedButtonTheme: _segmentedButtonTheme(darkScheme),
    );
  }

  static CardThemeData _cardTheme(Color color, Color borderColor) {
    return CardThemeData(
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 1),
      ),
      surfaceTintColor: Colors.transparent,
    );
  }

  static final _filledButtonTheme = FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0, // Tailwind style
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static SegmentedButtonThemeData _segmentedButtonTheme(ColorScheme scheme) {
    return SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          if (states.contains(WidgetState.selected)) {
            return scheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.onSecondaryContainer;
          }
          return scheme.onSurface;
        }),
        side: WidgetStateProperty.all(BorderSide(color: scheme.outlineVariant)),
      ),
    );
  }
}
