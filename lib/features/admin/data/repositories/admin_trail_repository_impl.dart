import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_trail_entity.dart';
import '../../domain/repositories/admin_trail_repository.dart';
import '../datasources/admin_trail_remote_datasource.dart';

/// Implementation of AdminTrailRepository
class AdminTrailRepositoryImpl implements AdminTrailRepository {
  final AdminTrailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminTrailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TrailListResult>> getAllTrails({
    int page = 1,
    int limit = 10,
    String? search,
    double? maxDistance,
    double? maxElevation,
    String? difficulty,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final result = await remoteDataSource.getAllTrails(
        page: page,
        limit: limit,
        search: search,
        maxDistance: maxDistance,
        maxElevation: maxElevation,
        difficulty: difficulty,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminTrailEntity>> getTrailById(String trailId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final trail = await remoteDataSource.getTrailById(trailId);
      return Right(trail.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    if (name.isEmpty || location.isEmpty || description.isEmpty) {
      return const Left(ValidationFailure(message: 'All fields are required'));
    }

    try {
      final trail = await remoteDataSource.createTrail(
        name: name,
        description: description,
        location: location,
        distance: distance,
        elevation: elevation,
        difficulty: difficulty,
        durationMin: durationMin,
        durationMax: durationMax,
        imagePaths: imagePaths,
      );
      return Right(trail.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
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
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final trail = await remoteDataSource.updateTrail(
        trailId: trailId,
        name: name,
        description: description,
        location: location,
        distance: distance,
        elevation: elevation,
        difficulty: difficulty,
        durationMin: durationMin,
        durationMax: durationMax,
        imagePaths: imagePaths,
      );
      return Right(trail.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTrail(String trailId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.deleteTrail(trailId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
