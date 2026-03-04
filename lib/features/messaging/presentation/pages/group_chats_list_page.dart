import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../group/domain/entities/group_entity.dart';
import '../../../group/presentation/bloc/group_bloc.dart';
import '../../../group/presentation/bloc/group_state.dart';
import '../../../group/presentation/bloc/group_event.dart';

/// WhatsApp-style chat list page with TrailMate AI chatbot
class GroupChatsListPage extends StatefulWidget {
  const GroupChatsListPage({super.key});

  @override
  State<GroupChatsListPage> createState() => _GroupChatsListPageState();
}

class _GroupChatsListPageState extends State<GroupChatsListPage> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(const LoadMyGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More',
          ),
        ],
      ),
      body: Column(
        children: [
          // TrailMate AI Chatbot - always visible at top
          _buildChatbotTile(theme),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),

          // Group chats list
          Expanded(
            child: BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is MyGroupsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MyGroupsLoaded) {
                  final authState = context.read<AuthBloc>().state;
                  final currentUserId =
                      authState is AuthAuthenticated ? authState.user.id : '';
                  final groups = state.groups
                      .where((g) =>
                          g.isUserMember(currentUserId) ||
                          g.creatorId == currentUserId ||
                          (g.leader != null && g.leader!.userId == currentUserId))
                      .toList();

                  if (groups.isEmpty) {
                    return _buildEmptyGroupsState(theme);
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return _buildGroupChatTile(theme, groups[index]);
                    },
                  );
                }

                // Error state
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load chats',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check your connection and try again',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () =>
                            context.read<GroupBloc>().add(const LoadMyGroupsEvent()),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating action button for new chat
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/groups'),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.chat_rounded, color: Colors.white),
      ),
    );
  }

  /// TrailMate AI Chatbot tile - appears at the top of the chat list
  Widget _buildChatbotTile(ThemeData theme) {
    return InkWell(
      onTap: () => context.push('/chatbot'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // AI gradient avatar with sparkle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'TrailMate AI',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ask me about trails, trekking tips & more...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Sparkle icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// WhatsApp-style group chat tile
  Widget _buildGroupChatTile(ThemeData theme, GroupEntity group) {
    final memberCount = group.participants.length;

    return InkWell(
      onTap: () {
        context.push('/chat/${group.id}', extra: group.name);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Group avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getAvatarColor(group.name),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text(
                  group.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        _getGroupDateText(group),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.group_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$memberCount ${memberCount == 1 ? 'member' : 'members'}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: theme.colorScheme.onSurfaceVariant,
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

  /// Empty state when no groups joined
  Widget _buildEmptyGroupsState(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.forum_rounded,
              size: 40,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No group chats yet',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join a trekking group to start chatting with fellow trekkers',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.go('/groups'),
            icon: const Icon(Icons.explore_rounded, size: 18),
            label: const Text('Explore Groups'),
          ),
        ],
      ),
    );
  }

  /// Get avatar color based on group name
  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFF00897B), // Teal
      const Color(0xFF5C6BC0), // Indigo
      const Color(0xFFEF5350), // Red
      const Color(0xFFFF7043), // Deep Orange
      const Color(0xFF66BB6A), // Green
      const Color(0xFFAB47BC), // Purple
      const Color(0xFF42A5F5), // Blue
      const Color(0xFFEC407A), // Pink
    ];
    final index = name.codeUnits.fold(0, (sum, c) => sum + c) % colors.length;
    return colors[index];
  }

  /// Get formatted date text for the group tile
  String _getGroupDateText(GroupEntity group) {
    try {
      {
        final now = DateTime.now();
        final date = group.createdAt;
        final diff = now.difference(date);
        if (diff.inDays == 0) {
          return 'Today';
        } else if (diff.inDays == 1) {
          return 'Yesterday';
        } else if (diff.inDays < 7) {
          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          return days[date.weekday - 1];
        } else {
          return '${date.day}/${date.month}/${date.year}';
        }
      }
    } catch (_) {}
    return '';
  }
}
