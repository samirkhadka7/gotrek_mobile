import 'package:equatable/equatable.dart';

/// Message entity representing a chat message in a group
class MessageEntity extends Equatable {
  final String id;
  final String groupId;
  final MessageSender sender;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const MessageEntity({
    required this.id,
    required this.groupId,
    required this.sender,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, groupId, sender, content, createdAt, updatedAt];
}

/// Message sender information
class MessageSender extends Equatable {
  final String id;
  final String name;
  final String? profileImage;

  const MessageSender({
    required this.id,
    required this.name,
    this.profileImage,
  });

  @override
  List<Object?> get props => [id, name, profileImage];
}
