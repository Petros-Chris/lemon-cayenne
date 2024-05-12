import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'const.dart';








// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class DownloadProvider extends ChangeNotifier {
//   var _progressList = <double>[];
//
//   // double count = 0.0;
//
//   double currentProgress(int index) {
//     //fetch the current progress,
//     //its in a list because we might want to download
//     // multiple files at the same time,
//     // so this makes sure the correct download progress
//     // is updated.
//
//
//     try {
//       return _progressList[index];
//     } catch (e) {
//       _progressList.add(0.0);
//       return 0;
//     }
//   }
//
//   void download(String filePath, int index) async {
//     NotificationService notificationService = NotificationService();
//
//     final downloadUrl = url;
//
//     final fileName = $_name-$renderTypeVal-$renderViewVal.png;
//
//     final dio = Dio();
//
//     try {
//       dio.download(downloadUrl, "/storage/emulated/0/Download/$fileName",
//           onReceiveProgress: ((count, total) async {
//             await Future.delayed(const Duration(seconds: 1), () {
//               _progressList[index] = (count / total);
//               notificationService.createNotification(
//                   100, ((count / total) * 100).toInt(), index);
//               notifyListeners();
//             });
//           }));
//     } on DioError catch (e) {
//       print("error downloading file $e");
//     }
//   }
// }
//
// class NotificationService {
//   //Hanle displaying of notifications.
//   static final NotificationService _notificationService =
//   NotificationService._internal();
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//   final AndroidInitializationSettings _androidInitializationSettings =
//   const AndroidInitializationSettings('ic_launcher');
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   NotificationService._internal() {
//     init();
//   }
//
//   void init() async {
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: _androidInitializationSettings,
//     );
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   void createNotification(int count, int i, int id) {
//     //show the notifications.
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'progress channel', 'progress channel',
//         channelDescription: 'progress channel description',
//         channelShowBadge: false,
//         importance: Importance.max,
//         priority: Priority.high,
//         onlyAlertOnce: true,
//         showProgress: true,
//         maxProgress: count,
//         progress: i);
//     var platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     _flutterLocalNotificationsPlugin.show(id, 'progress notification title',
//         'progress notification body', platformChannelSpecifics,
//         payload: 'item x');
//   }
// }









// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class NotificationService {
//   static final NotificationService _notificationService =
//   NotificationService.internal();
//
//   factory NotificationService() {
//     return _notificationService;
//   }
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   NotificationService.internal();
//
//   Future<void> initNotification() async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);
//     // the settings are initialized after they are set by the UI
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void>showNotification(int id, String title, String body) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.now(tz.local).add(Duration(seconds: 2)),
//         NotificationDetails(
//           //Android details
//           android: AndroidNotificationDetails('main_channel', "Main channel",
//               channelDescription: 'private', importance: Importance.max),
//         ),
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime,
//
//         androidAllowWhileIdle: true);
//   }
// }




// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
//
// class NotificationService {
//   static Future<void> initializeNotification() async {
//     await AwesomeNotifications().initialize(
//       null,
//       [
//         NotificationChannel(
//           channelGroupKey: 'high_importance_channel',
//           channelKey: 'high_importance_channel',
//           channelName: 'Basic notifications',
//           channelDescription: 'Notification channel for basic tests',
//           defaultColor: const Color(0xFF9D50DD),
//           ledColor: Colors.white,
//           importance: NotificationImportance.Max,
//           channelShowBadge: true,
//           onlyAlertOnce: true,
//           playSound: true,
//           criticalAlerts: true,
//         )
//       ],
//       channelGroups: [
//         NotificationChannelGroup(
//           channelGroupKey: 'high_importance_channel_group',
//           channelGroupName: 'Group 1',
//         )
//       ],
//       debug: true,
//     );
//
//     await AwesomeNotifications().isNotificationAllowed().then(
//           (isAllowed) async {
//         if (!isAllowed) {
//           await AwesomeNotifications().requestPermissionToSendNotifications();
//         }
//       },
//     );
//
//     await AwesomeNotifications().setListeners(
//       onActionReceivedMethod: onActionReceivedMethod,
//       onNotificationCreatedMethod: onNotificationCreatedMethod,
//       onNotificationDisplayedMethod: onNotificationDisplayedMethod,
//       onDismissActionReceivedMethod: onDismissActionReceivedMethod,
//     );
//   }
//
//   /// Use this method to detect when a new notification or a schedule is created
//   static Future<void> onNotificationCreatedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint('onNotificationCreatedMethod');
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   static Future<void> onNotificationDisplayedMethod(
//       ReceivedNotification receivedNotification) async {
//     debugPrint('onNotificationDisplayedMethod');
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   static Future<void> onDismissActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint('onDismissActionReceivedMethod');
//   }
//
//   /// Use this method to detect when the user taps on a notification or action button
//   static Future<void> onActionReceivedMethod(
//       ReceivedAction receivedAction) async {
//     debugPrint('onActionReceivedMethod');
//     final payload = receivedAction.payload ?? {};
//     if (payload["navigate"] == "true") {
// print("Oh man im cooked");
//     }
//   }
//
//   static Future<void> showNotification({
//     required final String title,
//     required final String body,
//     final String? summary,
//     final Map<String, String>? payload,
//     final ActionType actionType = ActionType.Default,
//     final NotificationLayout notificationLayout = NotificationLayout.Default,
//     final NotificationCategory? category,
//     final String? bigPicture,
//     final List<NotificationActionButton>? actionButtons,
//     final bool scheduled = false,
//     final int? interval,
//   }) async {
//     assert(!scheduled || (scheduled && interval != null));
//
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: -1,
//         channelKey: 'high_importance_channel',
//         title: title,
//         body: body,
//         actionType: actionType,
//         notificationLayout: notificationLayout,
//         summary: summary,
//         category: category,
//         payload: payload,
//         bigPicture: bigPicture,
//       ),
//       actionButtons: actionButtons,
//       schedule: scheduled
//           ? NotificationInterval(
//         interval: interval,
//         timeZone:
//         await AwesomeNotifications().getLocalTimeZoneIdentifier(),
//         preciseAlarm: true,
//       )
//           : null,
//     );
//   }
// }