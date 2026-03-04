import 'package:equatable/equatable.dart';

/// Chat message types
enum MessageType {
  user,
  bot,
  system,
  loading,
}

/// Chat message entity
class ChatMessage extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isError;
  final List<SuggestedAction>? suggestedActions;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isError = false,
    this.suggestedActions,
  });

  bool get isUser => type == MessageType.user;
  bool get isBot => type == MessageType.bot;
  bool get isLoading => type == MessageType.loading;

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    bool? isError,
    List<SuggestedAction>? suggestedActions,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isError: isError ?? this.isError,
      suggestedActions: suggestedActions ?? this.suggestedActions,
    );
  }

  @override
  List<Object?> get props => [id, content, type, timestamp, isError, suggestedActions];
}

/// Suggested action for quick replies
class SuggestedAction extends Equatable {
  final String label;
  final String query;
  final IconType? iconType;

  const SuggestedAction({
    required this.label,
    required this.query,
    this.iconType,
  });

  @override
  List<Object?> get props => [label, query, iconType];
}

/// Icon types for suggested actions
enum IconType {
  trail,
  group,
  weather,
  tips,
  help,
}

/// Pre-defined quick suggestions
class QuickSuggestions {
  static const List<SuggestedAction> defaultSuggestions = [
    SuggestedAction(
      label: 'Best treks in Nepal',
      query: 'What are the best trekking routes in Nepal?',
      iconType: IconType.trail,
    ),
    SuggestedAction(
      label: 'Find a group',
      query: 'How can I join a trekking group?',
      iconType: IconType.group,
    ),
    SuggestedAction(
      label: 'Beginner tips',
      query: 'What tips do you have for beginner trekkers?',
      iconType: IconType.tips,
    ),
    SuggestedAction(
      label: 'Best season',
      query: 'When is the best time to trek in Nepal?',
      iconType: IconType.weather,
    ),
    SuggestedAction(
      label: 'Altitude sickness',
      query: 'How can I prevent altitude sickness?',
      iconType: IconType.tips,
    ),
  ];

  static const List<SuggestedAction> followUpSuggestions = [
    SuggestedAction(
      label: 'Tell me more',
      query: 'Can you tell me more about this?',
      iconType: IconType.help,
    ),
    SuggestedAction(
      label: 'Show trails',
      query: 'Show me popular trails',
      iconType: IconType.trail,
    ),
    SuggestedAction(
      label: 'Packing list',
      query: 'What should I pack for a trek?',
      iconType: IconType.tips,
    ),
  ];
}
