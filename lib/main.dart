import 'package:before_class_timer_app/bindings/binding.dart';
import 'package:before_class_timer_app/repo/notification_repo.dart';
import 'package:before_class_timer_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialBinding: ControllerBinding(),
    );
  }
}
