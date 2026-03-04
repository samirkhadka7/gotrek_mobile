import 'package:hive_flutter/hive_flutter.dart';

/// Repository for managing theme preferences
class ThemeRepository {
  static const String _boxName = 'theme_preferences';
  static const String _themeModeKey = 'theme_mode';

  /// Save theme mode preference
  Future<void> saveThemeMode(String mode) async {
    try {
      final box = Hive.box<String>(_boxName);
      await box.put(_themeModeKey, mode);
    } catch (e) {
      throw Exception('Failed to save theme preference: $e');
    }
  }

  /// Get saved theme mode preference
  Future<String> getThemeMode() async {
    try {
      final box = Hive.box<String>(_boxName);
      final mode = box.get(_themeModeKey, defaultValue: 'system');
      return mode!;
    } catch (e) {
      throw Exception('Failed to load theme preference: $e');
    }
  }

  /// Initialize theme box
  static Future<void> initializeThemeBox() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        await Hive.openBox<String>(_boxName);
      }
    } catch (e) {
      throw Exception('Failed to initialize theme box: $e');
    }
  }
}
