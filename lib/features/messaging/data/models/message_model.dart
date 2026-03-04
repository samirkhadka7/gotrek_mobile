import '../../domain/entities/message_entity.dart';

/// Message model for API serialization
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.groupId,
    required super.sender,
    required super.content,
    required super.createdAt,
    super.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      groupId: json['group']?.toString() ?? '',
      sender: MessageSenderModel.fromJson(
        json['sender'] is Map<String, dynamic>
            ? json['sender'] as Map<String, dynamic>
            : {'_id': json['sender']?.toString() ?? '', 'name': 'Unknown'},
      ),
      content: json['text']?.toString() ?? 
               json['content']?.toString() ?? 
               json['message']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'group': groupId,
      'sender': (sender as MessageSenderModel).toJson(),
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  MessageEntity toEntity() => MessageEntity(
        id: id,
        groupId: groupId,
        sender: sender,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// Message sender model for API serialization
class MessageSenderModel extends MessageSender {
  const MessageSenderModel({
    required super.id,
    required super.name,
    super.profileImage,
  });

  factory MessageSenderModel.fromJson(Map<String, dynamic> json) {
    return MessageSenderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown',
      profileImage: json['profileImage']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}
