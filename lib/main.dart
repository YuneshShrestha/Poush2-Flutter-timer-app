import 'package:before_class_timer_app/bindings/binding.dart';
import 'package:before_class_timer_app/repo/notification_repo.dart';
import 'package:before_class_timer_app/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NoificationRepository.notificationPlugin();
  runApp(MyApp());
}

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
