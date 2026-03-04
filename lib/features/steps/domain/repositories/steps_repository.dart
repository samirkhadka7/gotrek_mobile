import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/steps_entity.dart';

/// Repository for step tracking operations
abstract class StepsRepository {
  /// Get today's step record
  Future<Either<Failure, StepRecord>> getTodaySteps();

  /// Log steps for today
  Future<Either<Failure, StepRecord>> logSteps({
    required int steps,
    double? distance,
    int? calories,
  });

  /// Get step history for a date range
  Future<Either<Failure, List<StepRecord>>> getStepHistory({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get weekly statistics
  Future<Either<Failure, StepsStats>> getWeeklyStats();

  /// Get monthly statistics
  Future<Either<Failure, StepsStats>> getMonthlyStats();

  /// Update step goal
  Future<Either<Failure, StepGoal>> updateGoal(StepGoal goal);

  /// Get current goal settings
  Future<Either<Failure, StepGoal>> getGoal();

  /// Start a tracking session
  Future<Either<Failure, StepSession>> startSession({
    String? trailId,
    String? trailName,
  });

  /// Update ongoing session
  Future<Either<Failure, StepSession>> updateSession({
    required String sessionId,
    int? steps,
    double? distance,
    int? calories,
    LocationPoint? location,
  });

  /// End a tracking session
  Future<Either<Failure, StepSession>> endSession(String sessionId);

  /// Get active session if any
  Future<Either<Failure, StepSession?>> getActiveSession();

  /// Get session history
  Future<Either<Failure, List<StepSession>>> getSessionHistory({
    int page = 1,
    int limit = 10,
  });

  /// Get achievements
  Future<Either<Failure, List<StepAchievement>>> getAchievements();

  /// Sync steps from device (pedometer)
  Future<Either<Failure, StepRecord>> syncFromDevice(int deviceSteps);
}
