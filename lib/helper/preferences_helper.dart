import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  PreferencesHelper({required this.sharedPreferences});

  static const dailyResto = 'DAILY_RESTAURANTS';
  Future<bool> get isDailyResto async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyResto) ?? false;
  }

  void setDailyResto(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyResto, value);
  }
}
