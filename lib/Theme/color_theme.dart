import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> colorOptionsLight = ['default', 'green', 'blue', 'red', 'yellow'];
List<String> colorOptions = ['default', 'green', 'blue', 'red', 'yellow'];
List<String> colorOptionsDark = ['default', 'dark blue', 'dark red', 'dark purple', 'dark orange'];
var colorOption = "default";

class ColorProvider with ChangeNotifier {
  Color? appColor;

  Color? get color => appColor;

  ColorProvider(String colorOption) {
    switch(colorOption) {
      case "blue": appColor = Colors.blue; break;
      case "red": appColor = Colors.red; break;
      case "green": appColor = Colors.green; break;
      case "yellow": appColor = Colors.yellow; break;
      case "dark red": appColor = const Color(0x94961111); break;
      case "dark blue": appColor = const Color(0x94333FFD); break;
      case "dark orange": appColor = const Color(0x94C46B02); break;
      case "dark purple": appColor = const Color(0x945900B7); break;
      default: appColor = null;
    }
  }

  void toggleColor() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    switch(colorOption) {
      case "blue": {
        sharedPreferences.setString('app_bar_color', 'blue');
        appColor = Colors.blue;
        break;
      }
      case "green": {
        sharedPreferences.setString('app_bar_color', 'green');
        appColor = Colors.green;
        break;
      }
      case "red": {
        sharedPreferences.setString('app_bar_color', 'red');
        appColor = Colors.red;
        break;
      }
      case "dark red": {
        sharedPreferences.setString('app_bar_color', 'dark red');
        appColor = const Color(0x94961111);
        break;
      }
      case "dark blue": {
        sharedPreferences.setString('app_bar_color', 'dark blue');
        appColor = const Color(0x94333FFD);
        break;
      }
      case "dark orange": {
        sharedPreferences.setString('app_bar_color', 'dark orange');
        appColor = const Color(0x94C46B02);
        break;
      }
      case "dark purple": {
        sharedPreferences.setString('app_bar_color', 'dark purple');
        appColor = const Color(0x945900B7);
        break;
      }
      case "yellow": {
        sharedPreferences.setString('app_bar_color', 'yellow');
        appColor = Colors.yellow;
        break;
      }
      default: {
        sharedPreferences.setString('app_bar_color', 'default');
        appColor = null;
      }
    }
    notifyListeners();
  }
}
