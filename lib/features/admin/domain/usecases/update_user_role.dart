import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_user_repository.dart';

/// Use case for updating user role
class UpdateUserRoleUseCase implements UseCase<AdminUserEntity, UpdateUserRoleParams> {
  final AdminUserRepository repository;

  UpdateUserRoleUseCase(this.repository);

  @override
  Future<Either<Failure, AdminUserEntity>> call(UpdateUserRoleParams params) {
    return repository.updateUserRole(
      userId: params.userId,
      newRole: params.newRole,
    );
  }
}

class UpdateUserRoleParams extends Equatable {
  final String userId;
  final String newRole;

  const UpdateUserRoleParams({
    required this.userId,
    required this.newRole,
  });

  @override
  List<Object?> get props => [userId, newRole];
}
