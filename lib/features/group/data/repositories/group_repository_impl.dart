import 'package:dartz/dartz.dart';
import 'dart:io';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/local/group_local_datasource.dart';
import '../datasources/remote/group_remote_datasource.dart';

/// Implementation of GroupRepository with offline-first approach
class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;
  final GroupLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GroupRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GroupEntity>>> getGroups({
    GroupFilterParams? filters,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final groups = await remoteDataSource.getGroups(
          queryParams: filters?.toQueryParams(),
        );
        // Cache groups for offline access
        await localDataSource.cacheGroups(groups);
        return Right(groups);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Offline: return cached groups
      try {
        final cachedGroups = await localDataSource.getCachedGroups();
        if (cachedGroups.isNotEmpty) {
          return Right(cachedGroups);
        }
        return const Left(NetworkFailure());
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> getGroupById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final group = await remoteDataSource.getGroupById(id);
        // Cache the group for offline access
        await localDataSource.cacheGroup(group);
        return Right(group);
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(message: e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Offline: try to get from cache
      try {
        final cachedGroup = await localDataSource.getCachedGroupById(id);
        if (cachedGroup != null) {
          return Right(cachedGroup);
        }
        return const Left(NetworkFailure());
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getMyGroups() async {
    if (await networkInfo.isConnected) {
      try {
        final groups = await remoteDataSource.getMyGroups();
        return Right(groups);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> createGroup({
    required String name,
    String? description,
    required String trailId,
    required DateTime startDate,
    DateTime? endDate,
    required int maxParticipants,
    MeetingPoint? meetingPoint,
    required String leaderId,
    List<File> photos = const [],
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final group = await remoteDataSource.createGroup(
        name: name,
        description: description,
        trailId: trailId,
        startDate: startDate,
        endDate: endDate,
        maxParticipants: maxParticipants,
        meetingPoint: meetingPoint,
        leaderId: leaderId,
        photos: photos,
      );
      // Cache the new group
      await localDataSource.cacheGroup(group);
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupEntity>> updateGroup({
    required String groupId,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    MeetingPoint? meetingPoint,
    GroupStatus? status,
    String? title,
    String? location,
    List<String>? existingPhotos,
    List<String>? newPhotoPaths,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      // Call remote datasource to update the group
      final updatedName = name ?? title;
      final group = await remoteDataSource.updateGroup(
        groupId: groupId,
        title: updatedName,
        description: description,
        location: location,
        existingPhotos: existingPhotos,
        newPhotoPaths: newPhotoPaths,
      );
      await localDataSource.cacheGroup(group);
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestJoinGroup({
    required String groupId,
    String? message,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.requestJoinGroup(
        groupId: groupId,
        message: message,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveJoinRequest({
    required String groupId,
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.approveJoinRequest(
        groupId: groupId,
        requestId: requestId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> denyJoinRequest({
    required String groupId,
    required String requestId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.denyJoinRequest(
        groupId: groupId,
        requestId: requestId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> leaveGroup(String groupId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.leaveGroup(groupId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JoinRequest>>> getPendingRequests() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final requests = await remoteDataSource.getPendingRequests();
      return Right(requests);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GroupComment>> addComment({
    required String groupId,
    required String content,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final comment = await remoteDataSource.addComment(
        groupId: groupId,
        content: content,
      );
      return Right(comment);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteComment({
    required String groupId,
    required String commentId,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteComment(
        groupId: groupId,
        commentId: commentId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGroup(String groupId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.deleteGroup(groupId);
      // Remove from cache
      await localDataSource.removeCachedGroup(groupId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GroupEntity>>> getCachedGroups() async {
    try {
      final groups = await localDataSource.getCachedGroups();
      return Right(groups);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
