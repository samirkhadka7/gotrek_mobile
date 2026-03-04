import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/steps_entity.dart';
import '../repositories/steps_repository.dart';

/// Use case for getting weekly step statistics
class GetWeeklyStatsUseCase implements UseCase<StepsStats, NoParams> {
  final StepsRepository repository;

  GetWeeklyStatsUseCase(this.repository);

  @override
  Future<Either<Failure, StepsStats>> call(NoParams params) {
    return repository.getWeeklyStats();
  }
}

/// Use case for getting monthly step statistics
class GetMonthlyStatsUseCase implements UseCase<StepsStats, NoParams> {
  final StepsRepository repository;

  GetMonthlyStatsUseCase(this.repository);

  @override
  Future<Either<Failure, StepsStats>> call(NoParams params) {
    return repository.getMonthlyStats();
  }
}
