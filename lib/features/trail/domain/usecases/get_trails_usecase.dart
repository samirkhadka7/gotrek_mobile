import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trail_entity.dart';
import '../repositories/trail_repository.dart';

/// Use case for getting all trails with optional filters
class GetTrailsUseCase implements UseCase<List<TrailEntity>, GetTrailsParams> {
  final TrailRepository repository;

  GetTrailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TrailEntity>>> call(GetTrailsParams params) {
    return repository.getTrails(filters: params.filters);
  }
}

/// Parameters for GetTrailsUseCase
class GetTrailsParams extends Equatable {
  final TrailFilterParams? filters;

  const GetTrailsParams({this.filters});

  @override
  List<Object?> get props => [filters];
}
