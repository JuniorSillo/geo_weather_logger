import '../entities/weather_log.dart';

abstract class WeatherLogRepository {
  Future<List<WeatherLog>> loadLogs();
  Future<List<WeatherLog>> fetchAndSaveCurrentWeather();
}


