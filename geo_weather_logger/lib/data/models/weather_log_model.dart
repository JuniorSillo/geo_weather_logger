import '../../domain/entities/weather_log.dart';

class WeatherLogModel extends WeatherLog {
  const WeatherLogModel({
    required super.latitude,
    required super.longitude,
    required super.temperature,
    required super.condition,
    required super.loggedAt,
  });

  factory WeatherLogModel.fromJson(Map<String, dynamic> json) {
    return WeatherLogModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      condition: json['condition'] as String,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'temperature': temperature,
      'condition': condition,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  factory WeatherLogModel.fromEntity(WeatherLog log) {
    return WeatherLogModel(
      latitude: log.latitude,
      longitude: log.longitude,
      temperature: log.temperature,
      condition: log.condition,
      loggedAt: log.loggedAt,
    );
  }
}
