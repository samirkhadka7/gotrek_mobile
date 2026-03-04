import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';

/// Abstract repository for message operations
abstract class MessageRepository {
  /// Get all messages for a group
  Future<Either<Failure, List<MessageEntity>>> getMessagesByGroup(String groupId);

  /// Send a message to a group (via Socket.IO)
  Future<Either<Failure, void>> sendMessage({
    required String groupId,
    required String content,
  });
}
