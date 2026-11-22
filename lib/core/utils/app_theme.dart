import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF080D3B);
  static const primary = Color(0xFF304BFF);
  static const surface = Color(0xFF10154C);
  static const textPrimary = Color(0xFFF7F7FF);
  static const border = Color(0xFF263FC6);
  static const statusBarColor = Colors.transparent;
  static const surfaceRaised = Color(0xFF1A205C);
  static const textSecondary = Color(0xFF9AA1CC);
  static const positive = Color(0xFF26D3A0);
  static const warning = Color(0xFFFFB84D);
  static const primaryBorder = Color(0x8C304BFF);
  static const dividerColor = Color(0x269AA1CC);
  static const positiveIconBackground = Color(0x2926D3A0);
  static const warningIconBackground = Color(0x29FFB84D);
  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme:
        ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ).copyWith(
          primary: primary,
          surface: surface,
          onSurface: textPrimary,
          onPrimary: textPrimary,
          outline: border,
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
    ),
  );
}
