import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider(int isDark) {
    if (isDark == 0) {
      _themeData = amoledTheme;
      isDarkMode = true;
    } else if (isDark == 1) {
      _themeData = lightTheme;
      isDarkMode = false;
    } else if (isDark == 2) {
      _themeData = darkTheme;
      isDarkMode = true;
    }
  }

  Future<void> toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (isDark == 0) {
      sharedPreferences.setInt('is_dark', 0);
      _themeData = amoledTheme;
      isDarkMode = true;
      notifyListeners();
    }
    if (isDark == 1) {
      sharedPreferences.setInt('is_dark', 1);
      _themeData = lightTheme;
      isDarkMode = false;
    }
    if (isDark == 2) {
      sharedPreferences.setInt('is_dark', 2);
      _themeData = darkTheme;
      isDarkMode = true;
    }
    notifyListeners();
  }
}
