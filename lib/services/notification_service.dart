import 'package:before_class_timer_app/screen/home_screeen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static var channel = AndroidNotificationChannel(
    '1',
    'Timer Notification',
    description: 'This channel used for timer notifcations.',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound(
      'notification',
    ),
  );
  static initializeNotificationsPlugin() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    notificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      ),
      onDidReceiveNotificationResponse: (details) {
        Get.to(() {
          return HomeScreeen();
        });
      },
    );
  }

  static scheduleNotification(int timeInSeconds) async {
    tz.initializeTimeZones();
    notificationsPlugin.zonedSchedule(
      1,
      'Time Up',
      ' Your Time is Up',
      tz.TZDateTime.now(tz.local).add(Duration(
        seconds: timeInSeconds,
      )),
      NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationService.channel.id,
          NotificationService.channel.name,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }
}
