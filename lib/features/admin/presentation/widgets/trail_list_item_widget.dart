import 'package:flutter/material.dart';
import '../../domain/entities/admin_trail_entity.dart';

/// Widget displaying a trail in the admin list
class TrailListItemWidget extends StatelessWidget {
  final AdminTrailEntity trail;
  final VoidCallback onTap;

  const TrailListItemWidget({
    Key? key,
    required this.trail,
    required this.onTap,
  }) : super(key: key);

  Color _getDifficultyColor() {
    switch (trail.difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: (trail.imageUrl?.isNotEmpty ?? false)
            ? Image.network(
                trail.imageUrl!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.landscape),
              )
            : const Icon(Icons.landscape),
        title: Text(trail.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trail.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${trail.distance}km • ${trail.elevation}m elevation',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Chip(
          label: Text(trail.difficulty),
          backgroundColor: _getDifficultyColor().withOpacity(0.2),
          labelStyle: TextStyle(
            color: _getDifficultyColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
