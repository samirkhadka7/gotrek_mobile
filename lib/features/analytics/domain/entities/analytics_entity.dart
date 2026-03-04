/// Analytics data entity
class AnalyticsEntity {
  final int totalUsers;
  final int newUsersThisMonth;
  final double userGrowthPercentage;
  final int totalCompletedHikes;
  final int scheduledHikesThisMonth;
  final double totalRevenue;
  final double revenueThisMonth;
  final double revenueGrowthPercentage;
  final List<MonthlyData> userGrowth;
  final List<MonthlyHikeData> hikeData;

  const AnalyticsEntity({
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
}

/// Monthly data for charts
class MonthlyData {
  final int month;
  final int count;

  const MonthlyData({
    required this.month,
    required this.count,
  });

  String get monthName {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}

/// Monthly hike data
class MonthlyHikeData {
  final int month;
  final int completed;
  final int cancelled;

  const MonthlyHikeData({
    required this.month,
    required this.completed,
    required this.cancelled,
  });

  String get monthName {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
