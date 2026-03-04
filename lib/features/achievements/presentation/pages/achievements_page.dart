import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Achievements page displaying user badges and milestones
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats summary
            _buildStatsSummary(context),
            const SizedBox(height: 24),

            // Achievements section
            const Text(
              'Your Badges',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAchievementGrid(),
            const SizedBox(height: 24),

            // Progress section
            const Text(
              'Next Milestones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMilestonesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('3', 'Badges\nEarned', Icons.military_tech),
          _buildStatItem('12', 'Trails\nCompleted', Icons.terrain),
          _buildStatItem('5', 'Groups\nJoined', Icons.group),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementGrid() {
    final achievements = [
      _Achievement(
        icon: Icons.hiking,
        title: 'First Steps',
        description: 'Complete your first trail',
        isUnlocked: true,
        color: Colors.green,
      ),
      _Achievement(
        icon: Icons.group_add,
        title: 'Social Trekker',
        description: 'Join your first group',
        isUnlocked: true,
        color: Colors.blue,
      ),
      _Achievement(
        icon: Icons.terrain,
        title: 'Explorer',
        description: 'Complete 5 different trails',
        isUnlocked: true,
        color: Colors.orange,
      ),
      _Achievement(
        icon: Icons.local_fire_department,
        title: 'On Fire',
        description: '7-day trekking streak',
        isUnlocked: false,
        color: Colors.red,
      ),
      _Achievement(
        icon: Icons.star,
        title: 'Trail Master',
        description: 'Complete 10 trails',
        isUnlocked: false,
        color: Colors.amber,
      ),
      _Achievement(
        icon: Icons.groups,
        title: 'Leader',
        description: 'Lead 3 group treks',
        isUnlocked: false,
        color: Colors.purple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _AchievementCard(achievement: achievement);
      },
    );
  }

  Widget _buildMilestonesList() {
    final milestones = [
      _Milestone(
        title: 'Complete 10 trails',
        current: 12,
        target: 10,
        icon: Icons.check_circle,
        isComplete: true,
      ),
      _Milestone(
        title: 'Walk 100,000 steps',
        current: 75000,
        target: 100000,
        icon: Icons.directions_walk,
        isComplete: false,
      ),
      _Milestone(
        title: 'Join 10 groups',
        current: 5,
        target: 10,
        icon: Icons.group,
        isComplete: false,
      ),
    ];

    return Column(
      children: milestones.map((milestone) {
        return _MilestoneCard(milestone: milestone);
      }).toList(),
    );
  }
}

class _Achievement {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;

  _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
  });
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: achievement.isUnlocked
            ? achievement.color.withValues(alpha: 0.1)
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: achievement.isUnlocked ? achievement.color : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement.icon,
            size: 32,
            color: achievement.isUnlocked ? achievement.color : Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: achievement.isUnlocked ? Colors.black87 : Colors.grey,
            ),
          ),
          if (!achievement.isUnlocked)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Icon(
                Icons.lock,
                size: 14,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }
}

class _Milestone {
  final String title;
  final int current;
  final int target;
  final IconData icon;
  final bool isComplete;

  _Milestone({
    required this.title,
    required this.current,
    required this.target,
    required this.icon,
    required this.isComplete,
  });
}

class _MilestoneCard extends StatelessWidget {
  final _Milestone milestone;

  const _MilestoneCard({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final progress = (milestone.current / milestone.target).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: milestone.isComplete
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  milestone.icon,
                  color: milestone.isComplete ? AppColors.success : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${milestone.current} / ${milestone.target}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (milestone.isComplete)
                const Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                milestone.isComplete ? AppColors.success : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
