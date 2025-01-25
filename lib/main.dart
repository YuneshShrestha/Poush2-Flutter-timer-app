import 'package:before_class_timer_app/bindings/binding.dart';
import 'package:before_class_timer_app/repo/notification_repo.dart';
import 'package:before_class_timer_app/screen/splash_screen.dart';
import 'package:before_class_timer_app/services/back_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Workmanager().initialize(callbackDispatcher);
  var isNotificationDenied = await Permission.notification.isDenied;
  if (isNotificationDenied) {
    await Permission.notification.request();
  }
  await initializeService();
  await NoificationRepository.notificationPlugin();
  runApp(MyApp());
}

// void callbackDispatcher() {
//   Workmanager().executeTask((taskName, inputData) async {
//     if (taskName == "timerTask") {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       int? remainingTime = inputData?['remainingTime'];
//       prefs.setInt('remainingTime', remainingTime ?? 0);
//       print('remainingTime: $remainingTime');
//       if (remainingTime != null && remainingTime > 0) {
//         remainingTime -= 1;

//         // Update remaining time in SharedPreferences
//         await prefs.setInt('remainingTime', remainingTime);

//         // Re-schedule task if time > 0
//         if (remainingTime > 0) {
//           Workmanager().registerOneOffTask(
//             "timerTask",
//             "timerTask",
//             inputData: {'remainingTime': remainingTime},
//           );
//         }
//       }
//     }
//     return Future.value(true);
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.paused) {
      print('App in background');
      FlutterBackgroundService().invoke('setAsBackground');
    } else if (state == AppLifecycleState.resumed) {
      print('App in foreground');
      FlutterBackgroundService().invoke('setAsForeground');
    }
    super.didChangeAppLifecycleState(state);
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialBinding: ControllerBinding(),
    );
  }
}
