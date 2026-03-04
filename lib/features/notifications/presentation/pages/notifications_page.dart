import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../injection/injection.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = sl<ApiClient>();
      final response =
          await apiClient.get('${ApiConstants.baseUrl}/notifications');
      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final List<dynamic> raw = data['notifications'] ?? data['data'] ?? [];
        setState(() {
          _notifications = raw.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _notifications = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _notifications = [];
        _error = e.toString();
      });
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final apiClient = sl<ApiClient>();
      await apiClient.patch('${ApiConstants.baseUrl}/notifications/read-all', data: {});
      _loadNotifications();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildError(theme);
    }

    if (_notifications.isEmpty) {
      return _buildEmpty(theme);
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final n = _notifications[index];
          return _NotificationCard(notification: n, onTap: () {
            _markAsRead(n['_id']?.toString() ?? '');
          });
        },
      ),
    );
  }

  Future<void> _markAsRead(String id) async {
    if (id.isEmpty) return;
    try {
      final apiClient = sl<ApiClient>();
      await apiClient.patch('${ApiConstants.baseUrl}/notifications/$id/read', data: {});
      _loadNotifications();
    } catch (_) {}
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 52,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You're all caught up!\nWe'll notify you about important updates.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 52, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: _loadNotifications,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  IconData _iconForType(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case 'join_request_approved':
        return Icons.check_circle_rounded;
      case 'join_request_declined':
        return Icons.cancel_rounded;
      case 'upcoming_hike_reminder':
        return Icons.terrain_rounded;
      case 'achievement_unlocked':
        return Icons.emoji_events_rounded;
      case 'group':
      case 'group_invite':
        return Icons.group_rounded;
      case 'trail':
        return Icons.terrain_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'system':
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _colorForType(String? type, ThemeData theme) {
    switch ((type ?? '').toLowerCase()) {
      case 'join_request_approved':
        return Colors.green;
      case 'join_request_declined':
        return Colors.red;
      case 'upcoming_hike_reminder':
        return Colors.orange;
      case 'achievement_unlocked':
        return Colors.amber;
      case 'group':
      case 'group_invite':
        return Colors.blue;
      case 'trail':
        return Colors.green;
      case 'payment':
        return Colors.purple;
      default:
        return theme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = notification['type'] as String?;
    final title = notification['title'] as String? ?? 'Notification';
    final message = notification['message'] as String? ?? '';
    final isRead = notification['read'] as bool? ?? false;
    final createdAt = notification['createdAt'] as String?;
    final color = _colorForType(type, theme);

    String timeAgo = '';
    if (createdAt != null) {
      try {
        final dt = DateTime.parse(createdAt);
        final diff = DateTime.now().difference(dt);
        if (diff.inDays > 0) {
          timeAgo = DateFormat('MMM d').format(dt);
        } else if (diff.inHours > 0) {
          timeAgo = '${diff.inHours}h ago';
        } else if (diff.inMinutes > 0) {
          timeAgo = '${diff.inMinutes}m ago';
        } else {
          timeAgo = 'Just now';
        }
      } catch (_) {}
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? theme.colorScheme.surface
              : theme.colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? theme.colorScheme.outlineVariant
                : theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconForType(type), color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isRead ? FontWeight.w500 : FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (timeAgo.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
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
}
