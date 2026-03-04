import 'package:equatable/equatable.dart';

/// Daily step count record
class StepRecord extends Equatable {
  final String id;
  final int steps;
  final double distance; // in kilometers
  final int calories;
  final DateTime date;
  final int activeMinutes;
  final int goal;

  const StepRecord({
    required this.id,
    required this.steps,
    required this.distance,
    required this.calories,
    required this.date,
    this.activeMinutes = 0,
    this.goal = 10000,
  });

  /// Calculate progress towards goal (0.0 - 1.0)
  double get progress => steps / goal;

  /// Check if goal is reached
  bool get isGoalReached => steps >= goal;

  /// Get remaining steps to reach goal
  int get remainingSteps => goal - steps > 0 ? goal - steps : 0;

  @override
  List<Object?> get props =>
      [id, steps, distance, calories, date, activeMinutes, goal];
}

/// Weekly/Monthly step statistics
class StepsStats extends Equatable {
  final int totalSteps;
  final double totalDistance;
  final int totalCalories;
  final int averageSteps;
  final int bestDay;
  final int activeDays;
  final int streakDays;
  final List<DailySteps> dailyData;

  const StepsStats({
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCalories,
    required this.averageSteps,
    required this.bestDay,
    required this.activeDays,
    this.streakDays = 0,
    this.dailyData = const [],
  });

  @override
  List<Object?> get props => [
        totalSteps,
        totalDistance,
        totalCalories,
        averageSteps,
        bestDay,
        activeDays,
        streakDays,
        dailyData,
      ];
}

/// Simple daily steps data for charts
class DailySteps extends Equatable {
  final DateTime date;
  final int steps;
  final int goal;

  const DailySteps({
    required this.date,
    required this.steps,
    this.goal = 10000,
  });

  String get dayName {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  double get progress => steps / goal;

  @override
  List<Object?> get props => [date, steps, goal];
}

/// Step goal settings
class StepGoal extends Equatable {
  final int dailyGoal;
  final int weeklyGoal;
  final bool notificationsEnabled;
  final int reminderHour;

  const StepGoal({
    this.dailyGoal = 10000,
    this.weeklyGoal = 70000,
    this.notificationsEnabled = true,
    this.reminderHour = 20, // 8 PM reminder
  });

  @override
  List<Object?> get props =>
      [dailyGoal, weeklyGoal, notificationsEnabled, reminderHour];
}

/// Step tracking session (for trek/hike tracking)
class StepSession extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int steps;
  final double distance;
  final int calories;
  final String? trailId;
  final String? trailName;
  final List<LocationPoint> route;
  final SessionStatus status;

  const StepSession({
    required this.id,
    required this.startTime,
    this.endTime,
    this.steps = 0,
    this.distance = 0,
    this.calories = 0,
    this.trailId,
    this.trailName,
    this.route = const [],
    this.status = SessionStatus.active,
  });

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  String get formattedDuration {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        steps,
        distance,
        calories,
        trailId,
        trailName,
        route,
        status,
      ];
}

/// Location point for route tracking
class LocationPoint extends Equatable {
  final double latitude;
  final double longitude;
  final double? altitude;
  final DateTime timestamp;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
    this.altitude,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, altitude, timestamp];
}

/// Session status
enum SessionStatus {
  active,
  paused,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case SessionStatus.active:
        return 'Active';
      case SessionStatus.paused:
        return 'Paused';
      case SessionStatus.completed:
        return 'Completed';
      case SessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// Achievement for gamification
class StepAchievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int requiredSteps;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const StepAchievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredSteps,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  @override
  List<Object?> get props =>
      [id, title, description, icon, requiredSteps, isUnlocked, unlockedAt];
}
