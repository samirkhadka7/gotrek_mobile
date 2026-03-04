import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_constants.dart';
import '../errors/exceptions.dart';

/// Service for secure storage operations (tokens, credentials)
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  // ===========================================================================
  // TOKEN MANAGEMENT
  // ===========================================================================

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    try {
      await _storage.write(key: StorageConstants.accessToken, value: token);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save access token',
        originalException: e,
      );
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: StorageConstants.accessToken);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read access token',
        originalException: e,
      );
    }
  }

  /// Delete access token
  Future<void> deleteAccessToken() async {
    try {
      await _storage.delete(key: StorageConstants.accessToken);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to delete access token',
        originalException: e,
      );
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: StorageConstants.refreshToken, value: token);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save refresh token',
        originalException: e,
      );
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: StorageConstants.refreshToken);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read refresh token',
        originalException: e,
      );
    }
  }

  /// Delete refresh token
  Future<void> deleteRefreshToken() async {
    try {
      await _storage.delete(key: StorageConstants.refreshToken);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to delete refresh token',
        originalException: e,
      );
    }
  }

  // ===========================================================================
  // USER INFO
  // ===========================================================================

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    try {
      await _storage.write(key: StorageConstants.userId, value: userId);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save user ID',
        originalException: e,
      );
    }
  }

  /// Get user ID
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: StorageConstants.userId);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read user ID',
        originalException: e,
      );
    }
  }

  /// Save user role
  Future<void> saveUserRole(String role) async {
    try {
      await _storage.write(key: StorageConstants.userRole, value: role);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save user role',
        originalException: e,
      );
    }
  }

  /// Get user role
  Future<String?> getUserRole() async {
    try {
      return await _storage.read(key: StorageConstants.userRole);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read user role',
        originalException: e,
      );
    }
  }

  /// Save user email
  Future<void> saveUserEmail(String email) async {
    try {
      await _storage.write(key: StorageConstants.userEmail, value: email);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save user email',
        originalException: e,
      );
    }
  }

  /// Get user email
  Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: StorageConstants.userEmail);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read user email',
        originalException: e,
      );
    }
  }

  // ===========================================================================
  // LOGIN STATE
  // ===========================================================================

  /// Set logged in state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await _storage.write(
        key: StorageConstants.isLoggedIn,
        value: isLoggedIn.toString(),
      );
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to save login state',
        originalException: e,
      );
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final value = await _storage.read(key: StorageConstants.isLoggedIn);
      return value == 'true';
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read login state',
        originalException: e,
      );
    }
  }

  // ===========================================================================
  // GENERIC METHODS
  // ===========================================================================

  /// Write a value
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to write to secure storage',
        originalException: e,
      );
    }
  }

  /// Read a value
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to read from secure storage',
        originalException: e,
      );
    }
  }

  /// Delete a value
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to delete from secure storage',
        originalException: e,
      );
    }
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to clear secure storage',
        originalException: e,
      );
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      throw SecureStorageException(
        message: 'Failed to check key existence',
        originalException: e,
      );
    }
  }
}
