import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trail_entity.dart';
import '../repositories/trail_repository.dart';

/// Use case for getting a single trail by ID
class GetTrailByIdUseCase implements UseCase<TrailEntity, GetTrailByIdParams> {
  final TrailRepository repository;

  GetTrailByIdUseCase(this.repository);

  @override
  Future<Either<Failure, TrailEntity>> call(GetTrailByIdParams params) {
    return repository.getTrailById(params.trailId);
  }
}

/// Parameters for GetTrailByIdUseCase
class GetTrailByIdParams extends Equatable {
  final String trailId;

  const GetTrailByIdParams({required this.trailId});

  @override
  List<Object?> get props => [trailId];
}
