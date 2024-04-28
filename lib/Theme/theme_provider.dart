import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider(bool isDark) {
    if (isDark) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      sharedPreferences.setBool('is_dark', true);
    } else {
      _themeData = lightTheme;
      sharedPreferences.setBool('is_dark', false);
    }
    notifyListeners();
  }
}
