import '../../domain/entities/analytics_entity.dart';

/// Analytics model for data layer
class AnalyticsModel {
  final int totalUsers;
  final int newUsersThisMonth;
  final double userGrowthPercentage;
  final int totalCompletedHikes;
  final int scheduledHikesThisMonth;
  final double totalRevenue;
  final double revenueThisMonth;
  final double revenueGrowthPercentage;
  final List<MonthlyDataModel> userGrowth;
  final List<MonthlyHikeDataModel> hikeData;

  AnalyticsModel({
    required this.totalUsers,
    required this.newUsersThisMonth,
    required this.userGrowthPercentage,
    required this.totalCompletedHikes,
    required this.scheduledHikesThisMonth,
    required this.totalRevenue,
    required this.revenueThisMonth,
    required this.revenueGrowthPercentage,
    required this.userGrowth,
    required this.hikeData,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalUsers: json['totalUsers'] ?? 0,
      newUsersThisMonth: json['newUsersThisMonth'] ?? 0,
      userGrowthPercentage: (json['userGrowthPercentage'] ?? 0).toDouble(),
      totalCompletedHikes: json['totalCompletedHikes'] ?? 0,
      scheduledHikesThisMonth: json['scheduledHikesThisMonth'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      revenueThisMonth: (json['revenueThisMonth'] ?? 0).toDouble(),
      revenueGrowthPercentage: (json['revenueGrowthPercentage'] ?? 0).toDouble(),
      userGrowth: (json['userGrowth'] as List?)
              ?.map((item) => MonthlyDataModel.fromJson(item))
              .toList() ??
          [],
      hikeData: (json['hikeData'] as List?)
              ?.map((item) => MonthlyHikeDataModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  AnalyticsEntity toEntity() {
    return AnalyticsEntity(
      totalUsers: totalUsers,
      newUsersThisMonth: newUsersThisMonth,
      userGrowthPercentage: userGrowthPercentage,
      totalCompletedHikes: totalCompletedHikes,
      scheduledHikesThisMonth: scheduledHikesThisMonth,
      totalRevenue: totalRevenue,
      revenueThisMonth: revenueThisMonth,
      revenueGrowthPercentage: revenueGrowthPercentage,
      userGrowth: userGrowth.map((m) => m.toEntity()).toList(),
      hikeData: hikeData.map((m) => m.toEntity()).toList(),
    );
  }
}

class MonthlyDataModel {
  final int month;
  final int count;

  MonthlyDataModel({
    required this.month,
    required this.count,
  });

  factory MonthlyDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlyDataModel(
      month: json['_id'] ?? json['month'] ?? 0,
      count: json['users'] ?? json['count'] ?? 0,
    );
  }

  MonthlyData toEntity() {
    return MonthlyData(month: month, count: count);
  }
}

class MonthlyHikeDataModel {
  final int month;
  final int completed;
  final int cancelled;

  MonthlyHikeDataModel({
    required this.month,
    required this.completed,
    required this.cancelled,
  });

  factory MonthlyHikeDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlyHikeDataModel(
      month: json['_id'] ?? json['month'] ?? 0,
      completed: json['completed'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }

  MonthlyHikeData toEntity() {
    return MonthlyHikeData(
      month: month,
      completed: completed,
      cancelled: cancelled,
    );
  }
}
