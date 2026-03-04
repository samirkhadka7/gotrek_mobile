import 'package:flutter/material.dart';
import '../../../group/domain/entities/group_entity.dart';

/// Widget displaying a group in the admin list
class GroupListItemWidget extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback onTap;

  const GroupListItemWidget({
    Key? key,
    required this.group,
    required this.onTap,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (group.status) {
      case GroupStatus.forming:
        return Colors.blue;
      case GroupStatus.upcoming:
        return Colors.indigo;
      case GroupStatus.active:
        return Colors.green;
      case GroupStatus.completed:
        return Colors.grey;
      case GroupStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText() {
    switch (group.status) {
      case GroupStatus.forming:
        return 'Forming';
      case GroupStatus.upcoming:
        return 'Upcoming';
      case GroupStatus.active:
        return 'Active';
      case GroupStatus.completed:
        return 'Completed';
      case GroupStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        leading: (group.trailImage?.isNotEmpty ?? false)
            ? Image.network(
                group.trailImage!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.group),
              )
            : const Icon(Icons.group),
        title: Text(group.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.trailName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            Text(
              '${group.currentParticipants}/${group.maxParticipants} participants • ${group.formattedStartDate}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Chip(
          label: Text(_getStatusText()),
          backgroundColor: _getStatusColor().withOpacity(0.2),
          labelStyle: TextStyle(
            color: _getStatusColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
