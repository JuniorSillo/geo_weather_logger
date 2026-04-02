import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather_log_model.dart';

class LocalStorageDataSource {
  static const String weatherLogsKey = 'weather_logs';
  static const String darkModeKey = 'is_dark_mode';

  Future<void> saveWeatherLogs(List<WeatherLogModel> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = logs.map((log) => jsonEncode(log.toJson())).toList();
    await prefs.setStringList(weatherLogsKey, encoded);
  }

  Future<List<WeatherLogModel>> loadWeatherLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList(weatherLogsKey) ?? [];

    return encoded
        .map((item) => WeatherLogModel.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> saveDarkMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(darkModeKey, isDarkMode);
  }

  Future<bool> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(darkModeKey) ?? false;
  }
}
