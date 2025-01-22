import 'dart:async';

import 'package:before_class_timer_app/repo/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class MyAnimationController extends GetxController {
  Artboard? riveArtBoard;
  SMIBool? processing;
  SMITrigger? shake;
  var currentTime = 0.obs;
  Timer? timer;

  startTime() {
    if (currentTime.value > 0) {
      if (processing != null) {
        processing!.value = true;
      }
      NoificationRepository().scheduleNotification(currentTime.value);

      Timer.periodic(Duration(seconds: 1), (timer) {
        this.timer = timer;
        currentTime.value--;
        if (currentTime.value == 0) {
          timer.cancel();
          if (processing != null) {
            processing!.value = false;
          }
          flutterLocalNotificationsPlugin.show(
            0,
            'Time is up',
            'Time is up',
            NotificationDetails(
              android: AndroidNotificationDetails(
                NoificationRepository.channel.id,
                NoificationRepository.channel.name,
                
                importance: Importance.high,
                priority: Priority.high,
              ),
            ),
          );
        }
      });
    }

    update();
  }

  stopAndResetTime() {
    if (timer != null) {
      timer!.cancel();
    }
    
    if (processing != null) {
      processing!.value = false;
      shake!.value = true;
      currentTime.value = 0;
    }
    update();
  }

  loadRiveFile() async {
    await RiveFile.initialize();
    String rivePath = 'assets/pes.riv';
    var data = await rootBundle.load(rivePath);
    var file = RiveFile.import(data);

    riveArtBoard = file.mainArtboard;
    // controller
    // StateMachineController
    if (riveArtBoard != null) {
      var controller = StateMachineController.fromArtboard(
        riveArtBoard!,
        'State Machine 1',
      );
      if (controller != null) {
        riveArtBoard!.addController(controller);
        controller.stateMachine.inputs.forEach((e) {
          print(e.name + " " + e.runtimeType.toString());
        });
        processing = controller.findSMI('Processing');
        shake = controller.findSMI('Shake');
      }
      update();
    }
  }

  @override
  void onInit() {
    loadRiveFile();
    super.onInit();
  }
}
