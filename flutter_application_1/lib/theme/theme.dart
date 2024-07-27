import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9F7BF6),
      brightness: Brightness.light,
      primary: const Color(0xFF9F7BF6),
      secondary: const Color(0xFF4CEB8B),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white) ,
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );
}
