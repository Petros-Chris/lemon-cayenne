import 'package:flutter/material.dart';

late bool isDark;

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
    background: Colors.black,
  ),

  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.black,
  ),
  //   appBarTheme: AppBarTheme(
  //   backgroundColor: Colors.black,
  // ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  textTheme: const TextTheme(
    displayMedium: TextStyle(fontSize: 24),
  ),
);

final ThemeData lightTheme = ThemeData();
