import 'package:hive/hive.dart';

import '../../domain/entities/steps_entity.dart';

part 'steps_model.g.dart';

/// Model for step record from API
@HiveType(typeId: 23)
class StepRecordModel extends StepRecord {
  @HiveField(0)
  final String modelId;

  @HiveField(1)
  final int modelSteps;

  @HiveField(2)
  final double modelDistance;

  @HiveField(3)
  final int modelCalories;

  @HiveField(4)
  final DateTime modelDate;

  @HiveField(5)
  final int modelActiveMinutes;

  @HiveField(6)
  final int modelGoal;

  const StepRecordModel({
    required this.modelId,
    required this.modelSteps,
    required this.modelDistance,
    required this.modelCalories,
    required this.modelDate,
    this.modelActiveMinutes = 0,
    this.modelGoal = 10000,
  }) : super(
          id: modelId,
          steps: modelSteps,
          distance: modelDistance,
          calories: modelCalories,
          date: modelDate,
          activeMinutes: modelActiveMinutes,
          goal: modelGoal,
        );

  factory StepRecordModel.fromJson(Map<String, dynamic> json) {
    return StepRecordModel(
      modelId: json['_id'] as String? ?? json['id'] as String? ?? '',
      modelSteps: json['steps'] as int? ?? 0,
      modelDistance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      modelCalories: json['calories'] as int? ?? 0,
      modelDate: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      modelActiveMinutes: json['activeMinutes'] as int? ?? 0,
      modelGoal: json['goal'] as int? ?? 10000,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'steps': modelSteps,
      'distance': modelDistance,
      'calories': modelCalories,
      'date': modelDate.toIso8601String(),
      'activeMinutes': modelActiveMinutes,
      'goal': modelGoal,
    };
  }
}

/// Model for step statistics
class StepsStatsModel extends StepsStats {
  const StepsStatsModel({
    required super.totalSteps,
    required super.totalDistance,
    required super.totalCalories,
    required super.averageSteps,
    required super.bestDay,
    required super.activeDays,
    super.streakDays,
    super.dailyData,
  });

  factory StepsStatsModel.fromJson(Map<String, dynamic> json) {
    final dailyDataJson = json['dailyData'] as List<dynamic>? ?? [];

    return StepsStatsModel(
      totalSteps: json['totalSteps'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      totalCalories: json['totalCalories'] as int? ?? 0,
      averageSteps: json['averageSteps'] as int? ?? 0,
      bestDay: json['bestDay'] as int? ?? 0,
      activeDays: json['activeDays'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      dailyData: dailyDataJson
          .map((e) => DailyStepsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Model for daily steps data
class DailyStepsModel extends DailySteps {
  const DailyStepsModel({
    required super.date,
    required super.steps,
    super.goal,
  });

  factory DailyStepsModel.fromJson(Map<String, dynamic> json) {
    return DailyStepsModel(
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      steps: json['steps'] as int? ?? 0,
      goal: json['goal'] as int? ?? 10000,
    );
  }
}

/// Model for step goal
@HiveType(typeId: 24)
class StepGoalModel extends StepGoal {
  @HiveField(0)
  final int modelDailyGoal;

  @HiveField(1)
  final int modelWeeklyGoal;

  @HiveField(2)
  final bool modelNotificationsEnabled;

  @HiveField(3)
  final int modelReminderHour;

  const StepGoalModel({
    this.modelDailyGoal = 10000,
    this.modelWeeklyGoal = 70000,
    this.modelNotificationsEnabled = true,
    this.modelReminderHour = 20,
  }) : super(
          dailyGoal: modelDailyGoal,
          weeklyGoal: modelWeeklyGoal,
          notificationsEnabled: modelNotificationsEnabled,
          reminderHour: modelReminderHour,
        );

  factory StepGoalModel.fromJson(Map<String, dynamic> json) {
    return StepGoalModel(
      modelDailyGoal: json['dailyGoal'] as int? ?? 10000,
      modelWeeklyGoal: json['weeklyGoal'] as int? ?? 70000,
      modelNotificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      modelReminderHour: json['reminderHour'] as int? ?? 20,
    );
  }

  factory StepGoalModel.fromEntity(StepGoal goal) {
    return StepGoalModel(
      modelDailyGoal: goal.dailyGoal,
      modelWeeklyGoal: goal.weeklyGoal,
      modelNotificationsEnabled: goal.notificationsEnabled,
      modelReminderHour: goal.reminderHour,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyGoal': modelDailyGoal,
      'weeklyGoal': modelWeeklyGoal,
      'notificationsEnabled': modelNotificationsEnabled,
      'reminderHour': modelReminderHour,
    };
  }
}

/// Model for step session
@HiveType(typeId: 25)
class StepSessionModel extends StepSession {
  @HiveField(0)
  final String modelId;

  @HiveField(1)
  final DateTime modelStartTime;

  @HiveField(2)
  final DateTime? modelEndTime;

  @HiveField(3)
  final int modelSteps;

  @HiveField(4)
  final double modelDistance;

  @HiveField(5)
  final int modelCalories;

  @HiveField(6)
  final String? modelTrailId;

  @HiveField(7)
  final String? modelTrailName;

  @HiveField(8)
  final SessionStatus modelStatus;

  const StepSessionModel({
    required this.modelId,
    required this.modelStartTime,
    this.modelEndTime,
    this.modelSteps = 0,
    this.modelDistance = 0,
    this.modelCalories = 0,
    this.modelTrailId,
    this.modelTrailName,
    this.modelStatus = SessionStatus.active,
  }) : super(
          id: modelId,
          startTime: modelStartTime,
          endTime: modelEndTime,
          steps: modelSteps,
          distance: modelDistance,
          calories: modelCalories,
          trailId: modelTrailId,
          trailName: modelTrailName,
          status: modelStatus,
        );

  factory StepSessionModel.fromJson(Map<String, dynamic> json) {
    return StepSessionModel(
      modelId: json['_id'] as String? ?? json['id'] as String? ?? '',
      modelStartTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : DateTime.now(),
      modelEndTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      modelSteps: json['steps'] as int? ?? 0,
      modelDistance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      modelCalories: json['calories'] as int? ?? 0,
      modelTrailId: json['trailId'] as String?,
      modelTrailName: json['trailName'] as String?,
      modelStatus: _parseStatus(json['status'] as String?),
    );
  }

  static SessionStatus _parseStatus(String? status) {
    switch (status) {
      case 'active':
        return SessionStatus.active;
      case 'paused':
        return SessionStatus.paused;
      case 'completed':
        return SessionStatus.completed;
      case 'cancelled':
        return SessionStatus.cancelled;
      default:
        return SessionStatus.active;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': modelId,
      'startTime': modelStartTime.toIso8601String(),
      'endTime': modelEndTime?.toIso8601String(),
      'steps': modelSteps,
      'distance': modelDistance,
      'calories': modelCalories,
      'trailId': modelTrailId,
      'trailName': modelTrailName,
      'status': modelStatus.name,
    };
  }
}

/// Model for achievement
class StepAchievementModel extends StepAchievement {
  const StepAchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required super.requiredSteps,
    super.isUnlocked,
    super.unlockedAt,
  });

  factory StepAchievementModel.fromJson(Map<String, dynamic> json) {
    return StepAchievementModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String? ?? '🏆',
      requiredSteps: json['requiredSteps'] as int? ?? 0,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }
}
