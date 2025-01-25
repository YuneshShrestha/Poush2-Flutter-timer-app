import 'dart:async';
import 'dart:ui';

import 'package:before_class_timer_app/services/shared_preference_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      var isForeground = await service.isForegroundService();
      print("Foreground: $isForeground");
      if (!isForeground) {
        // save current timer value to shared preferences
        var inputTime = await SharedPreferenceService().getRemainingTime();
        inputTime -= 1;
        print("Remaining time: $inputTime");
        await SharedPreferenceService().enterTime(inputTime);
      }

      service.invoke("update");
    }
  });
}
