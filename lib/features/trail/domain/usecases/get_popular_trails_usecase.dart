import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trail_entity.dart';
import '../repositories/trail_repository.dart';

/// Use case for getting popular/highly rated trails
class GetPopularTrailsUseCase implements UseCase<List<TrailEntity>, GetPopularTrailsParams> {
  final TrailRepository repository;

  GetPopularTrailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TrailEntity>>> call(GetPopularTrailsParams params) {
    return repository.getPopularTrails(limit: params.limit);
  }
}

/// Parameters for GetPopularTrailsUseCase
class GetPopularTrailsParams extends Equatable {
  final int limit;

  const GetPopularTrailsParams({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}
