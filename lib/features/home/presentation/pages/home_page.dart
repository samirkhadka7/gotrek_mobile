import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection/injection.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _totalSteps = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    // Refresh user data and load steps
    _loadDashboardData();
  }

  void _loadDashboardData() {
    // Refresh user profile to get latest stats, joinedTrails, groups
    context.read<AuthBloc>().add(GetCurrentUserEvent());

    // Fetch total steps
    _fetchTotalSteps();
  }

  Future<void> _fetchTotalSteps() async {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        final apiClient = sl<ApiClient>();
        final response = await apiClient.get(
          ApiConstants.totalSteps(authState.user.id),
        );
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && mounted) {
          final steps = data['totalSteps'];
          setState(() {
            _totalSteps = (steps is int) ? steps : (steps as num?)?.toInt() ?? 0;
          });
        }
      }
    } catch (_) {
      // Steps endpoint might not be available, silently ignore
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Fetch steps once auth data is ready
          if (state is AuthAuthenticated && _totalSteps == 0) {
            _fetchTotalSteps();
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          final userName = user?.name ?? 'Trekker';
          final userStats = user?.stats;

          return CustomScrollView(
            slivers: [
              // Modern App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                actions: [
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.secondary,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.push('/profile'),
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    backgroundImage: (user?.profileImageUrl.isNotEmpty ?? false)
                                        ? NetworkImage(user!.profileImageUrl)
                                        : null,
                                    child: (user?.profileImageUrl.isEmpty ?? true)
                                        ? const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 28,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getGreeting(),
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Search Bar
                            GestureDetector(
                              onTap: () => context.go('/explore'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Search trails, groups...',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trekking Stats Section (8 cards like web)
                        _buildTrekkingStatsSection(theme, user, userStats),
                        const SizedBox(height: 28),

                        // Scheduled Treks from user's joinedTrails
                        _buildScheduledTreksSection(theme, user),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildTrekkingStatsSection(ThemeData theme, UserEntity? user, UserStatsEntity? userStats) {
    final stepsFormatted = _formatNumber(_totalSteps);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Trekking Stats',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // First row: 4 cards
        Row(
          children: [
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.terrain_rounded,
                '${userStats?.totalHikes ?? 0}',
                'Total Treks',
                Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.location_on_rounded,
                '${(userStats?.totalDistance ?? 0).toStringAsFixed(1)} km',
                'Distance',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.trending_up_rounded,
                '${(userStats?.totalElevation ?? 0).toStringAsFixed(0)}m',
                'Elevation',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.schedule_rounded,
                '${(userStats?.totalHours ?? 0).toStringAsFixed(1)}h',
                'Hours',
                Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Second row: 4 cards
        Row(
          children: [
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.check_circle_rounded,
                '${user?.completedTrails.length ?? 0}',
                'Completed',
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.calendar_today_rounded,
                '${user?.joinedTrails.length ?? 0}',
                'Scheduled',
                Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardCompact(
                theme,
                Icons.people_rounded,
                '${user?.groupsCount ?? 0}',
                'Groups',
                Colors.pink,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/steps'),
                child: _buildStatCardCompact(
                  theme,
                  Icons.directions_walk_rounded,
                  stepsFormatted,
                  'Steps',
                  Colors.amber,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return NumberFormat.compact().format(number);
    }
    return number.toString();
  }

  Widget _buildStatCardCompact(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTreksSection(ThemeData theme, UserEntity? user) {
    final scheduledTrails = user?.joinedTrails ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Scheduled Treks (${scheduledTrails.length})',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (scheduledTrails.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.hiking_rounded,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No scheduled treks yet',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join a trail to start your trekking journey!',
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final joinedTrail = scheduledTrails[index];
              return _buildScheduledTrekItem(theme, joinedTrail);
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: scheduledTrails.length,
          ),
      ],
    );
  }

  Widget _buildScheduledTrekItem(ThemeData theme, JoinedTrailEntity joinedTrail) {
    final difficultyStr = joinedTrail.trailDifficulty.toLowerCase();
    final difficultyDisplay = joinedTrail.trailDifficulty.isNotEmpty
        ? joinedTrail.trailDifficulty[0].toUpperCase() + joinedTrail.trailDifficulty.substring(1)
        : 'Easy';
    final difficultyColor = _getDifficultyColor(difficultyStr);
    final dateStr = DateFormat('MMM d, yyyy').format(joinedTrail.scheduledDate);
    final trailName = joinedTrail.trailName.isNotEmpty 
        ? joinedTrail.trailName 
        : 'Trail';
    
    return GestureDetector(
      onTap: () {
        if (joinedTrail.trailId.isNotEmpty) {
          context.push('/trail/${joinedTrail.trailId}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: difficultyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.terrain_rounded,
                color: difficultyColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trailName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (joinedTrail.trailLocation.isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            joinedTrail.trailLocation,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: difficultyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                difficultyDisplay,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: difficultyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
      case 'moderate':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
