import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/activity_remote_datasource.dart';

/// Implementation of ActivityRepository
class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ActivityRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ActivityEntity>>> getRecentActivities() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(
        message: 'No internet connection',
      ));
    }

    try {
      final activities = await remoteDataSource.getRecentActivities();
      return Right(activities.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
