import 'package:hive/hive.dart';

import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../models/group_model.dart';

/// Local data source for group operations using Hive
abstract class GroupLocalDataSource {
  /// Get all cached groups
  Future<List<GroupModel>> getCachedGroups();

  /// Get a single cached group by ID
  Future<GroupModel?> getCachedGroupById(String id);

  /// Cache groups
  Future<void> cacheGroups(List<GroupModel> groups);

  /// Cache a single group
  Future<void> cacheGroup(GroupModel group);

  /// Remove a cached group
  Future<void> removeCachedGroup(String id);

  /// Clear all cached groups
  Future<void> clearCache();

  /// Check if cache is valid (not expired)
  Future<bool> isCacheValid();
}

/// Implementation of GroupLocalDataSource using Hive
class GroupLocalDataSourceImpl implements GroupLocalDataSource {
  final Box<GroupModel> groupBox;
  final Box<dynamic> cacheBox;

  static const _cacheTimestampKey = 'groups_cache_timestamp';
  static const _cacheDurationHours = StorageConstants.cacheDurationHours;

  GroupLocalDataSourceImpl({
    required this.groupBox,
    required this.cacheBox,
  });

  @override
  Future<List<GroupModel>> getCachedGroups() async {
    try {
      return groupBox.values.toList();
    } catch (e) {
      throw CacheException(message: 'Error fetching cached groups: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel?> getCachedGroupById(String id) async {
    try {
      return groupBox.get(id);
    } catch (e) {
      throw CacheException(message: 'Error fetching cached group: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheGroups(List<GroupModel> groups) async {
    try {
      // Clear existing cache
      await groupBox.clear();

      // Add new groups
      final groupsMap = {for (var group in groups) group.id: group};
      await groupBox.putAll(groupsMap);

      // Update cache timestamp
      await cacheBox.put(_cacheTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      throw CacheException(message: 'Error caching groups: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheGroup(GroupModel group) async {
    try {
      await groupBox.put(group.id, group);
    } catch (e) {
      throw CacheException(message: 'Error caching group: ${e.toString()}');
    }
  }

  @override
  Future<void> removeCachedGroup(String id) async {
    try {
      await groupBox.delete(id);
    } catch (e) {
      throw CacheException(message: 'Error removing cached group: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await groupBox.clear();
      await cacheBox.delete(_cacheTimestampKey);
    } catch (e) {
      throw CacheException(message: 'Error clearing group cache: ${e.toString()}');
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestampStr = cacheBox.get(_cacheTimestampKey) as String?;
      if (timestampStr == null) return false;

      final timestamp = DateTime.parse(timestampStr);
      final now = DateTime.now();
      final difference = now.difference(timestamp);

      return difference.inHours < _cacheDurationHours;
    } catch (e) {
      return false;
    }
  }
}
