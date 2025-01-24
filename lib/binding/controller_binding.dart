import 'package:before_class_timer_app/controller/timer_animation_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TimerAnimationController());
  }
}
