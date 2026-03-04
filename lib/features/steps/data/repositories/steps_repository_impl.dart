import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart' show ServerException, UnauthorizedException;
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/steps_entity.dart';
import '../../domain/repositories/steps_repository.dart';
import '../datasources/steps_local_datasource.dart';
import '../datasources/steps_remote_datasource.dart';
import '../models/steps_model.dart';

/// Implementation of StepsRepository
class StepsRepositoryImpl implements StepsRepository {
  final StepsRemoteDataSource remoteDataSource;
  final StepsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  StepsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  static StepRecordModel _emptyTodayRecord() => StepRecordModel(
        modelId: 'empty',
        modelSteps: 0,
        modelDistance: 0.0,
        modelCalories: 0,
        modelDate: DateTime.now(),
        modelActiveMinutes: 0,
        modelGoal: 10000,
      );

  @override
  Future<Either<Failure, StepRecord>> getTodaySteps() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTodaySteps();
        await localDataSource.cacheTodaySteps(result);
        return Right(result);
      } catch (_) {
        // Backend steps routes not yet implemented — show empty data
        return Right(_emptyTodayRecord());
      }
    } else {
      final cached = await localDataSource.getCachedTodaySteps();
      if (cached != null) {
        return Right(cached);
      }
      return Right(_emptyTodayRecord());
    }
  }

  @override
  Future<Either<Failure, StepRecord>> logSteps({
    required int steps,
    double? distance,
    int? calories,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.logSteps(
          steps: steps,
          distance: distance,
          calories: calories,
        );
        await localDataSource.cacheTodaySteps(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<StepRecord>>> getStepHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getStepHistory(
          startDate: startDate,
          endDate: endDate,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  static const StepsStats _emptyStats = StepsStats(
    totalSteps: 0,
    totalDistance: 0.0,
    totalCalories: 0,
    averageSteps: 0,
    bestDay: 0,
    activeDays: 0,
    streakDays: 0,
    dailyData: [],
  );

  @override
  Future<Either<Failure, StepsStats>> getWeeklyStats() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getWeeklyStats();
        return Right(result);
      } catch (_) {
        // Backend steps routes not yet implemented — show empty data
        return const Right(_emptyStats);
      }
    } else {
      return const Right(_emptyStats);
    }
  }

  @override
  Future<Either<Failure, StepsStats>> getMonthlyStats() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMonthlyStats();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepGoal>> updateGoal(StepGoal goal) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateGoal(goal);
        await localDataSource.cacheGoal(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepGoal>> getGoal() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getGoal();
        await localDataSource.cacheGoal(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedGoal();
      if (cached != null) {
        return Right(cached);
      }
      return const Right(StepGoalModel()); // Default goal
    }
  }

  @override
  Future<Either<Failure, StepSession>> startSession({
    String? trailId,
    String? trailName,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.startSession(
          trailId: trailId,
          trailName: trailName,
        );
        await localDataSource.cacheActiveSession(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepSession>> updateSession({
    required String sessionId,
    int? steps,
    double? distance,
    int? calories,
    LocationPoint? location,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateSession(
          sessionId: sessionId,
          steps: steps,
          distance: distance,
          calories: calories,
        );
        await localDataSource.cacheActiveSession(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepSession>> endSession(String sessionId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.endSession(sessionId);
        await localDataSource.cacheActiveSession(null);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepSession?>> getActiveSession() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getActiveSession();
        await localDataSource.cacheActiveSession(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      final cached = await localDataSource.getCachedActiveSession();
      return Right(cached);
    }
  }

  @override
  Future<Either<Failure, List<StepSession>>> getSessionHistory({
    int page = 1,
    int limit = 10,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getSessionHistory(
          page: page,
          limit: limit,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<StepAchievement>>> getAchievements() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAchievements();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, StepRecord>> syncFromDevice(int deviceSteps) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.syncFromDevice(deviceSteps);
        await localDataSource.cacheTodaySteps(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
