import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../constants/storage_constants.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../features/auth/data/datasources/remote/auth_remote_datasource.dart';

/// Service that syncs pending profile updates when connectivity is restored.
class ProfileSyncService {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  StreamSubscription<bool>? _connectivitySubscription;

  static const String _pendingProfileUpdateKey = 'pending_profile_update';

  ProfileSyncService({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Box<dynamic> get _syncBox => Hive.box(StorageConstants.syncBox);

  /// Start listening for connectivity changes to sync pending updates.
  void startListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = networkInfo.onConnectivityChanged.listen(
      (isConnected) {
        if (isConnected) {
          syncPendingProfileUpdate();
        }
      },
    );
  }

  /// Stop listening for connectivity changes.
  void stopListening() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Save a pending profile update to Hive sync box.
  Future<void> savePendingProfileUpdate(Map<String, dynamic> fields) async {
    await _syncBox.put(_pendingProfileUpdateKey, fields);
  }

  /// Check if there is a pending profile update.
  bool hasPendingUpdate() {
    return _syncBox.containsKey(_pendingProfileUpdateKey);
  }

  /// Sync pending profile update to the server.
  Future<bool> syncPendingProfileUpdate() async {
    if (!hasPendingUpdate()) return true;

    try {
      if (!await networkInfo.isConnected) return false;

      final pendingData = _syncBox.get(_pendingProfileUpdateKey);
      if (pendingData == null) return true;

      final fields = Map<String, dynamic>.from(pendingData as Map);

      final userModel = await remoteDataSource.updateProfile(
        name: fields['name'] as String?,
        phone: fields['phone'] as String?,
        bio: fields['bio'] as String?,
        ageGroup: fields['ageGroup'] as String?,
        hikerType: fields['hikerType'] as String?,
        emergencyContactName: fields['emergencyContactName'] as String?,
        emergencyContactPhone: fields['emergencyContactPhone'] as String?,
      );

      // Update local cache with server response
      await localDataSource.clearCachedUser();
      await localDataSource.cacheUser(userModel);

      // Remove pending update
      await _syncBox.delete(_pendingProfileUpdateKey);

      debugPrint('[ProfileSync] Pending profile update synced successfully');
      return true;
    } catch (e) {
      debugPrint('[ProfileSync] Failed to sync profile update: $e');
      return false;
    }
  }
}
