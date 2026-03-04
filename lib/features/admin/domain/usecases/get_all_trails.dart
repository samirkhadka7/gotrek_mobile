import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_trail_entity.dart';
import '../repositories/admin_trail_repository.dart';

/// Use case for getting all trails
class GetAllTrailsUseCase implements UseCase<TrailListResult, GetAllTrailsParams> {
  final AdminTrailRepository repository;

  GetAllTrailsUseCase(this.repository);

  @override
  Future<Either<Failure, TrailListResult>> call(GetAllTrailsParams params) {
    return repository.getAllTrails(
      page: params.page,
      limit: params.limit,
      search: params.search,
      maxDistance: params.maxDistance,
      maxElevation: params.maxElevation,
      difficulty: params.difficulty,
    );
  }
}

class GetAllTrailsParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final double? maxDistance;
  final double? maxElevation;
  final String? difficulty;

  const GetAllTrailsParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.maxDistance,
    this.maxElevation,
    this.difficulty,
  });

  @override
  List<Object?> get props =>
      [page, limit, search, maxDistance, maxElevation, difficulty];
}
