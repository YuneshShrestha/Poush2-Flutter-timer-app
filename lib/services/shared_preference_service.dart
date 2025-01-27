import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  enterStartTime(int startTime) async {
    // seconds
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('startTime', startTime);
  }

  enterEndTime(int endTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('endTime', endTime);
  }

  // true or false
  enterIsTimerRunning(bool isTimerRunning) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isTimerRunning', isTimerRunning);
  }

  Future<int> getStartTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var startTime = prefs.getInt('startTime');
    return startTime ?? 0;
  }

  Future<int> getEndTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var endTime = prefs.getInt('endTime');
    return endTime ?? 0;
  }

  Future<bool> getIsTimerRunning() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isTimerRunning = prefs.getBool('isTimerRunning');
    return isTimerRunning ?? false;
  }
}
