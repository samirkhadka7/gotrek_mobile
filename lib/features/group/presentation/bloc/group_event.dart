import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../domain/entities/group_entity.dart';

/// Base class for group events
abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object?> get props => [];
}

/// Load all groups
class LoadGroupsEvent extends GroupEvent {
  final GroupFilterParams? filters;

  const LoadGroupsEvent({this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Refresh groups
class RefreshGroupsEvent extends GroupEvent {
  const RefreshGroupsEvent();
}

/// Load a single group by ID
class LoadGroupByIdEvent extends GroupEvent {
  final String groupId;

  const LoadGroupByIdEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Load group details (alias for consistency)
class LoadGroupDetailsEvent extends GroupEvent {
  final String groupId;

  const LoadGroupDetailsEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Manage join request (approve or deny)
class ManageJoinRequestEvent extends GroupEvent {
  final String groupId;
  final String requestId;
  final bool approve;

  const ManageJoinRequestEvent({
    required this.groupId,
    required this.requestId,
    required this.approve,
  });

  @override
  List<Object?> get props => [groupId, requestId, approve];
}

/// Load user's groups
class LoadMyGroupsEvent extends GroupEvent {
  const LoadMyGroupsEvent();
}

/// Create a new group
class CreateGroupEvent extends GroupEvent {
  final String name;
  final String? description;
  final String trailId;
  final DateTime startDate;
  final DateTime? endDate;
  final int maxParticipants;
  final MeetingPoint? meetingPoint;
  final String leaderId;
  final List<File> photos;

  const CreateGroupEvent({
    required this.name,
    this.description,
    required this.trailId,
    required this.startDate,
    this.endDate,
    required this.maxParticipants,
    this.meetingPoint,
    required this.leaderId,
    this.photos = const [],
  });

  @override
  List<Object?> get props => [
        name,
        description,
        trailId,
        startDate,
        endDate,
        maxParticipants,
        meetingPoint,
      leaderId,
        photos,
      ];
}

/// Request to join a group
class RequestJoinGroupEvent extends GroupEvent {
  final String groupId;
  final String? message;

  const RequestJoinGroupEvent({
    required this.groupId,
    this.message,
  });

  @override
  List<Object?> get props => [groupId, message];
}

/// Approve a join request
class ApproveJoinRequestEvent extends GroupEvent {
  final String groupId;
  final String requestId;

  const ApproveJoinRequestEvent({
    required this.groupId,
    required this.requestId,
  });

  @override
  List<Object?> get props => [groupId, requestId];
}

/// Deny a join request
class DenyJoinRequestEvent extends GroupEvent {
  final String groupId;
  final String requestId;

  const DenyJoinRequestEvent({
    required this.groupId,
    required this.requestId,
  });

  @override
  List<Object?> get props => [groupId, requestId];
}

/// Leave a group
class LeaveGroupEvent extends GroupEvent {
  final String groupId;

  const LeaveGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Load pending join requests
class LoadPendingRequestsEvent extends GroupEvent {
  const LoadPendingRequestsEvent();
}

/// Add a comment to a group
class AddCommentEvent extends GroupEvent {
  final String groupId;
  final String content;

  const AddCommentEvent({
    required this.groupId,
    required this.content,
  });

  @override
  List<Object?> get props => [groupId, content];
}

/// Delete a comment from a group
class DeleteCommentEvent extends GroupEvent {
  final String groupId;
  final String commentId;

  const DeleteCommentEvent({
    required this.groupId,
    required this.commentId,
  });

  @override
  List<Object?> get props => [groupId, commentId];
}

/// Apply filters to groups
class ApplyGroupFiltersEvent extends GroupEvent {
  final GroupFilterParams filters;

  const ApplyGroupFiltersEvent({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Clear filters
class ClearGroupFiltersEvent extends GroupEvent {
  const ClearGroupFiltersEvent();
}

/// Update a group
class UpdateGroupEvent extends GroupEvent {
  final String groupId;
  final String? title;
  final String? description;
  final DateTime? date;
  final String? location;
  final List<String>? existingPhotos;
  final List<String>? newPhotoPaths;

  const UpdateGroupEvent({
    required this.groupId,
    this.title,
    this.description,
    this.date,
    this.location,
    this.existingPhotos,
    this.newPhotoPaths,
  });

  @override
  List<Object?> get props => [
        groupId,
        title,
        description,
        date,
        location,
        existingPhotos,
        newPhotoPaths,
      ];
}

/// Delete a group
class DeleteGroupEvent extends GroupEvent {
  final String groupId;

  const DeleteGroupEvent({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}
