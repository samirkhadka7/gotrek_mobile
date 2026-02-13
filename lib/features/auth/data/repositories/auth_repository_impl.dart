import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      // Validation
      if (username.isEmpty || username.length < 3) {
        return const Left(ValidationFailure(message: 'Username must be at least 3 characters'));
      }
      if (email.isEmpty || !email.contains('@')) {
        return const Left(ValidationFailure(message: 'Please enter a valid email'));
      }
      if (password.isEmpty || password.length < 6) {
        return const Left(ValidationFailure(message: 'Password must be at least 6 characters'));
      }

      final user = await remoteDataSource.signUp(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      if (username.isEmpty) {
        return const Left(ValidationFailure(message: 'Username cannot be empty'));
      }
      if (password.isEmpty) {
        return const Left(ValidationFailure(message: 'Password cannot be empty'));
      }

      final user = await remoteDataSource.login(
        username: username,
        password: password,
      );
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage({
    required String filePath,
  }) async {
    try {
      if (filePath.isEmpty) {
        return const Left(ValidationFailure(message: 'Image path cannot be empty'));
      }

      final user = await remoteDataSource.uploadProfileImage(filePath: filePath);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final result = remoteDataSource.isLoggedIn();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}