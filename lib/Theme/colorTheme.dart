import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<String> colorOptions = ['default', 'green', 'blue', 'red', 'yellow'];
var colorOption = "default";

class ColorProvider with ChangeNotifier {
  Color? appColor;

  Color? get color => appColor;

  ColorProvider(String colorOption) {
    if (colorOption == "blue") {
      appColor = Colors.blue;
    } else if (colorOption == "red") {
      appColor = Colors.red;
    } else if (colorOption == "green") {
      appColor = Colors.green;
    } else if (colorOption == "default") {
      appColor = null;
    } else if (colorOption == "yellow") {
      appColor = Colors.yellow;
    }
  }

  void toggleColor() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (colorOption == 'default') {
      sharedPreferences.setString('app_bar_color', 'default');
      appColor = null;
    }
    if (colorOption == 'green') {
      sharedPreferences.setString('app_bar_color', 'green');
      appColor = Colors.green;
    }
    if (colorOption == 'red') {
      sharedPreferences.setString('app_bar_color', 'red');
      appColor = Colors.red;
    }
    if (colorOption == 'blue') {
      sharedPreferences.setString('app_bar_color', 'blue');
      appColor = Colors.blue;
    }
    if (colorOption == 'yellow') {
      sharedPreferences.setString('app_bar_color', 'yellow');
      appColor = Colors.yellow;
    }
    notifyListeners();
  }
}
