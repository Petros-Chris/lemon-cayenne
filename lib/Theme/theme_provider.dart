import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// I can proably make this even smaller as my understanding of it has increased :>
class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  ThemeProvider(int isDark) {
    if (isDark == 0) {
      _themeData = amoledTheme;
    } else if (isDark == 1) {
      _themeData = lightTheme;
    } else if (isDark == 2) {
      _themeData = darkTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (isDark == 0) {
      sharedPreferences.setInt('is_dark', 0);
      _themeData = amoledTheme;
    }
    if (isDark == 1) {
      sharedPreferences.setInt('is_dark', 1);
      _themeData = lightTheme;
    }
    if (isDark == 2) {
      sharedPreferences.setInt('is_dark', 2);
      _themeData = darkTheme;
    }
    notifyListeners();
  }
}
