import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/steps_entity.dart';

/// Card for displaying step statistics
class StepStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StepStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: cardColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 12),
            // Value
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Weekly bar chart for steps
class WeeklyStepsChart extends StatelessWidget {
  final List<DailySteps> dailyData;
  final double height;

  const WeeklyStepsChart({
    super.key,
    required this.dailyData,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    // Generate 7 days data (fill with empty if needed)
    final days = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      final data = dailyData.firstWhere(
        (d) =>
            d.date.year == date.year &&
            d.date.month == date.month &&
            d.date.day == date.day,
        orElse: () => DailySteps(date: date, steps: 0),
      );
      return data;
    });

    final maxSteps = days.fold<int>(10000, (max, d) => d.steps > max ? d.steps : max);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${days.fold<int>(0, (sum, d) => sum + d.steps)} total',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Chart
          SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((day) {
                final barHeight = maxSteps > 0
                    ? (day.steps / maxSteps * (height - 30)).clamp(4.0, height - 30)
                    : 4.0;
                final isToday = day.date.day == DateTime.now().day;
                final isGoalReached = day.steps >= day.goal;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Steps count (show for today or on tap)
                        if (isToday && day.steps > 0)
                          Text(
                            _formatSteps(day.steps),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isGoalReached
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                          ),
                        const SizedBox(height: 4),
                        // Bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOutCubic,
                          height: barHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: isGoalReached
                                  ? [
                                      AppColors.success,
                                      AppColors.success.withOpacity(0.7),
                                    ]
                                  : [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.7),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: isToday
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Day label
                        Text(
                          day.dayName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                            color: isToday
                                ? AppColors.primary
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Goal line indicator
          Row(
            children: [
              Container(
                width: 20,
                height: 2,
                color: Colors.grey.shade300,
              ),
              const SizedBox(width: 8),
              Text(
                'Daily goal: 10,000 steps',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return steps.toString();
  }
}

/// Activity summary row
class ActivitySummaryRow extends StatelessWidget {
  final int steps;
  final double distance;
  final int calories;
  final int activeMinutes;

  const ActivitySummaryRow({
    super.key,
    required this.steps,
    required this.distance,
    required this.calories,
    this.activeMinutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActivityItem(
            icon: Icons.directions_walk,
            value: _formatNumber(steps),
            label: 'Steps',
            color: AppColors.primary,
          ),
          _Divider(),
          _ActivityItem(
            icon: Icons.straighten,
            value: '${distance.toStringAsFixed(1)} km',
            label: 'Distance',
            color: Colors.orange,
          ),
          _Divider(),
          _ActivityItem(
            icon: Icons.local_fire_department,
            value: '$calories',
            label: 'Calories',
            color: Colors.red,
          ),
          if (activeMinutes > 0) ...[
            _Divider(),
            _ActivityItem(
              icon: Icons.timer,
              value: '${activeMinutes}m',
              label: 'Active',
              color: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ActivityItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}
