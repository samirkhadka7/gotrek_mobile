import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../injection/injection.dart';
import '../../domain/entities/trail_entity.dart';
import '../bloc/trail_bloc.dart';
import '../bloc/trail_event.dart';
import '../bloc/trail_state.dart';
import '../widgets/trail_card.dart';

/// Check if URL is valid for network image
bool _isValidImageUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

/// Trail details page
class TrailDetailsPage extends StatefulWidget {
  final String trailId;

  const TrailDetailsPage({
    super.key,
    required this.trailId,
  });

  @override
  State<TrailDetailsPage> createState() => _TrailDetailsPageState();
}

class _TrailDetailsPageState extends State<TrailDetailsPage> {
  late final TrailBloc _trailBloc;

  @override
  void initState() {
    super.initState();
    _trailBloc = sl<TrailBloc>();
    _trailBloc.add(LoadTrailDetailsEvent(trailId: widget.trailId));
  }

  void _showJoinDialog(TrailEntity trail) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.hiking,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Join Trail',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          trail.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Date selection
              const Text(
                'Select start date:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              StatefulBuilder(
                builder: (context, setState) {
                  return InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _trailBloc.add(JoinTrailEvent(
                          trailId: trail.id,
                          startDate: selectedDate,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Join Trail',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(TrailEntity trail) {
    int selectedRating = 5;
    final reviewController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rate This Trail',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          trail.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Star rating
              const Text(
                'How would you rate this trail?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedRating = index + 1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Review text field
              const Text(
                'Write a review (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reviewController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your experience...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _trailBloc.add(RateTrailEvent(
                      trailId: trail.id,
                      rating: selectedRating,
                      review: reviewController.text.isNotEmpty
                          ? reviewController.text
                          : null,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Rating',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _trailBloc,
      child: BlocConsumer<TrailBloc, TrailState>(
        listener: (context, state) {
          if (state is TrailOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TrailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TrailDetailsLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is TrailError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _trailBloc.add(
                          LoadTrailDetailsEvent(trailId: widget.trailId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TrailDetailsLoaded) {
            return _TrailDetailsContent(
              trail: state.trail,
              onJoin: () => _showJoinDialog(state.trail),
              onRate: () => _showRatingDialog(state.trail),
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

class _TrailDetailsContent extends StatelessWidget {
  final TrailEntity trail;
  final VoidCallback onJoin;
  final VoidCallback onRate;

  const _TrailDetailsContent({
    required this.trail,
    required this.onJoin,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                trail.name,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 8)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  _isValidImageUrl(trail.primaryImage)
                      ? CachedNetworkImage(
                          imageUrl: trail.primaryImage,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.terrain,
                              size: 80,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.terrain,
                            size: 80,
                            color: theme.colorScheme.primary.withOpacity(0.5),
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 16,
                    child: DifficultyBadge(difficulty: trail.difficulty),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          trail.location,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (trail.region != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        trail.region!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.straighten,
                          label: 'Distance',
                          value: trail.formattedDistance,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.trending_up,
                          label: 'Elevation',
                          value: trail.formattedElevation,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.schedule,
                          label: 'Duration',
                          value: trail.formattedDuration,
                        ),
                      ),
                    ],
                  ),

                  if (trail.numRatings > 0) ...[
                    const SizedBox(height: 16),
                    _RatingCard(
                      rating: trail.averageRating,
                      count: trail.numRatings,
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Description
                  if (trail.description != null) ...[
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      trail.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Highlights
                  if (trail.highlights.isNotEmpty) ...[
                    Text(
                      'Highlights',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: trail.highlights.map((highlight) {
                        return Chip(
                          label: Text(highlight),
                          avatar: const Icon(Icons.check_circle, size: 18),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Features
                  if (trail.features.isNotEmpty) ...[
                    Text(
                      'Features',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: trail.features.map((feature) {
                        return Chip(
                          label: Text(feature),
                          backgroundColor: theme.colorScheme.secondaryContainer,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Best Seasons
                  if (trail.seasons.isNotEmpty) ...[
                    Text(
                      'Best Seasons',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: trail.seasons.map((season) {
                        return Chip(
                          label: Text(season),
                          avatar: const Icon(Icons.wb_sunny, size: 18),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Images Gallery
                  if (trail.images.length > 1) ...[
                    Text(
                      'Gallery',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trail.images.length,
                        itemBuilder: (context, index) {
                          final imageUrl = trail.images[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _isValidImageUrl(imageUrl)
                                  ? CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 160,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Container(
                                        width: 160,
                                        height: 120,
                                        color: theme.colorScheme.surfaceContainerHighest,
                                        child: const Icon(Icons.terrain),
                                      ),
                                    )
                                  : Container(
                                      width: 160,
                                      height: 120,
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      child: const Icon(Icons.terrain),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Spacer for bottom button
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Actions
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Rate button
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: onRate,
                  icon: const Icon(Icons.star_border, color: Colors.amber),
                  tooltip: 'Rate Trail',
                ),
              ),
              const SizedBox(width: 12),
              // Join button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onJoin,
                  icon: const Icon(Icons.hiking),
                  label: const Text(
                    'Join This Trail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  final double rating;
  final int count;

  const _RatingCard({
    required this.rating,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[700], size: 28),
                  const SizedBox(width: 8),
                  Text(
                    rating.toStringAsFixed(1),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Rating',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Based on $count reviews',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
