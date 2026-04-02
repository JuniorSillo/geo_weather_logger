class WeatherLog {
  final double latitude;
  final double longitude;
  final double temperature;
  final String condition;
  final DateTime loggedAt;

  const WeatherLog({
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.condition,
    required this.loggedAt,
  });
}

