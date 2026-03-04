import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/storage_constants.dart';
import '../errors/exceptions.dart';

/// Service for managing Hive boxes and operations
class HiveService {
  static bool _isInitialized = false;

  /// Initialize Hive
  static Future<void> init() async {
    if (_isInitialized) return;

    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    _isInitialized = true;
  }

  /// Register all Hive adapters
  /// Call this after init() and before opening any boxes
  static void registerAdapters() {
    // Adapters will be registered here when we create the models
    // Example:
    // if (!Hive.isAdapterRegistered(StorageConstants.userModelTypeId)) {
    //   Hive.registerAdapter(UserHiveModelAdapter());
    // }
  }

  /// Open all required boxes
  static Future<void> openBoxes() async {
    try {
      await Future.wait([
        Hive.openBox(StorageConstants.userBox),
        Hive.openBox(StorageConstants.trailBox),
        Hive.openBox(StorageConstants.groupBox),
        Hive.openBox(StorageConstants.messageBox),
        Hive.openBox(StorageConstants.checklistBox),
        Hive.openBox(StorageConstants.paymentBox),
        Hive.openBox(StorageConstants.settingsBox),
        Hive.openBox(StorageConstants.cacheBox),
        Hive.openBox(StorageConstants.syncBox),
      ]);
    } catch (e) {
      throw CacheException(
        message: 'Failed to open Hive boxes',
        originalException: e,
      );
    }
  }

  /// Close all boxes
  static Future<void> close() async {
    try {
      await Hive.close();
    } catch (e) {
      throw CacheException(
        message: 'Failed to close Hive boxes',
        originalException: e,
      );
    }
  }

  /// Clear all data from all boxes
  static Future<void> clearAllBoxes() async {
    try {
      final boxes = [
        StorageConstants.userBox,
        StorageConstants.trailBox,
        StorageConstants.groupBox,
        StorageConstants.messageBox,
        StorageConstants.checklistBox,
        StorageConstants.paymentBox,
        StorageConstants.cacheBox,
        StorageConstants.syncBox,
      ];

      for (final boxName in boxes) {
        if (Hive.isBoxOpen(boxName)) {
          final box = Hive.box(boxName);
          await box.clear();
        }
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear Hive boxes',
        originalException: e,
      );
    }
  }

  /// Delete all boxes from disk
  static Future<void> deleteAllBoxes() async {
    try {
      await Hive.deleteFromDisk();
      _isInitialized = false;
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete Hive boxes from disk',
        originalException: e,
      );
    }
  }

  // ===========================================================================
  // GENERIC BOX OPERATIONS
  // ===========================================================================

  /// Get a box by name
  static Box<T> getBox<T>(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw CacheException(message: 'Box $boxName is not open');
    }
    return Hive.box<T>(boxName);
  }

  /// Put a value in a box
  static Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = getBox<T>(boxName);
      await box.put(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to put value in $boxName',
        originalException: e,
      );
    }
  }

  /// Get a value from a box
  static T? get<T>(String boxName, String key, {T? defaultValue}) {
    try {
      final box = getBox<T>(boxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get value from $boxName',
        originalException: e,
      );
    }
  }

  /// Delete a value from a box
  static Future<void> delete(String boxName, String key) async {
    try {
      final box = getBox(boxName);
      await box.delete(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete value from $boxName',
        originalException: e,
      );
    }
  }

  /// Get all values from a box
  static List<T> getAll<T>(String boxName) {
    try {
      final box = getBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all values from $boxName',
        originalException: e,
      );
    }
  }

  /// Clear a specific box
  static Future<void> clearBox(String boxName) async {
    try {
      final box = getBox(boxName);
      await box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear $boxName',
        originalException: e,
      );
    }
  }

  /// Check if a key exists in a box
  static bool containsKey(String boxName, String key) {
    try {
      final box = getBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check key in $boxName',
        originalException: e,
      );
    }
  }

  // ===========================================================================
  // SETTINGS BOX HELPERS
  // ===========================================================================

  /// Get a setting value
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return get<T>(StorageConstants.settingsBox, key, defaultValue: defaultValue);
  }

  /// Save a setting value
  static Future<void> saveSetting<T>(String key, T value) async {
    await put<T>(StorageConstants.settingsBox, key, value);
  }

  /// Check if this is the first launch
  static bool isFirstLaunch() {
    return getSetting<bool>(StorageConstants.isFirstLaunch, defaultValue: true) ?? true;
  }

  /// Mark first launch as completed
  static Future<void> setFirstLaunchCompleted() async {
    await saveSetting<bool>(StorageConstants.isFirstLaunch, false);
  }

  /// Check if onboarding is completed
  static bool isOnboardingCompleted() {
    return getSetting<bool>(StorageConstants.onboardingCompleted, defaultValue: false) ?? false;
  }

  /// Mark onboarding as completed
  static Future<void> setOnboardingCompleted() async {
    await saveSetting<bool>(StorageConstants.onboardingCompleted, true);
  }

  // ===========================================================================
  // CACHE HELPERS
  // ===========================================================================

  /// Check if cache is valid based on timestamp
  static bool isCacheValid(String cacheKey) {
    try {
      final timestamp = get<int>(
        StorageConstants.cacheBox,
        '${cacheKey}_timestamp',
      );
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference.inHours < StorageConstants.cacheDurationHours;
    } catch (e) {
      return false;
    }
  }

  /// Save cache with timestamp
  static Future<void> saveCache<T>(String key, T data) async {
    await put<T>(StorageConstants.cacheBox, key, data);
    await put<int>(
      StorageConstants.cacheBox,
      '${key}_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get cached data if valid
  static T? getCache<T>(String key) {
    if (!isCacheValid(key)) return null;
    return get<T>(StorageConstants.cacheBox, key);
  }

  /// Invalidate cache
  static Future<void> invalidateCache(String key) async {
    await delete(StorageConstants.cacheBox, key);
    await delete(StorageConstants.cacheBox, '${key}_timestamp');
  }
}
