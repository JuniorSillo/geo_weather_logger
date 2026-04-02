import 'package:geolocator/geolocator.dart';

import '../../core/services/notification_service.dart';
import '../../domain/entities/weather_log.dart';
import '../../domain/repositories/weather_log_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/weather_log_model.dart';

class WeatherLogRepositoryImpl implements WeatherLogRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final LocalStorageDataSource localDataSource;
  final NotificationService notificationService;

  WeatherLogRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.notificationService,
  });

  @override
  Future<List<WeatherLog>> loadLogs() async {
    return localDataSource.loadWeatherLogs();
  }

  @override
  Future<List<WeatherLog>> fetchAndSaveCurrentWeather() async {
    await _ensureLocationReady();

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final newLog = await remoteDataSource.fetchCurrentWeather(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    final currentLogs = await localDataSource.loadWeatherLogs();
    final updatedLogs = [newLog, ...currentLogs];

    await localDataSource.saveWeatherLogs(updatedLogs);
    await notificationService.showWeatherLoggedNotification(
      temperature: newLog.temperature,
    );

    return updatedLogs;
  }

  Future<void> _ensureLocationReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled in your device.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Kindly enable it in your device settings.',
      );
    }
  }
}
