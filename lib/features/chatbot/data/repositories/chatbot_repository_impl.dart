import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_remote_datasource.dart';

/// Implementation of ChatbotRepository
class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatbotRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, String>> sendQuery(String query) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'No internet connection. TrailMate requires an active connection.',
      ));
    }

    try {
      final response = await remoteDataSource.sendQuery(query);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
