import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../group/domain/entities/group_entity.dart';
import '../../../group/presentation/bloc/group_bloc.dart';
import '../../../group/presentation/bloc/group_event.dart';
import '../../../group/presentation/bloc/group_state.dart';
import '../../../../injection/injection.dart';

class MyGroupsPage extends StatelessWidget {
  const MyGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GroupBloc>()..add(const LoadMyGroupsEvent()),
      child: const _MyGroupsView(),
    );
  }
}

class _MyGroupsView extends StatelessWidget {
  const _MyGroupsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Groups',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Group',
            onPressed: () => context.push('/groups/create'),
          ),
        ],
      ),
      body: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is MyGroupsLoading || state is GroupInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroupError) {
            return _ErrorState(
              message: state.message,
              onRetry: () => context
                  .read<GroupBloc>()
                  .add(const LoadMyGroupsEvent()),
            );
          }

          if (state is MyGroupsLoaded) {
            final groups = state.groups;
            if (groups.isEmpty) {
              return _EmptyState(
                onCreateGroup: () => context.push('/groups/create'),
                onBrowseGroups: () => context.go('/groups'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => context
                  .read<GroupBloc>()
                  .add(const LoadMyGroupsEvent()),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _GroupCard(group: groups[index], theme: theme),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupEntity group;
  final ThemeData theme;

  const _GroupCard({required this.group, required this.theme});

  Color _statusColor(GroupStatus status) {
    return Color(status.colorValue);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(group.status);
    final startDateStr = DateFormat('MMM d, yyyy').format(group.startDate);
    final participantCount = group.participants.length;
    final maxCount = group.maxParticipants;

    return GestureDetector(
      onTap: () => context.push('/group/${group.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
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
            // Header with image / placeholder
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: group.trailImage != null
                  ? Image.network(
                      group.trailImage!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          group.status.toDisplayString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (group.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 6),
                    Text(
                      group.description!,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        startDateStr,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.people_rounded,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$participantCount / $maxCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 120,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.group_rounded,
        size: 48,
        color: Colors.grey,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onBrowseGroups;

  const _EmptyState({
    required this.onCreateGroup,
    required this.onBrowseGroups,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_rounded,
                size: 52,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "You're not in any groups yet",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join an existing group or create your own\nto start trekking with others.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onBrowseGroups,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Browse Groups'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: onCreateGroup,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Group'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 52, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load groups',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant, fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
