import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF080D3B);
  static const primary = Color(0xFF304BFF);
  static const surface = Color(0xFF10154C);
  static const textPrimary = Color(0xFFF7F7FF);
  static const border = Color(0xFF263FC6);
  static const statusBarColor = Colors.transparent;

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
  );
}
