import 'package:flutter/material.dart';

late int isDark;
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

final ThemeData amoledTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
    background: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.black,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(fontSize: 24),
  ),
);

final ThemeData lightTheme = ThemeData();

final ThemeData darkTheme = ThemeData.dark();
