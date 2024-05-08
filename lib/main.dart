import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Theme/colorTheme.dart';
import 'Theme/theme.dart';
import 'account/login.dart';
import 'notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  isDark = sharedPreferences.getInt('is_dark') ?? 1;
  colorOption = sharedPreferences.getString('app_bar_color') ?? 'default';
  hjel = intToString[sharedPreferences.getInt('is_dark') ?? 1]!;

  await Firebase.initializeApp();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}
