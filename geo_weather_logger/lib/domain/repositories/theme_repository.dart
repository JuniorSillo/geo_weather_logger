abstract class ThemeRepository {
  Future<bool> loadIsDarkMode();
  Future<void> saveIsDarkMode(bool isDarkMode);
}


abstract class LightThemeRepository {
  Future<bool> loadIsLightMode();
  Future<void> saveIsLightMode(bool isLightMode);
}

