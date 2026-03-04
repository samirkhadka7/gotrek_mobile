import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/message_repository.dart';

/// Use case to get all messages for a specific group
class GetMessagesByGroup implements UseCase<List<MessageEntity>, String> {
  final MessageRepository repository;

  GetMessagesByGroup(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String groupId) {
    return repository.getMessagesByGroup(groupId);
  }
}
