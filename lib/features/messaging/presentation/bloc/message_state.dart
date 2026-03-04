import 'package:equatable/equatable.dart';

import '../../domain/entities/message_entity.dart';

/// Base state for message operations
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MessageInitial extends MessageState {
  const MessageInitial();
}

/// Loading state
class MessageLoading extends MessageState {
  const MessageLoading();
}

/// Loaded state with messages
class MessageLoaded extends MessageState {
  final List<MessageEntity> messages;
  final String groupId;

  const MessageLoaded({
    required this.messages,
    required this.groupId,
  });

  MessageLoaded copyWith({
    List<MessageEntity>? messages,
    String? groupId,
  }) {
    return MessageLoaded(
      messages: messages ?? this.messages,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  List<Object?> get props => [messages, groupId];
}

/// Error state
class MessageError extends MessageState {
  final String message;

  const MessageError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Message sent state
class MessageSent extends MessageState {
  final List<MessageEntity> messages;
  final String groupId;

  const MessageSent({
    required this.messages,
    required this.groupId,
  });

  @override
  List<Object?> get props => [messages, groupId];
}
