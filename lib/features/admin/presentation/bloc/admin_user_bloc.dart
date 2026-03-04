import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_users.dart';
import '../../domain/usecases/update_user_role.dart';
import '../../domain/usecases/delete_user.dart';
import 'admin_user_event.dart';
import 'admin_user_state.dart';

/// BLoC for Admin User Management
class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  final GetAllUsersUseCase getAllUsersUseCase;
  final UpdateUserRoleUseCase updateUserRoleUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminUserBloc({
    required this.getAllUsersUseCase,
    required this.updateUserRoleUseCase,
    required this.deleteUserUseCase,
  }) : super(AdminUserInitial()) {
    on<LoadAllUsersEvent>(_onLoadAllUsers);
    on<UpdateUserRoleEvent>(_onUpdateUserRole);
    on<DeleteUserEvent>(_onDeleteUser);
    on<RefreshUsersEvent>(_onRefreshUsers);
  }

  Future<void> _onLoadAllUsers(
    LoadAllUsersEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading());

    final params = GetAllUsersParams(
      page: event.page,
      limit: event.limit,
      search: event.search,
    );

    final result = await getAllUsersUseCase(params);

    result.fold(
      (failure) => emit(AdminUserError(failure.message)),
      (userList) => emit(UsersLoaded(
        users: userList.users,
        total: userList.total,
        currentPage: userList.page,
        totalPages: userList.totalPages,
      )),
    );
  }

  Future<void> _onUpdateUserRole(
    UpdateUserRoleEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading());

    final params = UpdateUserRoleParams(
      userId: event.userId,
      newRole: event.newRole,
    );

    final result = await updateUserRoleUseCase(params);

    result.fold(
      (failure) => emit(AdminUserError(failure.message)),
      (updatedUser) => emit(UserRoleUpdated(updatedUser)),
    );
  }

  Future<void> _onDeleteUser(
    DeleteUserEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    emit(AdminUserLoading());

    final result = await deleteUserUseCase(event.userId);

    result.fold(
      (failure) => emit(AdminUserError(failure.message)),
      (_) => emit(UserDeleted(event.userId)),
    );
  }

  Future<void> _onRefreshUsers(
    RefreshUsersEvent event,
    Emitter<AdminUserState> emit,
  ) async {
    add(const LoadAllUsersEvent());
  }
}
