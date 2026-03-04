import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/steps_entity.dart';
import '../repositories/steps_repository.dart';

/// Use case for logging steps
class LogStepsUseCase implements UseCase<StepRecord, LogStepsParams> {
  final StepsRepository repository;

  LogStepsUseCase(this.repository);

  @override
  Future<Either<Failure, StepRecord>> call(LogStepsParams params) {
    return repository.logSteps(
      steps: params.steps,
      distance: params.distance,
      calories: params.calories,
    );
  }
}

/// Parameters for logging steps
class LogStepsParams extends Equatable {
  final int steps;
  final double? distance;
  final int? calories;

  const LogStepsParams({
    required this.steps,
    this.distance,
    this.calories,
  });

  @override
  List<Object?> get props => [steps, distance, calories];
}
