import 'package:before_class_timer_app/binding/controller_binding.dart';
import 'package:before_class_timer_app/screen/splash_screen.dart';
import 'package:before_class_timer_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var isDenied = await Permission.notification.isDenied;

  if (isDenied) {
    Permission.notification.request();
  }
  NotificationService.initializeNotificationsPlugin();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinding(),
      home: SplashScreen(),
    );
  }
}
