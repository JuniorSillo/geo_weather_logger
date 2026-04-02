import '../../domain/repositories/theme_repository.dart';
import '../datasources/local_storage_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final LocalStorageDataSource localStorageDataSource;

  ThemeRepositoryImpl({required this.localStorageDataSource});

  @override
  Future<bool> loadIsDarkMode() {
    return localStorageDataSource.loadDarkMode();
  }

  @override
  Future<void> saveIsDarkMode(bool isDarkMode) {
    return localStorageDataSource.saveDarkMode(isDarkMode);
  }
}
