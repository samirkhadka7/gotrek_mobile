import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(SuggestedAction)? onSuggestionTap;

  const ChatBubble({
    super.key,
    required this.message,
    this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Avatar & Message Row
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                _buildAvatar(theme),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser
                        ? theme.colorScheme.primary
                        : message.isError
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isUser
                      ? Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        )
                      : MarkdownBody(
                          data: message.content,
                          styleSheet: MarkdownStyleSheet(
                            p: theme.textTheme.bodyMedium?.copyWith(
                              color: message.isError
                                  ? theme.colorScheme.onErrorContainer
                                  : theme.colorScheme.onSurface,
                              height: 1.5,
                            ),
                            strong: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            listBullet: theme.textTheme.bodyMedium,
                          ),
                          selectable: true,
                        ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                _buildUserAvatar(theme),
              ],
            ],
          ),

          // Timestamp
          Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isUser ? 0 : 48,
              right: isUser ? 48 : 0,
            ),
            child: Text(
              _formatTime(message.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                fontSize: 11,
              ),
            ),
          ),

          // Suggested Actions
          if (message.suggestedActions != null &&
              message.suggestedActions!.isNotEmpty &&
              !isUser) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 48),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.suggestedActions!.map((action) {
                  return _SuggestionChip(
                    action: action,
                    onTap: () => onSuggestionTap?.call(action),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.smart_toy_rounded,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar(ThemeData theme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.person_rounded,
        color: theme.colorScheme.primary,
        size: 20,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class _SuggestionChip extends StatelessWidget {
  final SuggestedAction action;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (action.iconType != null) ...[
                Icon(
                  _getIconForType(action.iconType!),
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                action.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(IconType type) {
    switch (type) {
      case IconType.trail:
        return Icons.terrain_rounded;
      case IconType.group:
        return Icons.groups_rounded;
      case IconType.weather:
        return Icons.wb_sunny_rounded;
      case IconType.tips:
        return Icons.lightbulb_rounded;
      case IconType.help:
        return Icons.help_outline_rounded;
    }
  }
}
