import 'package:equatable/equatable.dart';

import '../../domain/entities/group_entity.dart';

/// Base class for group states
abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class GroupInitial extends GroupState {
  const GroupInitial();
}

/// Loading state for groups list
class GroupsLoading extends GroupState {
  const GroupsLoading();
}

/// Groups loaded successfully
class GroupsLoaded extends GroupState {
  final List<GroupEntity> groups;
  final GroupFilterParams? activeFilters;
  final bool isFromCache;

  const GroupsLoaded({
    required this.groups,
    this.activeFilters,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [groups, activeFilters, isFromCache];
}

/// Loading state for single group
class GroupLoading extends GroupState {
  const GroupLoading();
}

/// Single group loaded successfully
class GroupLoaded extends GroupState {
  final GroupEntity group;

  const GroupLoaded({required this.group});

  @override
  List<Object?> get props => [group];
}

/// Loading state for group details
class GroupDetailsLoading extends GroupState {
  const GroupDetailsLoading();
}

/// Group details loaded successfully
class GroupDetailsLoaded extends GroupState {
  final GroupEntity group;

  const GroupDetailsLoaded({required this.group});

  @override
  List<Object?> get props => [group];
}

/// Operation success (generic for actions)
class GroupOperationSuccess extends GroupState {
  final String message;
  final String? groupId;

  const GroupOperationSuccess({
    required this.message,
    this.groupId,
  });

  @override
  List<Object?> get props => [message, groupId];
}

/// Loading state for my groups
class MyGroupsLoading extends GroupState {
  const MyGroupsLoading();
}

/// My groups loaded successfully
class MyGroupsLoaded extends GroupState {
  final List<GroupEntity> groups;

  const MyGroupsLoaded({required this.groups});

  @override
  List<Object?> get props => [groups];
}

/// Error state
class GroupError extends GroupState {
  final String message;
  final GroupErrorType type;

  const GroupError({
    required this.message,
    this.type = GroupErrorType.general,
  });

  @override
  List<Object?> get props => [message, type];
}

/// Error types for group operations
enum GroupErrorType {
  general,
  network,
  notFound,
  unauthorized,
  validation,
}

/// Group creation in progress
class GroupCreating extends GroupState {
  const GroupCreating();
}

/// Group created successfully
class GroupCreated extends GroupState {
  final GroupEntity group;

  const GroupCreated({required this.group});

  @override
  List<Object?> get props => [group];
}

/// Group updated successfully
class GroupUpdated extends GroupState {
  final GroupEntity group;

  const GroupUpdated({required this.group});

  @override
  List<Object?> get props => [group];
}

/// Join request submitted
class JoinRequestSubmitted extends GroupState {
  final String groupId;

  const JoinRequestSubmitted({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Join request in progress
class JoinRequestInProgress extends GroupState {
  const JoinRequestInProgress();
}

/// Join request managed (approved/denied)
class JoinRequestManaged extends GroupState {
  final String requestId;
  final bool approved;

  const JoinRequestManaged({
    required this.requestId,
    required this.approved,
  });

  @override
  List<Object?> get props => [requestId, approved];
}

/// Left group successfully
class GroupLeft extends GroupState {
  final String groupId;

  const GroupLeft({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Pending requests loading
class PendingRequestsLoading extends GroupState {
  const PendingRequestsLoading();
}

/// Pending requests loaded
class PendingRequestsLoaded extends GroupState {
  final List<JoinRequest> requests;

  const PendingRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

/// Comment added successfully
class CommentAdded extends GroupState {
  final GroupComment comment;
  final String groupId;

  const CommentAdded({
    required this.comment,
    required this.groupId,
  });

  @override
  List<Object?> get props => [comment, groupId];
}

/// Comment deleted successfully
class CommentDeleted extends GroupState {
  final String commentId;
  final String groupId;

  const CommentDeleted({
    required this.commentId,
    required this.groupId,
  });

  @override
  List<Object?> get props => [commentId, groupId];
}

/// Group deleted successfully
class GroupDeleted extends GroupState {
  final String groupId;

  const GroupDeleted({required this.groupId});

  @override
  List<Object?> get props => [groupId];
}

/// Action in progress (generic loading for actions)
class GroupActionInProgress extends GroupState {
  final String action;

  const GroupActionInProgress({required this.action});

  @override
  List<Object?> get props => [action];
}
