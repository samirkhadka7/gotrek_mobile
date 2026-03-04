import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// API Constants for GoTrek application
/// Manages base URLs and all API endpoints
class ApiConstants {
  ApiConstants._();

  // ==========================================================================
  // BASE URL CONFIGURATION
  // ==========================================================================

  static const String _androidEmulatorBase = 'http://10.0.2.2:5050/api';
  static const String _physicalDeviceBase = 'http://192.168.18.86:5050/api';
  static const String _localhostBase = 'http://localhost:5050/api';

  /// Get the appropriate base URL based on platform
  /// For physical devices, use --dart-define=API_BASE_URL=http://your_ip:5050/api
  /// or set USE_PHYSICAL_DEVICE=true to use the physical device base URL
  static String get baseUrl {
    const definedUrl = String.fromEnvironment('API_BASE_URL');
    if (definedUrl.isNotEmpty) {
      return definedUrl;
    }

    const usePhysicalDevice =
        bool.fromEnvironment('USE_PHYSICAL_DEVICE', defaultValue: false);

    if (kIsWeb) return _localhostBase;
    if (Platform.isAndroid) return _physicalDeviceBase;
    return _localhostBase; // iOS simulator
  }

  /// Base URL without /api suffix (for file uploads, static files, etc.)
  static String get serverUrl => baseUrl.replaceAll('/api', '');

  /// Socket.IO URL
  static String get socketUrl => serverUrl;

  // ==========================================================================
  // AUTH ENDPOINTS
  // ==========================================================================

  static String get register => '$baseUrl/auth/register';
  static String get signup => register; // Alias for register
  static String get login => '$baseUrl/auth/login';
  static String get changePassword => '$baseUrl/auth/change-password';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get resetPassword => '$baseUrl/auth/reset-password';
  static String get googleAuth => '$baseUrl/auth/google';
  static String get googleCallback => '$baseUrl/auth/google/callback';

  // ==========================================================================
  // USER ENDPOINTS
  // ==========================================================================

  static String get userMe => '$baseUrl/user/me';
  static String get getMe => userMe; // Alias for userMe
  static String get userMePicture => '$baseUrl/user/me/picture';
  static String get uploadProfileImage => userMePicture; // Alias for userMePicture
  static String get userDeactivate => '$baseUrl/user/me';
  static String get users => '$baseUrl/user';
  static String userById(String id) => '$baseUrl/user/$id';
  static String updateUserRole(String id) => '$baseUrl/user/role/$id';

  // ==========================================================================
  // TRAIL ENDPOINTS
  // ==========================================================================

  static String get trails => '$baseUrl/trail';
  static String get createTrail => '$baseUrl/trail/create';
  static String trailById(String id) => '$baseUrl/trail/$id';
  static String joinTrailWithDate(String id) => '$baseUrl/trail/$id/join-with-date';
  static String completeTrail(String joinedTrailId) =>
      '$baseUrl/trail/joined/$joinedTrailId/complete';
  static String cancelJoinedTrail(String joinedTrailId) =>
      '$baseUrl/trail/joined/$joinedTrailId/cancel';

  // ==========================================================================
  // GROUP ENDPOINTS
  // ==========================================================================

  static String get groups => '$baseUrl/group';
  static String get createGroup => '$baseUrl/group/create';
  static String get pendingRequests => '$baseUrl/group/requests/pending';
  static String groupById(String id) => '$baseUrl/group/$id';
  static String requestJoinGroup(String id) => '$baseUrl/group/$id/request-join';
  static String approveJoinRequest(String groupId, String requestId) =>
      '$baseUrl/group/$groupId/requests/$requestId/approve';
  static String denyJoinRequest(String groupId, String requestId) =>
      '$baseUrl/group/$groupId/requests/$requestId/deny';

  // ==========================================================================
  // MESSAGE ENDPOINTS
  // ==========================================================================

  static String messagesByGroup(String groupId) => '$baseUrl/messages/$groupId';

  // ==========================================================================
  // PAYMENT ENDPOINTS
  // ==========================================================================

  static String get initiatePayment => '$baseUrl/payment/initiate';
  static String get verifyPayment => '$baseUrl/payment/verify';
  static String get paymentHistory => '$baseUrl/payment/history';
  static String get allPaymentHistory => '$baseUrl/payment/all-history';

  // ==========================================================================
  // SUBSCRIPTION ENDPOINTS
  // ==========================================================================

  static String get cancelSubscription => '$baseUrl/subscription/cancel';

  // ==========================================================================
  // CHECKLIST ENDPOINTS
  // ==========================================================================

  static String get generateChecklist => '$baseUrl/checklist/generate';
  static String get saveChecklist => '$baseUrl/checklist/save';
  static String get myChecklist => '$baseUrl/checklist/my';
  static String updateChecklistItem(String itemId) => '$baseUrl/checklist/item/$itemId';

  // ==========================================================================
  // CHATBOT ENDPOINTS
  // ==========================================================================

  static String get chatbotQuery => '$baseUrl/v1/chatbot/query';

  // ==========================================================================
  // ANALYTICS ENDPOINTS (Admin)
  // ==========================================================================

  static String get analytics => '$baseUrl/analytics';

  // ==========================================================================
  // ACTIVITY ENDPOINTS (Admin)
  // ==========================================================================

  static String get activities => '$baseUrl/activity';
  static String get recentActivities => '$baseUrl/activity/recent';

  // ==========================================================================
  // STEP ENDPOINTS
  // ==========================================================================

  static String get saveSteps => '$baseUrl/step';
  static String totalSteps(String userId) => '$baseUrl/step/total/$userId';
  static String get todaySteps => '$baseUrl/step/today';
  static String get logSteps => '$baseUrl/step/log';
  static String get stepHistory => '$baseUrl/step/history';
  static String get syncSteps => '$baseUrl/step/sync';
  static String get weeklyStepStats => '$baseUrl/step/stats/weekly';
  static String get monthlyStepStats => '$baseUrl/step/stats/monthly';
  static String get startStepSession => '$baseUrl/step/session/start';
  static String get activeStepSession => '$baseUrl/step/session/active';
  static String get stepSessionHistory => '$baseUrl/step/session/history';
  static String updateStepSession(String id) => '$baseUrl/step/session/$id';
  static String endStepSession(String id) => '$baseUrl/step/session/$id/end';

  // ==========================================================================
  // TIMEOUT CONFIGURATIONS
  // ==========================================================================

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ==========================================================================
  // PAGINATION DEFAULTS
  // ==========================================================================

  static const int defaultPageSize = 10;
  static const int defaultPage = 1;
}
