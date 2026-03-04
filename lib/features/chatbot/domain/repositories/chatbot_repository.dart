import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

/// Repository for chatbot operations
abstract class ChatbotRepository {
  /// Send a query to the chatbot and get a response
  Future<Either<Failure, String>> sendQuery(String query);
}
