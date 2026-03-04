import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/group_entity.dart';

/// Group card widget for displaying group in a list
class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;
  final bool showFullDetails;

  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Image (Trail Image)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: group.trailImage != null
                      ? CachedNetworkImage(
                          imageUrl: group.trailImage!,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 140,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => _buildPlaceholderImage(theme),
                        )
                      : _buildPlaceholderImage(theme),
                ),
                // Status Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: GroupStatusBadge(status: group.status),
                ),
                // Participants Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: ParticipantsBadge(
                    current: group.currentParticipants,
                    max: group.maxParticipants,
                  ),
                ),
              ],
            ),

            // Group Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    group.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Trail Name
                  Row(
                    children: [
                      Icon(
                        Icons.terrain_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          group.trailName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Start Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        group.formattedStartDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (group.availableSlots > 0) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${group.availableSlots} spots left',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Description (if full details)
                  if (showFullDetails && group.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      group.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Leader info
                  if (showFullDetails && group.leader != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          backgroundImage: group.leader!.profilePicture != null
                              ? NetworkImage(group.leader!.profilePicture!)
                              : null,
                          child: group.leader!.profilePicture == null
                              ? Icon(
                                  Icons.person,
                                  size: 14,
                                  color: theme.colorScheme.onPrimaryContainer,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Led by ${group.leader!.username}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(ThemeData theme) {
    return Container(
      height: 140,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.group,
          size: 48,
          color: theme.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }
}

/// Compact group card for horizontal lists
class GroupCardCompact extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;

  const GroupCardCompact({
    super.key,
    required this.group,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 220,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: group.trailImage != null
                        ? CachedNetworkImage(
                            imageUrl: group.trailImage!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 100,
                              color: theme.colorScheme.surfaceContainerHighest,
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 100,
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.group,
                                size: 32,
                                color: theme.colorScheme.primary.withOpacity(0.5),
                              ),
                            ),
                          )
                        : Container(
                            height: 100,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.group,
                              size: 32,
                              color: theme.colorScheme.primary.withOpacity(0.5),
                            ),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GroupStatusBadge(
                      status: group.status,
                      compact: true,
                    ),
                  ),
                ],
              ),

              // Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      group.formattedStartDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          group.participantCountText,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Status badge widget
class GroupStatusBadge extends StatelessWidget {
  final GroupStatus status;
  final bool compact;

  const GroupStatusBadge({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: Color(status.colorValue),
        borderRadius: BorderRadius.circular(compact ? 4 : 8),
      ),
      child: Text(
        status.toDisplayString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 10 : 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Participants badge widget
class ParticipantsBadge extends StatelessWidget {
  final int current;
  final int max;

  const ParticipantsBadge({
    super.key,
    required this.current,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    final isFull = current >= max;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isFull ? Colors.red.withOpacity(0.9) : Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            '$current/$max',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Join request card widget
class JoinRequestCard extends StatelessWidget {
  final JoinRequest request;
  final VoidCallback? onApprove;
  final VoidCallback? onDeny;
  final bool isLoading;

  const JoinRequestCard({
    super.key,
    required this.request,
    this.onApprove,
    this.onDeny,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: request.userProfilePicture != null
                      ? NetworkImage(request.userProfilePicture!)
                      : null,
                  child: request.userProfilePicture == null
                      ? Icon(
                          Icons.person,
                          color: theme.colorScheme.onPrimaryContainer,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.username,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Requested ${_formatTimeAgo(request.createdAt)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (request.message != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.message!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading ? null : onDeny,
                    child: const Text('Deny'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : onApprove,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}

/// Participant list tile
class ParticipantTile extends StatelessWidget {
  final GroupParticipant participant;
  final bool isCurrentUser;

  const ParticipantTile({
    super.key,
    required this.participant,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        backgroundImage: participant.profilePicture != null
            ? NetworkImage(participant.profilePicture!)
            : null,
        child: participant.profilePicture == null
            ? Icon(
                Icons.person,
                color: theme.colorScheme.onPrimaryContainer,
              )
            : null,
      ),
      title: Row(
        children: [
          Text(
            participant.username,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'You',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        participant.role.toDisplayString(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: participant.isLeader
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: participant.isLeader ? FontWeight.w500 : null,
        ),
      ),
      trailing: participant.isLeader
          ? Icon(
              Icons.star,
              color: Colors.amber[700],
              size: 20,
            )
          : null,
    );
  }
}
