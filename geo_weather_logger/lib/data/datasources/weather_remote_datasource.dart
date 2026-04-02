import 'package:dio/dio.dart';

import '../models/weather_log_model.dart';



class WeatherRemoteDataSource {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<WeatherLogModel> fetchCurrentWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _dio.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'current': 'temperature_2m,weather_code',
      },
    );

    final data = response.data as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>?;

    if (current == null || current['temperature_2m'] == null) {
      throw Exception('Weather data unavailable.');
    }

    final weatherCode = current['weather_code'] as num?;

    return WeatherLogModel(
      latitude: latitude,
      longitude: longitude,
      temperature: (current['temperature_2m'] as num).toDouble(),
      condition: _mapWeatherCode(weatherCode?.toInt() ?? -1),
      loggedAt: DateTime.now(),
    );
  }

  String _mapWeatherCode(int code) {
    switch (code) {
      case 0:
        return 'The Sky Is Clear';
      case 1:
      case 2:
      case 3:
        return 'Partly cloudy';
      case 45:
      case 48:
        return 'Fog';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snow';
      case 80:
      case 81:
      case 82:
        return 'Rain showers';
      case 95:
        return 'Thunderstorm';
      default:
        return 'Unknown condition';
    }
  }
}
