import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_trail_entity.dart';
import '../repositories/admin_trail_repository.dart';

/// Use case for updating trail
class UpdateTrailUseCase implements UseCase<AdminTrailEntity, UpdateTrailParams> {
  final AdminTrailRepository repository;

  UpdateTrailUseCase(this.repository);

  @override
  Future<Either<Failure, AdminTrailEntity>> call(UpdateTrailParams params) {
    return repository.updateTrail(
      trailId: params.trailId,
      name: params.name,
      description: params.description,
      location: params.location,
      distance: params.distance,
      elevation: params.elevation,
      difficulty: params.difficulty,
      durationMin: params.durationMin,
      durationMax: params.durationMax,
      imagePaths: params.imagePaths,
    );
  }
}

class UpdateTrailParams extends Equatable {
  final String trailId;
  final String name;
  final String description;
  final String location;
  final double distance;
  final double elevation;
  final String difficulty;
  final int? durationMin;
  final int? durationMax;
  final List<String> imagePaths;

  const UpdateTrailParams({
    required this.trailId,
    required this.name,
    required this.description,
    required this.location,
    required this.distance,
    required this.elevation,
    required this.difficulty,
    this.durationMin,
    this.durationMax,
    this.imagePaths = const [],
  });

  @override
  List<Object?> get props => [
        trailId,
        name,
        description,
        location,
        distance,
        elevation,
        difficulty,
        durationMin,
        durationMax,
        imagePaths,
      ];
}
