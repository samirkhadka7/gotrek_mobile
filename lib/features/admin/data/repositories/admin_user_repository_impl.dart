import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../datasources/admin_user_remote_datasource.dart';

/// Implementation of AdminUserRepository
class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminUserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserListResult>> getAllUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final result = await remoteDataSource.getAllUsers(
        page: page,
        limit: limit,
        search: search,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> getUserById(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final user = await remoteDataSource.getUserById(userId);
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> updateUserRole({
    required String userId,
    required String newRole,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    if (!['user', 'guide', 'admin'].contains(newRole)) {
      return const Left(ValidationFailure(message: 'Invalid role specified'));
    }

    try {
      final user = await remoteDataSource.updateUserRole(
        userId: userId,
        newRole: newRole,
      );
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final user = await remoteDataSource.updateUser(
        userId: userId,
        data: data,
      );
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await remoteDataSource.deleteUser(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminUserEntity>> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return const Left(ValidationFailure(message: 'All fields are required'));
    }

    try {
      final user = await remoteDataSource.createUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
      );
      return Right(user.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
