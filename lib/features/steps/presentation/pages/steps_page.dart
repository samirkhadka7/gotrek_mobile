import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/steps_bloc.dart';
import '../widgets/step_counter_circle.dart';
import '../widgets/step_stats_card.dart';

/// Main page for step tracking
class StepsPage extends StatefulWidget {
  const StepsPage({super.key});

  @override
  State<StepsPage> createState() => _StepsPageState();
}

class _StepsPageState extends State<StepsPage> {
  @override
  void initState() {
    super.initState();
    // Always reload on page open (handles hot reload + re-navigation)
    context.read<StepsBloc>().add(const LoadTodayStepsEvent());
    context.read<StepsBloc>().add(const LoadWeeklyStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Steps Tracker',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddStepsDialog(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _showGoalSettings(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: BlocConsumer<StepsBloc, StepsState>(
        listenWhen: (previous, current) =>
            (previous is TrekSessionActive && current is StepsLoaded) ||
            (previous is TrekSessionActive && current is StepsError),
        listener: (context, state) {
          if (state is StepsLoaded) {
            final steps = state.todayRecord.steps;
            final dist = state.todayRecord.distance;
            final msg = steps > 0
                ? 'Trek stopped! $steps steps • ${dist.toStringAsFixed(2)} km'
                : 'Trek stopped! Walk outside for GPS signal.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(msg),
                backgroundColor:
                    steps > 0 ? AppColors.success : Colors.orange,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StepsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is StepsError) {
            return _buildErrorView(state.message);
          }
          if (state is TrekSessionActive) {
            return _buildTrekActiveView(state);
          }
          if (state is StepsLoaded) {
            return _buildContent(state);
          }
          return _buildContent(null);
        },
      ),
    );
  }

  Widget _buildContent(StepsLoaded? state) {
    final record = state?.todayRecord;
    final steps = record?.steps ?? 0;
    final goal = record?.goal ?? 10000;
    final distance = record?.distance ?? 0.0;
    final calories = record?.calories ?? 0;
    final activeMinutes = record?.activeMinutes ?? 0;
    final weeklyStats = state?.weeklyStats;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<StepsBloc>().add(const LoadTodayStepsEvent());
        context.read<StepsBloc>().add(const LoadWeeklyStatsEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main circular counter
            Center(
              child: StepCounterCircle(
                steps: steps,
                goal: goal,
              ),
            ),
            const SizedBox(height: 24),

            // Activity summary
            ActivitySummaryRow(
              steps: steps,
              distance: distance,
              calories: calories,
              activeMinutes: activeMinutes,
            ),
            const SizedBox(height: 24),

            // Weekly chart
            WeeklyStepsChart(
              dailyData: weeklyStats?.dailyData ?? [],
            ),
            const SizedBox(height: 24),

            // Stats grid
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StepStatsCard(
                    title: 'Average',
                    value: _formatNumber(weeklyStats?.averageSteps ?? 0),
                    subtitle: 'steps/day',
                    icon: Icons.trending_up,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StepStatsCard(
                    title: 'Best Day',
                    value: _formatNumber(weeklyStats?.bestDay ?? 0),
                    subtitle: 'steps',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StepStatsCard(
                    title: 'Active Days',
                    value: '${weeklyStats?.activeDays ?? 0}',
                    subtitle: 'this week',
                    icon: Icons.calendar_today,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StepStatsCard(
                    title: 'Streak',
                    value: '${weeklyStats?.streakDays ?? 0}',
                    subtitle: 'days',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick actions
            _buildQuickActions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final isTrekActive = context.read<StepsBloc>().state is TrekSessionActive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: isTrekActive ? Icons.stop : Icons.play_arrow,
                title: isTrekActive ? 'Stop Trek' : 'Start Trek',
                subtitle: isTrekActive ? 'Tracking GPS...' : 'Track your trek',
                color: isTrekActive ? Colors.red : AppColors.primary,
                onTap: () => isTrekActive
                    ? context.read<StepsBloc>().add(const StopTrekSessionEvent())
                    : _startTrekSession(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.sync,
                title: 'Sync Device',
                subtitle: 'From pedometer',
                color: Colors.teal,
                onTap: () => _syncFromDevice(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.history,
                title: 'History',
                subtitle: 'View past activity',
                color: Colors.purple,
                onTap: () => _viewHistory(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.emoji_events,
                title: 'Achievements',
                subtitle: 'Your badges',
                color: Colors.amber,
                onTap: () => _viewAchievements(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<StepsBloc>().add(const LoadTodayStepsEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStepsDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Steps'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Number of steps',
            hintText: 'e.g., 1000',
            prefixIcon: Icon(Icons.directions_walk),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final steps = int.tryParse(controller.text);
              if (steps != null && steps > 0) {
                context.read<StepsBloc>().add(LogStepsEvent(steps: steps));
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showGoalSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Step Goal Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.flag, color: AppColors.primary),
              title: const Text('Daily Goal'),
              subtitle: const Text('10,000 steps'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Implement goal change
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.orange),
              title: const Text('Reminders'),
              subtitle: const Text('Daily at 8 PM'),
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTrekActiveView(TrekSessionActive state) {
    final distanceKm = state.liveDistanceMeters / 1000;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GPS dot
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Trek Active',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),
            // Live steps (big number)
            Text(
              '${state.liveSteps}',
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            const Text(
              'steps',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            // Distance row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.straighten, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${distanceKm.toStringAsFixed(2)} km',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Elevation row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_upward, size: 18, color: Colors.green),
                Text(
                  '${state.liveElevationGain.toStringAsFixed(0)}m',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 24),
                const Icon(Icons.arrow_downward, size: 18, color: Colors.red),
                Text(
                  '${state.liveElevationLoss.toStringAsFixed(0)}m',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.read<StepsBloc>().add(const StopTrekSessionEvent()),
                icon: const Icon(Icons.stop, size: 28),
                label: const Text('Stop Trek'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startTrekSession() async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;
      // Show dialog to turn on location
      final turnOn = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          icon: const Icon(
            Icons.location_off,
            size: 48,
            color: Colors.orange,
          ),
          title: const Text('Location is Off'),
          content: const Text(
            'GPS location is required to track your trek distance. Please turn on location from settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No Thanks'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Turn On'),
            ),
          ],
        ),
      );

      if (turnOn == true) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    if (!mounted) return;
    // Location is ON — show Start Trek confirmation
    final startNow = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: const Icon(
          Icons.directions_walk,
          size: 48,
          color: AppColors.primary,
        ),
        title: const Text('Start Trek'),
        content: const Text(
          'GPS tracking will record your distance and steps. Make sure you are outdoors for best accuracy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx, true),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Trek'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (startNow != true || !mounted) return;
    context.read<StepsBloc>().add(const StartTrekSessionEvent());
  }

  void _syncFromDevice() {
    // Simulate syncing from device pedometer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing with device pedometer...'),
      ),
    );
    // In real app, this would read from health/pedometer API
    context.read<StepsBloc>().add(const SyncFromDeviceEvent(deviceSteps: 500));
  }

  void _viewHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History feature coming soon!'),
      ),
    );
  }

  void _viewAchievements() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Achievements feature coming soon!'),
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

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
