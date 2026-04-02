import 'package:flutter/material.dart';

import '../../domain/entities/weather_log.dart';
import '../../domain/repositories/weather_log_repository.dart';

class WeatherLogProvider extends ChangeNotifier {
  final WeatherLogRepository _repository;

  WeatherLogProvider(this._repository);

  final List<WeatherLog> _logs = [];
  List<WeatherLog> get logs => List.unmodifiable(_logs);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadLogs() async {
    _setLoading(true);
    try {
      _logs
        ..clear()
        ..addAll(await _repository.loadLogs());
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCurrentWeatherLog() async {
    _setLoading(true);
    try {
      final updatedLogs = await _repository.fetchAndSaveCurrentWeather();
      _logs
        ..clear()
        ..addAll(updatedLogs);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

