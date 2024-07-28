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
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF9f7bf6), // Цвет выбранной иконки
      unselectedItemColor:
          const Color(0xFF4ceb8b).withOpacity(0.5), // Цвет невыбранной иконки
      backgroundColor: Colors.transparent, // Прозрачный фон
      // Убираем тень
    ),
  );
}


