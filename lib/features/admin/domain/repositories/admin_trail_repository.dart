import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_trail_entity.dart';

/// Repository interface for admin trail operations
abstract class AdminTrailRepository {
  /// Get all trails with filters and pagination
  Future<Either<Failure, TrailListResult>> getAllTrails({
    int page = 1,
    int limit = 10,
    String? search,
    double? maxDistance,
    double? maxElevation,
    String? difficulty,
  });

  /// Get trail by ID
  Future<Either<Failure, AdminTrailEntity>> getTrailById(String trailId);

  /// Create new trail
  Future<Either<Failure, AdminTrailEntity>> createTrail({
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  });

  /// Update trail
  Future<Either<Failure, AdminTrailEntity>> updateTrail({
    required String trailId,
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  });

  /// Delete trail
  Future<Either<Failure, void>> deleteTrail(String trailId);
}
