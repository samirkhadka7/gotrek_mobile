import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/checklist_entity.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../datasources/checklist_local_datasource.dart';
import '../datasources/checklist_remote_datasource.dart';
import '../models/checklist_model.dart';

/// Implementation of ChecklistRepository
class ChecklistRepositoryImpl implements ChecklistRepository {
  final ChecklistRemoteDataSource remoteDataSource;
  final ChecklistLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ChecklistRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, GeneratedChecklist>> generateChecklist(
    ChecklistConfig config,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.generateChecklist(config);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserChecklist?>> getMyChecklist() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyChecklist();
        if (result != null) {
          // Cache the checklist for offline access
          await localDataSource.cacheChecklist(result);
        }
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Return cached data when offline
      try {
        final cachedChecklist = await localDataSource.getCachedChecklist();
        return Right(cachedChecklist);
      } catch (e) {
        return const Left(CacheFailure(message: 'Failed to load cached checklist'));
      }
    }
  }

  @override
  Future<Either<Failure, UserChecklist>> saveChecklist({
    required List<ChecklistItem> items,
    required ChecklistConfig config,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.saveChecklist(
          items: items,
          config: config,
        );
        // Cache the updated checklist
        await localDataSource.cacheChecklist(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Save locally when offline
      try {
        final localChecklist = UserChecklistModel(
          modelItems: items
              .map((item) => ChecklistItemModel.fromEntity(item))
              .toList(),
          modelConfig: ChecklistConfigModel.fromEntity(config),
          modelUpdatedAt: DateTime.now(),
        );
        await localDataSource.cacheChecklist(localChecklist);
        return Right(localChecklist);
      } catch (e) {
        return const Left(CacheFailure(message: 'Failed to save checklist locally'));
      }
    }
  }

  @override
  Future<Either<Failure, UserChecklist>> updateChecklistItem({
    required String itemId,
    required bool isChecked,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.updateChecklistItem(
          itemId: itemId,
          isChecked: isChecked,
        );
        // Cache the updated checklist
        await localDataSource.cacheChecklist(result);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Update locally when offline
      try {
        final cachedChecklist = await localDataSource.getCachedChecklist();
        if (cachedChecklist == null) {
          return const Left(CacheFailure(message: 'No checklist found'));
        }

        final updatedItems = cachedChecklist.modelItems.map((item) {
          if (item.id == itemId) {
            return item.copyWithModel(isChecked: isChecked);
          }
          return item;
        }).toList();

        final updatedChecklist = UserChecklistModel(
          modelItems: updatedItems,
          modelConfig: cachedChecklist.modelConfig,
          modelUpdatedAt: DateTime.now(),
        );

        await localDataSource.cacheChecklist(updatedChecklist);
        return Right(updatedChecklist);
      } catch (e) {
        return const Left(CacheFailure(message: 'Failed to update checklist locally'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> clearChecklist() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.clearChecklist();
        await localDataSource.clearCache();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on UnauthorizedException catch (e) {
        return Left(AuthFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      try {
        await localDataSource.clearCache();
        return const Right(null);
      } catch (e) {
        return const Left(CacheFailure(message: 'Failed to clear checklist'));
      }
    }
  }
}
