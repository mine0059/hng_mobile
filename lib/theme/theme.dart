import 'package:flutter/material.dart';

enum AppTheme {
  lightTheme,
  darkTheme,
}

class AppThemes {
  static final appThemeData = {
    AppTheme.darkTheme: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Colors.grey.shade900,
        primary: Colors.blue,
        // primary: Colors.grey.shade800,
        secondary: Colors.grey.shade700,
        inversePrimary: Colors.grey.shade300,
        onPrimary: Colors.white.withOpacity(0.6),
      ),
    ),
    AppTheme.lightTheme: ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: Colors.grey.shade300,
        primary: Colors.blue,
        // primary: Colors.grey.shade200,
        secondary: Colors.grey.shade400,
        inversePrimary: Colors.grey.shade800,
        onPrimary: Colors.black.withOpacity(0.6),
      ),
    ),
  };
}
