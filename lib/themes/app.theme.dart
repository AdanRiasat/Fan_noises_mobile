import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF141418);
  static const Color secondary = Color(0xFF3F3B55);
  static const Color accent = Color(0xFF6F6A8A);
  static const Color primaryText = Color(0xFFE5E5EB);
  static const Color secondaryText = Color(0xFFA1A1B3);
  static const Color border = Color(0xFF1E1E26);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primary,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: primaryText),
      bodyMedium: TextStyle(color: secondaryText),
    ),

    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: border,
      onPrimary: Colors.white,
      onSurface: primaryText,
    ),

    iconTheme: const IconThemeData(color: secondaryText),

    appBarTheme: const AppBarTheme(
      backgroundColor: border,
      elevation: 0,
      iconTheme: IconThemeData(color: accent),
    ),

    useMaterial3: true,
  );
}
