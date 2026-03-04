import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../datasources/message_remote_datasource.dart';

/// Implementation of MessageRepository
class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessagesByGroup(String groupId) async {
    if (await networkInfo.isConnected) {
      try {
        final messages = await remoteDataSource.getMessagesByGroup(groupId);
        return Right(messages.map((m) => m.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String groupId,
    required String content,
  }) async {
    // Message sending is handled via Socket.IO
    // This method is kept for interface completeness
    // Real-time messaging is implemented in SocketService
    return const Right(null);
  }
}
