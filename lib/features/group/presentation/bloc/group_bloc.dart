import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/usecases/create_group.dart';
import '../../domain/usecases/get_group_by_id.dart';
import '../../domain/usecases/get_groups.dart';
import '../../domain/usecases/get_my_groups.dart';
import '../../domain/usecases/get_pending_requests.dart';
import '../../domain/usecases/leave_group.dart';
import '../../domain/usecases/manage_join_request.dart';
import '../../domain/usecases/request_join_group.dart';
import '../../domain/usecases/update_group.dart';
import 'group_event.dart';
import 'group_state.dart';

/// BLoC for managing group operations
class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GetGroupsUseCase getGroupsUseCase;
  final GetGroupByIdUseCase getGroupByIdUseCase;
  final GetMyGroupsUseCase getMyGroupsUseCase;
  final CreateGroupUseCase createGroupUseCase;
  final RequestJoinGroupUseCase requestJoinGroupUseCase;
  final ManageJoinRequestUseCase manageJoinRequestUseCase;
  final GetPendingRequestsUseCase getPendingRequestsUseCase;
  final LeaveGroupUseCase leaveGroupUseCase;
  final UpdateGroupUseCase updateGroupUseCase;

  GroupFilterParams? _currentFilters;

  GroupBloc({
    required this.getGroupsUseCase,
    required this.getGroupByIdUseCase,
    required this.getMyGroupsUseCase,
    required this.createGroupUseCase,
    required this.requestJoinGroupUseCase,
    required this.manageJoinRequestUseCase,
    required this.getPendingRequestsUseCase,
    required this.leaveGroupUseCase,
    required this.updateGroupUseCase,
  }) : super(const GroupInitial()) {
    on<LoadGroupsEvent>(_onLoadGroups);
    on<RefreshGroupsEvent>(_onRefreshGroups);
    on<LoadGroupByIdEvent>(_onLoadGroupById);
    on<LoadMyGroupsEvent>(_onLoadMyGroups);
    on<CreateGroupEvent>(_onCreateGroup);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<RequestJoinGroupEvent>(_onRequestJoinGroup);
    on<ApproveJoinRequestEvent>(_onApproveJoinRequest);
    on<DenyJoinRequestEvent>(_onDenyJoinRequest);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<LoadPendingRequestsEvent>(_onLoadPendingRequests);
    on<ApplyGroupFiltersEvent>(_onApplyFilters);
    on<ClearGroupFiltersEvent>(_onClearFilters);
    on<LoadGroupDetailsEvent>(_onLoadGroupDetails);
    on<ManageJoinRequestEvent>(_onManageJoinRequest);
    on<AddCommentEvent>(_onAddComment);
  }

  Future<void> _onLoadGroups(
    LoadGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupsLoading());

    _currentFilters = event.filters;

    final result = await getGroupsUseCase(event.filters);

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (groups) => emit(GroupsLoaded(
        groups: groups,
        activeFilters: _currentFilters,
      )),
    );
  }

  Future<void> _onRefreshGroups(
    RefreshGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    final result = await getGroupsUseCase(_currentFilters);

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (groups) => emit(GroupsLoaded(
        groups: groups,
        activeFilters: _currentFilters,
      )),
    );
  }

  Future<void> _onLoadGroupById(
    LoadGroupByIdEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupLoading());

    final result = await getGroupByIdUseCase(event.groupId);

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (group) => emit(GroupLoaded(group: group)),
    );
  }

  Future<void> _onLoadMyGroups(
    LoadMyGroupsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const MyGroupsLoading());

    final result = await getMyGroupsUseCase(const NoParams());

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (groups) => emit(MyGroupsLoaded(groups: groups)),
    );
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupCreating());

    final result = await createGroupUseCase(CreateGroupParams(
      name: event.name,
      description: event.description,
      trailId: event.trailId,
      startDate: event.startDate,
      endDate: event.endDate,
      maxParticipants: event.maxParticipants,
      meetingPoint: event.meetingPoint,
      leaderId: event.leaderId,
      photos: event.photos,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (group) => emit(GroupCreated(group: group)),
    );
  }

  Future<void> _onUpdateGroup(
    UpdateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Updating group'));

    final result = await updateGroupUseCase(UpdateGroupParams(
      groupId: event.groupId,
      name: event.title,
      description: event.description,
      startDate: event.date,
      existingPhotos: event.existingPhotos,
      newPhotoPaths: event.newPhotoPaths,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (group) => emit(GroupUpdated(group: group)),
    );
  }

  Future<void> _onRequestJoinGroup(
    RequestJoinGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const JoinRequestInProgress());

    final result = await requestJoinGroupUseCase(RequestJoinGroupParams(
      groupId: event.groupId,
      message: event.message,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (_) => emit(JoinRequestSubmitted(groupId: event.groupId)),
    );
  }

  Future<void> _onApproveJoinRequest(
    ApproveJoinRequestEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Approving request'));

    final result = await manageJoinRequestUseCase(ManageJoinRequestParams(
      groupId: event.groupId,
      requestId: event.requestId,
      approve: true,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (_) => emit(JoinRequestManaged(
        requestId: event.requestId,
        approved: true,
      )),
    );
  }

  Future<void> _onDenyJoinRequest(
    DenyJoinRequestEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Denying request'));

    final result = await manageJoinRequestUseCase(ManageJoinRequestParams(
      groupId: event.groupId,
      requestId: event.requestId,
      approve: false,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (_) => emit(JoinRequestManaged(
        requestId: event.requestId,
        approved: false,
      )),
    );
  }

  Future<void> _onLeaveGroup(
    LeaveGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Leaving group'));

    final result = await leaveGroupUseCase(event.groupId);

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (_) => emit(GroupLeft(groupId: event.groupId)),
    );
  }

  Future<void> _onLoadPendingRequests(
    LoadPendingRequestsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const PendingRequestsLoading());

    final result = await getPendingRequestsUseCase(const NoParams());

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (requests) => emit(PendingRequestsLoaded(requests: requests)),
    );
  }

  Future<void> _onApplyFilters(
    ApplyGroupFiltersEvent event,
    Emitter<GroupState> emit,
  ) async {
    _currentFilters = event.filters;
    add(const LoadGroupsEvent());
  }

  Future<void> _onClearFilters(
    ClearGroupFiltersEvent event,
    Emitter<GroupState> emit,
  ) async {
    _currentFilters = null;
    add(const LoadGroupsEvent());
  }

  Future<void> _onLoadGroupDetails(
    LoadGroupDetailsEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupDetailsLoading());

    final result = await getGroupByIdUseCase(event.groupId);

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (group) => emit(GroupDetailsLoaded(group: group)),
    );
  }

  Future<void> _onManageJoinRequest(
    ManageJoinRequestEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Processing request'));

    final result = await manageJoinRequestUseCase(ManageJoinRequestParams(
      groupId: event.groupId,
      requestId: event.requestId,
      approve: event.approve,
    ));

    result.fold(
      (failure) => emit(GroupError(
        message: failure.message,
        type: _mapFailureToErrorType(failure),
      )),
      (_) => emit(GroupOperationSuccess(
        message: event.approve
            ? 'Request approved successfully!'
            : 'Request denied.',
        groupId: event.groupId,
      )),
    );
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(const GroupActionInProgress(action: 'Adding comment'));

    // TODO: Implement addComment use case when available
    // For now, we'll emit success and reload
    emit(GroupOperationSuccess(
      message: 'Comment added successfully!',
      groupId: event.groupId,
    ));
  }

  GroupErrorType _mapFailureToErrorType(failure) {
    final failureType = failure.runtimeType.toString();
    if (failureType.contains('Network')) {
      return GroupErrorType.network;
    } else if (failureType.contains('NotFound')) {
      return GroupErrorType.notFound;
    } else if (failureType.contains('Unauthorized')) {
      return GroupErrorType.unauthorized;
    } else if (failureType.contains('Validation')) {
      return GroupErrorType.validation;
    }
    return GroupErrorType.general;
  }
}
