import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  enterTime(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('remainingTime', time);
  }
  enterStartExacTime(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('startExacTime', time);
  }
  enterEndExacTime(int time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('endExacTime', time);
  }
  enterIsTimerRunning(bool isRunning) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTimerRunning', isRunning);
  }

  Future<int> getRemainingTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? remainingTime = prefs.getInt('remainingTime');
    if (remainingTime == null || remainingTime < 0) {
      return 0;
    }
    return remainingTime;
  }
  Future<int> getStartExacTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? startExacTime = prefs.getInt('startExacTime');
    if (startExacTime == null || startExacTime < 0) {
      return 0;
    }
    return startExacTime;
  }
  Future<int> getEndExacTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? endExacTime = prefs.getInt('endExacTime');
    if (endExacTime == null || endExacTime < 0) {
      return 0;
    }
    return endExacTime;
  }
  Future<bool> getIsTimerRunning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isTimerRunning = prefs.getBool('isTimerRunning');
    if (isTimerRunning == null) {
      return false;
    }
    return isTimerRunning;
  }

}
