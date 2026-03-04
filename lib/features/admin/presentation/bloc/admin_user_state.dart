import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_user_entity.dart';

/// Base state for AdminUser
abstract class AdminUserState extends Equatable {
  const AdminUserState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AdminUserInitial extends AdminUserState {}

/// Loading state
class AdminUserLoading extends AdminUserState {}

/// Users list loaded
class UsersLoaded extends AdminUserState {
  final List<AdminUserEntity> users;
  final int total;
  final int currentPage;
  final int totalPages;

  const UsersLoaded({
    required this.users,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [users, total, currentPage, totalPages];
}

/// User details loaded
class UserDetailsLoaded extends AdminUserState {
  final AdminUserEntity user;

  const UserDetailsLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

/// User role updated successfully
class UserRoleUpdated extends AdminUserState {
  final AdminUserEntity updatedUser;

  const UserRoleUpdated(this.updatedUser);

  @override
  List<Object?> get props => [updatedUser];
}

/// User deleted successfully
class UserDeleted extends AdminUserState {
  final String userId;

  const UserDeleted(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// User created successfully
class UserCreated extends AdminUserState {
  final AdminUserEntity newUser;

  const UserCreated(this.newUser);

  @override
  List<Object?> get props => [newUser];
}

/// Error state
class AdminUserError extends AdminUserState {
  final String message;

  const AdminUserError(this.message);

  @override
  List<Object?> get props => [message];
}
