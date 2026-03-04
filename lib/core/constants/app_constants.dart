/// App-wide constants
class AppConstants {
  AppConstants._();

  // ==========================================================================
  // APP INFO
  // ==========================================================================

  static const String appName = 'GoTrek';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your Gateway to Nepal\'s Trails';

  // ==========================================================================
  // USER TYPES
  // ==========================================================================

  static const List<String> hikerTypes = ['new', 'experienced'];

  static const List<String> ageGroups = [
    '18-24',
    '24-35',
    '35-44',
    '45-54',
    '55-64',
    '65+',
  ];

  static const List<String> userRoles = ['user', 'guide', 'admin'];

  static const List<String> subscriptionPlans = ['Basic', 'Pro', 'Premium'];

  // ==========================================================================
  // TRAIL CONSTANTS
  // ==========================================================================

  static const List<String> difficultyLevels = ['Easy', 'Moderate', 'Hard'];

  static const List<String> seasons = [
    'Spring',
    'Summer',
    'Autumn',
    'Winter',
  ];

  // ==========================================================================
  // GROUP CONSTANTS
  // ==========================================================================

  static const List<String> groupStatuses = [
    'upcoming',
    'active',
    'completed',
    'cancelled',
  ];

  static const List<String> participantStatuses = [
    'pending',
    'confirmed',
    'declined',
  ];

  static const int minGroupSize = 2;
  static const int maxGroupSize = 20;

  // ==========================================================================
  // CHECKLIST CONSTANTS
  // ==========================================================================

  static const List<String> experienceLevels = ['beginner', 'experienced'];

  static const List<String> hikeDurations = ['day', 'multi-day', 'week'];

  static const List<String> weatherConditions = ['sunny', 'rainy', 'cold', 'hot'];

  static const List<String> checklistCategories = [
    'essentials',
    'clothing',
    'equipment',
    'advanced',
    'special',
  ];

  // ==========================================================================
  // PAYMENT CONSTANTS
  // ==========================================================================

  static const List<String> paymentStatuses = ['pending', 'success', 'failure'];

  static const Map<String, int> subscriptionPrices = {
    'Pro': 499,
    'Premium': 999,
  };

  // ==========================================================================
  // ACTIVITY TYPES
  // ==========================================================================

  static const List<String> activityTypes = [
    'user_joined',
    'group_created',
    'hike_joined',
    'hike_completed',
    'hike_cancelled',
  ];

  // ==========================================================================
  // ACHIEVEMENT CONSTANTS
  // ==========================================================================

  static const List<String> achievementCategories = [
    'milestones',
    'elevation',
    'social',
    'special',
    'exploration',
  ];

  static const List<String> achievementDifficulties = ['easy', 'medium', 'hard'];

  // ==========================================================================
  // UI CONSTANTS
  // ==========================================================================

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 20.0;
  static const double defaultElevation = 2.0;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration splashDuration = Duration(seconds: 2);

  // ==========================================================================
  // VALIDATION CONSTANTS
  // ==========================================================================

  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
  static const int maxMessageLength = 1000;
  static const int maxPhoneLength = 15;

  // ==========================================================================
  // FILE UPLOAD CONSTANTS
  // ==========================================================================

  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxImages = 10;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
}
