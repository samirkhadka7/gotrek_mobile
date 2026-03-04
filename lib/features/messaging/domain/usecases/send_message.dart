import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/message_repository.dart';

/// Use case to send a message to a group
class SendMessage implements UseCase<void, SendMessageParams> {
  final MessageRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) {
    return repository.sendMessage(
      groupId: params.groupId,
      content: params.content,
    );
  }
}

/// Parameters for sending a message
class SendMessageParams extends Equatable {
  final String groupId;
  final String content;

  const SendMessageParams({
    required this.groupId,
    required this.content,
  });

  @override
  List<Object?> get props => [groupId, content];
}
