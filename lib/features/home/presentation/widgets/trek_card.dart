import 'package:flutter/material.dart';

class TrekCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String location;
  final String days;
  final double rating;
  final int reviews;
  final String difficulty;

  const TrekCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.location,
    required this.days,
    required this.rating,
    required this.reviews,
    required this.difficulty,
  });

  Color get _difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF2E7D32);
      case 'moderate':
        return const Color(0xFFE65100);
      case 'hard':
        return const Color(0xFFC62828);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ────────────────────────────────────────────────────────
          Stack(
            children: [
              Image.asset(
                imagePath,
                height: 190,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 190,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(
                      Icons.terrain_rounded,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
              // Bottom gradient for readability
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.45),
                      ],
                    ),
                  ),
                ),
              ),
              // Difficulty badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(
                    color: _difficultyColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _difficultyColor.withValues(alpha: 0.40),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    difficulty,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Rating overlay (bottom-left of image)
              Positioned(
                bottom: 10,
                left: 12,
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Colors.amber, size: 16),
                    const SizedBox(width: 3),
                    Text(
                      '$rating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviews)',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Details ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Location + Duration row
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.schedule_rounded,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 3),
                    Text(
                      days,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // View Details button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
