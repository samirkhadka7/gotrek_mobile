import 'package:hive/hive.dart';

import '../../../../../core/constants/storage_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/services/secure_storage_service.dart';
import '../../models/user_model.dart';

/// Local data source for authentication operations
abstract class AuthLocalDataSource {
  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Clear cached user
  Future<void> clearCachedUser();

  /// Save access token
  Future<void> saveToken(String token);

  /// Get access token
  Future<String?> getToken();

  /// Clear access token
  Future<void> clearToken();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Save user credentials for session
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String role,
    required String token,
  });

  /// Clear all auth data (logout)
  Future<void> clearAllAuthData();
}

/// Implementation of AuthLocalDataSource
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  Box<dynamic> get _userBox => Hive.box(StorageConstants.userBox);

  Future<Box<dynamic>> _ensureUserBoxOpen() async {
    if (!Hive.isBoxOpen(StorageConstants.userBox)) {
      return await Hive.openBox(StorageConstants.userBox);
    }
    return _userBox;
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final box = await _ensureUserBoxOpen();
      // Clear old cache first to ensure atomic update
      await box.delete('current_user');
      // Store as JSON map with timestamp for compatibility and cache validation
      final userData = user.toJson();
      // Add cache timestamp for expiration checking
      userData['cached_at'] = DateTime.now().millisecondsSinceEpoch;
      await box.put('current_user', userData);
    } catch (e) {
      // Try to recover by clearing the box
      try {
        if (Hive.isBoxOpen(StorageConstants.userBox)) {
          final box = Hive.box(StorageConstants.userBox);
          await box.clear();
        }
        final freshBox = await _ensureUserBoxOpen();
        final userData = user.toJson();
        userData['cached_at'] = DateTime.now().millisecondsSinceEpoch;
        await freshBox.put('current_user', userData);
        return;
      } catch (_) {
        // Silently fail - caching is not critical for login success
        // The token is stored in secure storage which is the important part
      }
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final box = await _ensureUserBoxOpen();
      final userData = box.get('current_user');
      if (userData == null) return null;

      // Check cache expiration (30 days)
      if (userData is Map) {
        final cachedAt = userData['cached_at'];
        if (cachedAt != null && cachedAt is int) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final cacheAgeMs = now - cachedAt;
          // Cache expires after 30 days (2592000000 ms)
          if (cacheAgeMs > 2592000000) {
            // Cache expired, return null to force fresh data fetch
            await box.delete('current_user');
            return null;
          }
        }
      }

      // Get token from secure storage
      final token = await secureStorage.getAccessToken();

      if (userData is UserModel) {
        return UserModel.fromEntity(userData.toEntity(), token: token);
      }

      return UserModel.fromJson(
        Map<String, dynamic>.from(userData as Map),
        token: token,
      );
    } catch (e) {
      try {
        if (Hive.isBoxOpen(StorageConstants.userBox)) {
          await _userBox.clear();
        }
      } catch (_) {}
      return null;
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      final box = await _ensureUserBoxOpen();
      await box.delete('current_user');
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cached user',
        originalException: e,
      );
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      await secureStorage.saveAccessToken(token);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save token',
        originalException: e,
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await secureStorage.getAccessToken();
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to get token',
        originalException: e,
      );
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await secureStorage.deleteAccessToken();
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to clear token',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final token = await secureStorage.getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String role,
    required String token,
  }) async {
    try {
      await Future.wait([
        secureStorage.saveAccessToken(token),
        secureStorage.saveUserId(userId),
        secureStorage.saveUserEmail(email),
        secureStorage.saveUserRole(role),
        secureStorage.setLoggedIn(true),
      ]);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save user session',
        originalException: e,
      );
    }
  }

  @override
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([clearCachedUser(), secureStorage.clearAll()]);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear auth data',
        originalException: e,
      );
    }
  }
}
