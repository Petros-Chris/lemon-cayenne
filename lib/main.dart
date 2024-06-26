import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Theme/color_theme.dart';
import 'Theme/theme.dart';
import 'account/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDisplayMode.setHighRefreshRate();

  //For Dark Mode Stuff
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isDark = sharedPreferences.getInt('is_dark') ?? 1;
  colorOption = sharedPreferences.getString('app_bar_color') ?? 'default';
  hjel = intToString[sharedPreferences.getInt('is_dark') ?? 1]!;

  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        ledColor: Colors.pink,
        enableVibration: true,
        channelKey: "download_channel",
        channelName: "Notifications",
        channelDescription: 'Notifications For The User',
        importance: NotificationImportance.Max,
      ),
    ],
  );
  runApp(const MyApp());
}
