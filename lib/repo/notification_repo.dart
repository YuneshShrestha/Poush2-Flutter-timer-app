import 'package:before_class_timer_app/screen/home_screeen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NoificationRepository {
  static AndroidNotificationChannel channel = AndroidNotificationChannel(
    '1',
    'Timer Notification',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    // play your custom sound
    sound: RawResourceAndroidNotificationSound(
      'notification',
    ),
    // playSound: true,
  );
// Creating notification channel
  static Future<void> notificationPlugin() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
// Android Initialization
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

// // iOS initialization
//     DarwinInitializationSettings iosInitializationSettings =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,

//     );
// Initializing android and iOS settings
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
// Initializing flutter local notification
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      await Get.to(
        () => HomeScreeen(),
      );
    });
  }

  scheduleNotification(int time) async {
    tz.initializeTimeZones();
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Times Up',
      'Times Up',
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: time)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              'stop',
              'Stop',
              showsUserInterface: true,
              cancelNotification: true,
            ),
          ],
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
