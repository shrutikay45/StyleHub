import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF111111);
  static const Color background = Color(0xFFFAF9F7);
  static const Color accent = Color(0xFFC98B8B);
  static const Color secondaryText = Color(0xFF777777);
  static const Color beige = Color(0xFFD8C3A5);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: primary,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: primary,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: primary,
      ),
      bodyMedium: TextStyle(
        color: secondaryText,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}