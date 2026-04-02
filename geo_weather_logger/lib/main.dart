import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/notification_service.dart';
import 'data/datasources/local_storage_datasource.dart';
import 'data/datasources/weather_remote_datasource.dart';
import 'data/repositories/theme_repository_impl.dart';
import 'data/repositories/weather_log_repository_impl.dart';
import 'firebase_options.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/weather_log_provider.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localStorageDataSource = LocalStorageDataSource();
  final notificationService = NotificationService();
  await notificationService.initialize();

  final weatherLogRepository = WeatherLogRepositoryImpl(
    remoteDataSource: WeatherRemoteDataSource(),
    localDataSource: localStorageDataSource,
    notificationService: notificationService,
  );

  final themeRepository = ThemeRepositoryImpl(
    localStorageDataSource: localStorageDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(themeRepository)..loadTheme(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherLogProvider(weatherLogRepository)..loadLogs(),
        ),
      ],
      child: const GeoWeatherLoggerApp(),
    ),
  );
}

class GeoWeatherLoggerApp extends StatelessWidget {
  const GeoWeatherLoggerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Geo-Weather Logger',
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData) {
                return const DashboardScreen();
              }

              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}
