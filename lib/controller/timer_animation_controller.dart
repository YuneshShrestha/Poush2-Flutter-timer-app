import 'dart:async';

import 'package:before_class_timer_app/services/notification_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class TimerAnimationController extends GetxController {
  Artboard? riveArtBoard;
  SMIBool? processing;
  SMITrigger? shake;
  var currentTimeInSeconds = 0.obs;
  Timer? timer;

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
    }
    update();
  }

  start() {
    // Timer (1 sec) {decrease}
    if (currentTimeInSeconds > 0) {
      NotificationService.scheduleNotification(
        currentTimeInSeconds.value,
      );
      Timer.periodic(
          Duration(
            seconds: 1,
          ), (timer) {
        this.timer = timer;
        currentTimeInSeconds--;
        if (currentTimeInSeconds == 0) {
          timer.cancel();
          stop();
        }
      });
      if (processing != null) {
        processing!.value = true;
      }
      update();
    }
  }

  stop() {
    if (processing != null && shake != null) {
      if (timer != null) {
        timer!.cancel();
        currentTimeInSeconds.value = 0;
      }
      shake!.fire();
      processing!.value = false;
    }
  }

  @override
  void onInit() {
    loadRiveFile();
    super.onInit();
  }
}
