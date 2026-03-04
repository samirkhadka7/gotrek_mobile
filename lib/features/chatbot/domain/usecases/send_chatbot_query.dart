import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chatbot_repository.dart';

/// Parameters for sending a chatbot query
class SendChatbotQueryParams extends Equatable {
  final String query;

  const SendChatbotQueryParams({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Use case for sending a query to the chatbot
class SendChatbotQueryUseCase implements UseCase<String, SendChatbotQueryParams> {
  final ChatbotRepository repository;

  SendChatbotQueryUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendChatbotQueryParams params) async {
    return await repository.sendQuery(params.query);
  }
}
