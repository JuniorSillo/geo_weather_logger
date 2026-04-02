import 'package:flutter/material.dart';

import '../../domain/repositories/theme_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeRepository _themeRepository;

  ThemeProvider(this._themeRepository);

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadTheme() async {
    final isDarkMode = await _themeRepository.loadIsDarkMode();
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _themeMode = value ? ThemeMode.dark : ThemeMode.light;
    await _themeRepository.saveIsDarkMode(value);
    notifyListeners();
  }
}
