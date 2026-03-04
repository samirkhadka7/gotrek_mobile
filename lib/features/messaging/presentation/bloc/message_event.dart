import 'package:equatable/equatable.dart';

import '../../domain/entities/message_entity.dart';

/// Base event for message operations
abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load messages for a group
class LoadMessagesEvent extends MessageEvent {
  final String groupId;

  const LoadMessagesEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Event to send a new message
class SendMessageEvent extends MessageEvent {
  final String groupId;
  final String content;
  final String senderId;
  final String senderName;
  final String? senderProfileImage;

  const SendMessageEvent({
    required this.groupId,
    required this.content,
    required this.senderId,
    required this.senderName,
    this.senderProfileImage,
  });

  @override
  List<Object?> get props => [groupId, content, senderId, senderName, senderProfileImage];
}

/// Event when a new message is received via Socket.IO
class MessageReceivedEvent extends MessageEvent {
  final MessageEntity message;

  const MessageReceivedEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event to join a group chat room
class JoinGroupChatEvent extends MessageEvent {
  final String groupId;

  const JoinGroupChatEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Event to leave a group chat room
class LeaveGroupChatEvent extends MessageEvent {
  final String groupId;

  const LeaveGroupChatEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Event to clear messages
class ClearMessagesEvent extends MessageEvent {
  const ClearMessagesEvent();
}
/// Event when a message error occurs
class MessageErrorEvent extends MessageEvent {
  final String error;

  const MessageErrorEvent({required this.error});

  @override
  List<Object?> get props => [error];
}