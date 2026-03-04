/// App route paths
abstract class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Main Routes
  static const String home = '/home';
  static const String explore = '/explore';
  static const String groups = '/groups';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String admin = '/admin';

  // Trail Routes
  static const String trailDetails = '/trail/:id';
  static const String trailSearch = '/trails/search';

  // Group Routes
  static const String groupDetails = '/group/:id';
  static const String createGroup = '/groups/create';
  static const String joinGroup = '/groups/join';

  // Chat Routes
  static const String chatRoom = '/chat/:groupId';

  // Profile Routes
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String achievements = '/profile/achievements';
  static const String completedTrails = '/profile/completed-trails';

  // Payment Routes
  static const String subscription = '/subscription';
  static const String payment = '/payment';

  // Checklist Routes
  static const String checklist = '/checklist';
  static const String checklistDetails = '/checklist/:id';

  // Chatbot Routes
  static const String chatbot = '/chatbot';

  // Notification Routes
  static const String notifications = '/notifications';

  // My Trails & Groups Routes
  static const String myTrails = '/my-trails';
  static const String myGroups = '/my-groups';

  // Payment History Route
  static const String paymentHistory = '/payment-history';

  // Steps Route
  static const String steps = '/steps';

  // Settings Routes
  static const String settings = '/settings';

  /// Helper method to create trail details route
  static String trailDetailsPath(String id) => '/trail/$id';

  /// Helper method to create group details route
  static String groupDetailsPath(String id) => '/group/$id';

  /// Helper method to create chat room route
  static String chatRoomPath(String groupId) => '/chat/$groupId';

  /// Helper method to create checklist details route
  static String checklistDetailsPath(String id) => '/checklist/$id';
}
