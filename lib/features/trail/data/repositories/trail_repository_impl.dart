import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/trail_entity.dart';
import '../../domain/repositories/trail_repository.dart';
import '../datasources/local/trail_local_datasource.dart';
import '../datasources/remote/trail_remote_datasource.dart';
import '../models/trail_model.dart';

/// Implementation of TrailRepository
class TrailRepositoryImpl implements TrailRepository {
  final TrailRemoteDataSource remoteDataSource;
  final TrailLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TrailRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TrailEntity>>> getTrails({
    TrailFilterParams? filters,
  }) async {
    // Check if we have valid cache
    final hasValidCache = await localDataSource.isCacheValid();

    if (await networkInfo.isConnected) {
      try {
        final trails = await remoteDataSource.getTrails(
          queryParams: filters?.toQueryParams(),
        );

        // Cache the trails for offline access
        await localDataSource.cacheTrails(trails);

        return Right(trails.map((t) => t.toEntity()).toList());
      } on ServerException catch (e) {
        // If server fails but we have cache, return cached data
        if (hasValidCache) {
          final cachedTrails = await localDataSource.getCachedTrails();
          return Right(cachedTrails.map((t) => t.toEntity()).toList());
        }
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        if (hasValidCache) {
          final cachedTrails = await localDataSource.getCachedTrails();
          return Right(cachedTrails.map((t) => t.toEntity()).toList());
        }
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      // Offline - try to get from cache
      try {
        final cachedTrails = await localDataSource.getCachedTrails();
        if (cachedTrails.isNotEmpty) {
          return Right(cachedTrails.map((t) => t.toEntity()).toList());
        }
        return const Left(NetworkFailure(message: 'No internet connection and no cached data'));
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, TrailEntity>> getTrailById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final trail = await remoteDataSource.getTrailById(id);
        // Cache the single trail
        await localDataSource.cacheTrail(trail);
        return Right(trail.toEntity());
      } on NotFoundException catch (e) {
        // Try from cache
        final cachedTrail = await localDataSource.getCachedTrailById(id);
        if (cachedTrail != null) {
          return Right(cachedTrail.toEntity());
        }
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        // Try from cache
        final cachedTrail = await localDataSource.getCachedTrailById(id);
        if (cachedTrail != null) {
          return Right(cachedTrail.toEntity());
        }
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      // Offline - try from cache
      try {
        final cachedTrail = await localDataSource.getCachedTrailById(id);
        if (cachedTrail != null) {
          return Right(cachedTrail.toEntity());
        }
        return const Left(NetworkFailure(message: 'No internet connection and trail not cached'));
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> searchTrails(String query) async {
    if (!await networkInfo.isConnected) {
      // Offline search through cache
      try {
        final cachedTrails = await localDataSource.getCachedTrails();
        final filteredTrails = cachedTrails.where((t) {
          final lowerQuery = query.toLowerCase();
          return t.name.toLowerCase().contains(lowerQuery) ||
              t.location.toLowerCase().contains(lowerQuery) ||
              (t.region?.toLowerCase().contains(lowerQuery) ?? false) ||
              (t.description?.toLowerCase().contains(lowerQuery) ?? false);
        }).toList();
        return Right(filteredTrails.map((t) => t.toEntity()).toList());
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }

    try {
      final trails = await remoteDataSource.searchTrails(query);
      return Right(trails.map((t) => t.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> getTrailsByDifficulty(
    TrailDifficulty difficulty,
  ) async {
    final filters = TrailFilterParams(difficulty: difficulty);
    return getTrails(filters: filters);
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> getTrailsByRegion(
    String region,
  ) async {
    final filters = TrailFilterParams(region: region);
    return getTrails(filters: filters);
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> getPopularTrails({
    int limit = 10,
  }) async {
    final filters = TrailFilterParams(
      sortBy: TrailSortBy.rating,
      ascending: false,
      limit: limit,
    );
    return getTrails(filters: filters);
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> getFeaturedTrails({
    int limit = 5,
  }) async {
    // Featured trails are popular trails with good images
    return getPopularTrails(limit: limit);
  }

  @override
  Future<Either<Failure, void>> joinTrailWithDate({
    required String trailId,
    required DateTime startDate,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.joinTrailWithDate(
        trailId: trailId,
        startDate: startDate,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeTrail(String joinedTrailId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.completeTrail(joinedTrailId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelJoinedTrail(String joinedTrailId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.cancelJoinedTrail(joinedTrailId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rateTrail({
    required String trailId,
    required int rating,
    String? review,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.rateTrail(
        trailId: trailId,
        rating: rating,
        review: review,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrailEntity>>> getCachedTrails() async {
    try {
      final cachedTrails = await localDataSource.getCachedTrails();
      return Right(cachedTrails.map((t) => t.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cacheTrails(List<TrailEntity> trails) async {
    try {
      final models = trails.map((t) => TrailModel.fromEntity(t)).toList();
      await localDataSource.cacheTrails(models);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCachedTrails() async {
    try {
      await localDataSource.clearCachedTrails();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
