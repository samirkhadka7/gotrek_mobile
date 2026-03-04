import 'package:dartz/dartz.dart';
import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../entities/group_entity.dart';

/// Abstract repository for group operations
abstract class GroupRepository {
  /// Get all groups with optional filters
  Future<Either<Failure, List<GroupEntity>>> getGroups({
    GroupFilterParams? filters,
  });

  /// Get a single group by ID
  Future<Either<Failure, GroupEntity>> getGroupById(String id);

  /// Get groups the current user is a member of
  Future<Either<Failure, List<GroupEntity>>> getMyGroups();

  /// Create a new group
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
  });

  /// Update an existing group
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
  });

  /// Request to join a group
  Future<Either<Failure, void>> requestJoinGroup({
    required String groupId,
    String? message,
  });

  /// Approve a join request (leader only)
  Future<Either<Failure, void>> approveJoinRequest({
    required String groupId,
    required String requestId,
  });

  /// Deny a join request (leader only)
  Future<Either<Failure, void>> denyJoinRequest({
    required String groupId,
    required String requestId,
  });

  /// Leave a group
  Future<Either<Failure, void>> leaveGroup(String groupId);

  /// Get pending join requests for leader
  Future<Either<Failure, List<JoinRequest>>> getPendingRequests();

  /// Add a comment to a group
  Future<Either<Failure, GroupComment>> addComment({
    required String groupId,
    required String content,
  });

  /// Delete a comment from a group
  Future<Either<Failure, void>> deleteComment({
    required String groupId,
    required String commentId,
  });

  /// Delete a group (leader only)
  Future<Either<Failure, void>> deleteGroup(String groupId);

  /// Get cached groups for offline access
  Future<Either<Failure, List<GroupEntity>>> getCachedGroups();

  /// Clear cached groups
  Future<Either<Failure, void>> clearCache();
}
