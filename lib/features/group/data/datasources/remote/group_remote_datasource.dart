import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/group_model.dart';
import '../../../domain/entities/group_entity.dart';

/// Remote data source for group operations
abstract class GroupRemoteDataSource {
  /// Get all groups with optional filters
  Future<List<GroupModel>> getGroups({Map<String, String>? queryParams});

  /// Get a single group by ID
  Future<GroupModel> getGroupById(String id);

  /// Get groups the current user is a member of
  Future<List<GroupModel>> getMyGroups();

  /// Create a new group
  Future<GroupModel> createGroup({
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

  /// Request to join a group
  Future<void> requestJoinGroup({
    required String groupId,
    String? message,
  });

  /// Approve a join request
  Future<void> approveJoinRequest({
    required String groupId,
    required String requestId,
  });

  /// Deny a join request
  Future<void> denyJoinRequest({
    required String groupId,
    required String requestId,
  });

  /// Get pending join requests
  Future<List<JoinRequestModel>> getPendingRequests();

  /// Leave a group
  Future<void> leaveGroup(String groupId);

  /// Add a comment to a group
  Future<GroupCommentModel> addComment({
    required String groupId,
    required String content,
  });

  /// Delete a comment
  Future<void> deleteComment({
    required String groupId,
    required String commentId,
  });

  /// Update a group
  Future<GroupModel> updateGroup({
    required String groupId,
    String? title,
    String? description,
    String? location,
    List<String>? existingPhotos,
    List<String>? newPhotoPaths,
  });

  /// Delete a group
  Future<void> deleteGroup(String groupId);
}

/// Implementation of GroupRemoteDataSource
class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final ApiClient apiClient;

  GroupRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<GroupModel>> getGroups({Map<String, String>? queryParams}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.groups,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final groupsData = data['data'] as List? ?? [];
        return groupsData
            .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to fetch groups',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching groups: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> getGroupById(String id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.groupById(id),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        return GroupModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw NotFoundException(message: 'Group not found');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching group: ${e.toString()}');
    }
  }

  @override
  Future<List<GroupModel>> getMyGroups() async {
    try {
      final response = await apiClient.get(
        ApiConstants.groups,
        queryParameters: {'myGroups': 'true'},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final groupsData = data['data'] as List? ?? [];
        return groupsData
            .map((json) => GroupModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to fetch your groups',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching your groups: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> createGroup({
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
    try {
      // Use FormData for multipart upload when photos are present
      final formData = FormData.fromMap({
        // Backend expects title/trail/date/leader fields
        'title': name,
        if (description != null) 'description': description,
        'trail': trailId,
        'date': startDate.toIso8601String(),
        'leader': leaderId,
        // Backend expects maxSize instead of maxParticipants
        'maxSize': maxParticipants,
        // Backend expects meetingPoint.description (String), not full object
        if (meetingPoint != null)
          'meetingPoint': jsonEncode({
            'description': meetingPoint.name,
          }),
      });

      // Add photos if any
      if (photos.isNotEmpty) {
        for (int i = 0; i < photos.length; i++) {
          formData.files.add(
            MapEntry(
              'photo',
              await MultipartFile.fromFile(
                photos[i].path,
                filename: photos[i].path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await apiClient.post(
        ApiConstants.createGroup,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        return GroupModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to create group',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error creating group: ${e.toString()}');
    }
  }

  @override
  Future<void> requestJoinGroup({
    required String groupId,
    String? message,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.requestJoinGroup(groupId),
        data: {
          if (message != null) 'message': message,
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to request joining group',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error requesting to join group: ${e.toString()}');
    }
  }

  @override
  Future<void> approveJoinRequest({
    required String groupId,
    required String requestId,
  }) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.approveJoinRequest(groupId, requestId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to approve join request',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error approving join request: ${e.toString()}');
    }
  }

  @override
  Future<void> denyJoinRequest({
    required String groupId,
    required String requestId,
  }) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.denyJoinRequest(groupId, requestId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to deny join request',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error denying join request: ${e.toString()}');
    }
  }

  @override
  Future<List<JoinRequestModel>> getPendingRequests() async {
    try {
      final response = await apiClient.get(
        ApiConstants.pendingRequests,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final requestsData = data['data'] as List? ?? [];
        return requestsData
            .map((json) => JoinRequestModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to fetch pending requests',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching pending requests: ${e.toString()}');
    }
  }

  @override
  Future<void> leaveGroup(String groupId) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.groupById(groupId)}/leave',
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to leave group',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error leaving group: ${e.toString()}');
    }
  }

  @override
  Future<GroupCommentModel> addComment({
    required String groupId,
    required String content,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.groupById(groupId)}/comments',
        data: {'content': content},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        return GroupCommentModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to add comment',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error adding comment: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteComment({
    required String groupId,
    required String commentId,
  }) async {
    try {
      final response = await apiClient.delete(
        '${ApiConstants.groupById(groupId)}/comments/$commentId',
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to delete comment',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error deleting comment: ${e.toString()}');
    }
  }

  @override
  Future<GroupModel> updateGroup({
    required String groupId,
    String? title,
    String? description,
    String? location,
    List<String>? existingPhotos,
    List<String>? newPhotoPaths,
  }) async {
    try {
      // Build FormData with new photos if any
      if (newPhotoPaths != null && newPhotoPaths.isNotEmpty) {
        final formData = FormData.fromMap({
          'title': title,
          if (description != null) 'description': description,
          if (location != null) 'location': location,
          if (existingPhotos != null)
            'existingPhotos': jsonEncode(existingPhotos),
          'photo': [
            for (final path in newPhotoPaths)
              await MultipartFile.fromFile(path),
          ],
        });

        final response = await apiClient.put(
          ApiConstants.groupById(groupId),
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );

        final data = response.data as Map<String, dynamic>;

        if (data['success'] != true) {
          throw ServerException(
            message: data['message'] ?? 'Failed to update group',
          );
        }

        return GroupModel.fromJson(data['data']);
      } else {
        // No new photos - send as JSON
        final response = await apiClient.put(
          ApiConstants.groupById(groupId),
          data: {
            'title': title,
            'description': description,
            'location': location,
            'existingPhotos': existingPhotos != null
                ? jsonEncode(existingPhotos)
                : null,
          },
        );

        final data = response.data as Map<String, dynamic>;

        if (data['success'] != true) {
          throw ServerException(
            message: data['message'] ?? 'Failed to update group',
          );
        }

        return GroupModel.fromJson(data['data']);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error updating group: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.groupById(groupId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to delete group',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error deleting group: ${e.toString()}');
    }
  }
}
