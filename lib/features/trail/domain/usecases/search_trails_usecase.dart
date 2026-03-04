import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/trail_entity.dart';
import '../repositories/trail_repository.dart';

/// Use case for searching trails
class SearchTrailsUseCase implements UseCase<List<TrailEntity>, SearchTrailsParams> {
  final TrailRepository repository;

  SearchTrailsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TrailEntity>>> call(SearchTrailsParams params) {
    return repository.searchTrails(params.query);
  }
}

/// Parameters for SearchTrailsUseCase
class SearchTrailsParams extends Equatable {
  final String query;

  const SearchTrailsParams({required this.query});

  @override
  List<Object?> get props => [query];
}
