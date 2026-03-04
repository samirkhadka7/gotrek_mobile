import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/trail_entity.dart';

/// Trail Repository interface - Domain layer contract
abstract class TrailRepository {
  /// Get all trails with optional filters
  Future<Either<Failure, List<TrailEntity>>> getTrails({
    TrailFilterParams? filters,
  });

  /// Get a single trail by ID
  Future<Either<Failure, TrailEntity>> getTrailById(String id);

  /// Search trails by query
  Future<Either<Failure, List<TrailEntity>>> searchTrails(String query);

  /// Get trails by difficulty
  Future<Either<Failure, List<TrailEntity>>> getTrailsByDifficulty(
    TrailDifficulty difficulty,
  );

  /// Get trails by region
  Future<Either<Failure, List<TrailEntity>>> getTrailsByRegion(String region);

  /// Get popular trails (highly rated)
  Future<Either<Failure, List<TrailEntity>>> getPopularTrails({int limit = 10});

  /// Get featured trails for home screen
  Future<Either<Failure, List<TrailEntity>>> getFeaturedTrails({int limit = 5});

  /// Join a trail with a specific date
  Future<Either<Failure, void>> joinTrailWithDate({
    required String trailId,
    required DateTime startDate,
  });

  /// Complete a joined trail
  Future<Either<Failure, void>> completeTrail(String joinedTrailId);

  /// Cancel a joined trail
  Future<Either<Failure, void>> cancelJoinedTrail(String joinedTrailId);

  /// Rate a trail
  Future<Either<Failure, void>> rateTrail({
    required String trailId,
    required int rating,
    String? review,
  });

  /// Get cached trails (for offline access)
  Future<Either<Failure, List<TrailEntity>>> getCachedTrails();

  /// Cache trails locally
  Future<Either<Failure, void>> cacheTrails(List<TrailEntity> trails);

  /// Clear cached trails
  Future<Either<Failure, void>> clearCachedTrails();
}
