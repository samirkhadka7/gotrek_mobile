import 'package:equatable/equatable.dart';

/// Base event for AdminUser
abstract class AdminUserEvent extends Equatable {
  const AdminUserEvent();

  @override
  List<Object?> get props => [];
}

/// Load all users with pagination
class LoadAllUsersEvent extends AdminUserEvent {
  final int page;
  final int limit;
  final String? search;

  const LoadAllUsersEvent({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}

/// Load user details by ID
class LoadUserDetailsEvent extends AdminUserEvent {
  final String userId;

  const LoadUserDetailsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Update user role
class UpdateUserRoleEvent extends AdminUserEvent {
  final String userId;
  final String newRole;

  const UpdateUserRoleEvent({
    required this.userId,
    required this.newRole,
  });

  @override
  List<Object?> get props => [userId, newRole];
}

/// Delete user
class DeleteUserEvent extends AdminUserEvent {
  final String userId;

  const DeleteUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Create new user
class CreateUserEvent extends AdminUserEvent {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? role;

  const CreateUserEvent({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.role,
  });

  @override
  List<Object?> get props => [name, email, password, phone, role];
}

/// Refresh users list
class RefreshUsersEvent extends AdminUserEvent {
  const RefreshUsersEvent();
}
