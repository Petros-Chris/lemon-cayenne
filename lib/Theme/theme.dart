import 'package:flutter/material.dart';

late int isDark;
late bool isDarkMode;
late String hjel;
final Map<int, String> intToString = {
  0: 'Amoled',
  1: 'Light',
  2: 'Dark',
};
final Map<String, int> stringToInt = {
  'Amoled': 0,
  'Light': 1,
  'Dark': 2,
};

const inputColor = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Colors.yellow,
    Colors.orange,
  ],
);

final ThemeData amoledTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.dark,
      background: Colors.black,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.black,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.red)));

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3A3A3A),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);
