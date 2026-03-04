import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_user_entity.dart';

/// Repository interface for admin user operations
abstract class AdminUserRepository {
  /// Get all users with pagination
  Future<Either<Failure, UserListResult>> getAllUsers({
    int page = 1,
    int limit = 10,
    String? search,
  });

  /// Get user by ID
  Future<Either<Failure, AdminUserEntity>> getUserById(String userId);

  /// Update user role
  Future<Either<Failure, AdminUserEntity>> updateUserRole({
    required String userId,
    required String newRole,
  });

  /// Update user details
  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  });

  /// Delete user
  Future<Either<Failure, void>> deleteUser(String userId);

  /// Create new user
  Future<Either<Failure, AdminUserEntity>> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role,
  });
}
