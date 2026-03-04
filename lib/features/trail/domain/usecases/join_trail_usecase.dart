import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/trail_repository.dart';

/// Use case for joining a trail with a specific date
class JoinTrailUseCase implements UseCase<void, JoinTrailParams> {
  final TrailRepository repository;

  JoinTrailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(JoinTrailParams params) {
    return repository.joinTrailWithDate(
      trailId: params.trailId,
      startDate: params.startDate,
    );
  }
}

/// Parameters for JoinTrailUseCase
class JoinTrailParams extends Equatable {
  final String trailId;
  final DateTime startDate;

  const JoinTrailParams({
    required this.trailId,
    required this.startDate,
  });

  @override
  List<Object?> get props => [trailId, startDate];
}
