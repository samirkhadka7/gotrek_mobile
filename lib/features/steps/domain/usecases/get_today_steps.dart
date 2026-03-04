import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/steps_entity.dart';
import '../repositories/steps_repository.dart';

/// Use case for getting today's step count
class GetTodayStepsUseCase implements UseCase<StepRecord, NoParams> {
  final StepsRepository repository;

  GetTodayStepsUseCase(this.repository);

  @override
  Future<Either<Failure, StepRecord>> call(NoParams params) {
    return repository.getTodaySteps();
  }
}
