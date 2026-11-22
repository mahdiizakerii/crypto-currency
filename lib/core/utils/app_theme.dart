import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF080D3B);
  static const primary = Color(0xFF304BFF);
  static const surface = Color(0xFF10154C);
  static const textPrimary = Color(0xFFF7F7FF);
  static const border = Color(0xFF263FC6);
  static const statusBarColor = Colors.transparent;
  static const circleShape = BoxShape.circle;
  static const keyShape = CircleBorder();

  static const loginPagePadding = EdgeInsets.fromLTRB(30, 0, 30, 28);
  static const noPadding = EdgeInsets.zero;
  static const noSpacing = 0.0;
  static const pageTopSpacing = 74.0;
  static const sectionSpacing = 28.0;
  static const titleBottomSpacing = 25.0;
  static const passcodeDotSpacing = 16.0;
  static const keypadColumnSpacing = 24.0;
  static const keypadRowSpacing = 16.0;
  static const keypadColumns = 3;
  static const keypadCellAspectRatio = 1.0;
  static const titleTextSize = 24.0;
  static const iconSize = 44.0;
  static const iconGlyphSize = 23.0;
  static const passcodeDotSize = 24.0;
  static const passcodeTextSize = 32.0;
  static const deleteIconSize = 27.0;

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
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: titleTextSize,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        color: textPrimary,
        fontSize: passcodeTextSize,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
