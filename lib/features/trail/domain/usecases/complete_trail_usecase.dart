import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/trail_repository.dart';

/// Use case for completing a joined trail
class CompleteTrailUseCase implements UseCase<void, CompleteTrailParams> {
  final TrailRepository repository;

  CompleteTrailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CompleteTrailParams params) {
    return repository.completeTrail(params.joinedTrailId);
  }
}

/// Parameters for CompleteTrailUseCase
class CompleteTrailParams extends Equatable {
  final String joinedTrailId;

  const CompleteTrailParams({required this.joinedTrailId});

  @override
  List<Object?> get props => [joinedTrailId];
}
