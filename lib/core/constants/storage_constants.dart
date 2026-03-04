/// Storage Constants for Hive boxes and Secure Storage keys
class StorageConstants {
  StorageConstants._();

  // ==========================================================================
  // HIVE BOX NAMES
  // ==========================================================================

  static const String userBox = 'user_box';
  static const String trailBox = 'trail_box';
  static const String groupBox = 'group_box';
  static const String messageBox = 'message_box';
  static const String checklistBox = 'checklist_box';
  static const String paymentBox = 'payment_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';
  static const String syncBox = 'sync_box';

  // ==========================================================================
  // HIVE TYPE IDS (must be unique across the app)
  // ==========================================================================

  static const int userModelTypeId = 0;
  static const int trailModelTypeId = 1;
  static const int groupModelTypeId = 2;
  static const int messageModelTypeId = 3;
  static const int checklistModelTypeId = 4;
  static const int paymentModelTypeId = 5;
  static const int userStatsModelTypeId = 6;
  static const int emergencyContactModelTypeId = 7;
  static const int completedTrailModelTypeId = 8;
  static const int joinedTrailModelTypeId = 9;
  static const int durationModelTypeId = 10;
  static const int ratingModelTypeId = 11;
  static const int groupParticipantTypeId = 12;
  static const int meetingPointTypeId = 13;
  static const int groupCommentTypeId = 14;
  static const int checklistItemTypeId = 15;
  static const int checklistConfigTypeId = 16;
  static const int syncStatusTypeId = 17;

  // ==========================================================================
  // SECURE STORAGE KEYS
  // ==========================================================================

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userRole = 'user_role';
  static const String isLoggedIn = 'is_logged_in';
  static const String tokenExpiry = 'token_expiry';

  // ==========================================================================
  // SETTINGS KEYS (in Hive settings box)
  // ==========================================================================

  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String lastSyncTime = 'last_sync_time';

  // ==========================================================================
  // CACHE KEYS
  // ==========================================================================

  static const String cachedTrails = 'cached_trails';
  static const String cachedGroups = 'cached_groups';
  static const String cachedUser = 'cached_user';
  static const String cacheTimestamp = 'cache_timestamp';

  /// Cache duration in hours
  static const int cacheDurationHours = 24;
}
