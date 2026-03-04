import 'package:hive/hive.dart';

import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/trail_model.dart';

/// Local data source for trail operations
abstract class TrailLocalDataSource {
  /// Get cached trails
  Future<List<TrailModel>> getCachedTrails();

  /// Get a single cached trail by ID
  Future<TrailModel?> getCachedTrailById(String id);

  /// Cache trails locally
  Future<void> cacheTrails(List<TrailModel> trails);

  /// Cache a single trail
  Future<void> cacheTrail(TrailModel trail);

  /// Clear cached trails
  Future<void> clearCachedTrails();

  /// Check if trails are cached
  Future<bool> hasCache();

  /// Get cache timestamp
  Future<DateTime?> getCacheTimestamp();

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid();
}

/// Implementation of TrailLocalDataSource
class TrailLocalDataSourceImpl implements TrailLocalDataSource {
  // Cache key for timestamp
  static const String _cacheTimestampKey = 'trails_cache_timestamp';

  TrailLocalDataSourceImpl();

  Future<Box<TrailModel>> get _trailBox async {
    if (!Hive.isBoxOpen(StorageConstants.trailBox)) {
      return await Hive.openBox<TrailModel>(StorageConstants.trailBox);
    }
    return Hive.box<TrailModel>(StorageConstants.trailBox);
  }

  Future<Box<dynamic>> get _cacheBox async {
    if (!Hive.isBoxOpen(StorageConstants.cacheBox)) {
      return await Hive.openBox(StorageConstants.cacheBox);
    }
    return Hive.box(StorageConstants.cacheBox);
  }

  @override
  Future<List<TrailModel>> getCachedTrails() async {
    try {
      final box = await _trailBox;
      return box.values.toList();
    } catch (e) {
      // If cached data is corrupted or has unexpected types, clear cache
      try {
        await clearCachedTrails();
      } catch (_) {}
      return [];
    }
  }

  @override
  Future<TrailModel?> getCachedTrailById(String id) async {
    try {
      final box = await _trailBox;
      return box.get(id);
    } catch (e) {
      // If cached data is corrupted or has unexpected types, clear cache
      try {
        await clearCachedTrails();
      } catch (_) {}
      return null;
    }
  }

  @override
  Future<void> cacheTrails(List<TrailModel> trails) async {
    try {
      final box = await _trailBox;
      final cacheBox = await _cacheBox;

      // Clear existing cache
      await box.clear();

      // Save all trails
      final Map<String, TrailModel> trailMap = {
        for (var trail in trails) trail.id: trail
      };
      await box.putAll(trailMap);

      // Update cache timestamp in cacheBox
      await cacheBox.put(_cacheTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException(message: 'Failed to cache trails: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheTrail(TrailModel trail) async {
    try {
      final box = await _trailBox;
      await box.put(trail.id, trail);
    } catch (e) {
      throw CacheException(message: 'Failed to cache trail: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCachedTrails() async {
    try {
      final box = await _trailBox;
      final cacheBox = await _cacheBox;
      await box.clear();
      await cacheBox.delete(_cacheTimestampKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached trails: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasCache() async {
    try {
      final box = await _trailBox;
      return box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final cacheBox = await _cacheBox;
      final timestamp = cacheBox.get(_cacheTimestampKey) as String?;
      if (timestamp == null) return null;
      return DateTime.parse(timestamp);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final cacheBox = await _cacheBox;
      final timestamp = cacheBox.get(_cacheTimestampKey) as String?;
      if (timestamp == null) return false;

      final cacheTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference.inHours < StorageConstants.cacheDurationHours;
    } catch (e) {
      return false;
    }
  }
}
