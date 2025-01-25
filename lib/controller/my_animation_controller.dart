import 'dart:async';

import 'package:before_class_timer_app/repo/notification_repo.dart';
import 'package:before_class_timer_app/services/shared_preference_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

// import 'package:workmanager/workmanager.dart';

class MyAnimationController extends GetxController {
  Artboard? riveArtBoard;
  SMIBool? processing;
  SMITrigger? shake;
  var currentTime = 0.obs;
  Timer? timer;

  startTime() async {
    if (currentTime.value > 0) {
      if (processing != null) {
        processing!.value = true;
      }

      NoificationRepository().scheduleNotification(currentTime.value);
      var hasTimeStarted = await SharedPreferenceService().getIsTimerRunning();
      var endExacTime = await SharedPreferenceService().getEndExacTime();
      if (!hasTimeStarted ||
          endExacTime < DateTime.now().millisecondsSinceEpoch) {
        SharedPreferenceService().enterIsTimerRunning(true);
        SharedPreferenceService()
            .enterStartExacTime(DateTime.now().millisecondsSinceEpoch);
        SharedPreferenceService().enterEndExacTime(
          DateTime.now().millisecondsSinceEpoch + (currentTime.value * 1000),
        );
      }
      Timer.periodic(Duration(seconds: 1), (timer) {
        this.timer = timer;
        currentTime.value--;

        SharedPreferenceService().enterTime(currentTime.value);

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
      update();
    }
  }

  Future<void> _loadSavedTime() async {
    try {
      // var inputTime = await SharedPreferenceService().getRemainingTime();
      // if (inputTime > 0) {
      //   currentTime.value = inputTime;
      //   startTime();
      // }
      var startExacTime = await SharedPreferenceService().getStartExacTime();
      var endExacTime = await SharedPreferenceService().getEndExacTime();
      if (startExacTime > 0 && endExacTime > 0) {
        var currentTime = endExacTime - DateTime.now().millisecondsSinceEpoch;
        if (currentTime > 0) {
          this.currentTime.value = (currentTime / 1000).round();
          startTime();
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // void startBackgroundTimer() {
  //   if (currentTime.value > 0) {
  //     Workmanager().registerOneOffTask(
  //       "timerTask",
  //       "timerTask",
  //       inputData: {'remainingTime': currentTime.value},
  //     );
  //   }
  // }

  stopAndResetTime() async {
    if (timer != null) {
      timer!.cancel();
    }
    NoificationRepository().stopNotification();

    if (processing != null) {
      processing!.value = false;
      shake!.value = true;
      currentTime.value = 0;
    }
    // // Cancel WorkManager tasks
    // Workmanager().cancelByUniqueName("timerTask");

    // // Clear saved time
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('remainingTime');

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
    _loadSavedTime();
    super.onInit();
  }
}
