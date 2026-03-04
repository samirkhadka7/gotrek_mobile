import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Register a new user
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  /// Sign up a new user (alias for register with different params)
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  });

  /// Login user with email and password
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Check if user is logged in
  Future<Either<Failure, bool>> isLoggedIn();

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset (sends OTP to email)
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  /// Reset password with OTP
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Get stored access token
  Future<Either<Failure, String?>> getAccessToken();

  /// Check if token is valid
  Future<Either<Failure, bool>> isTokenValid();

  /// Upload profile image
  Future<Either<Failure, UserEntity>> uploadProfileImage({
    required String filePath,
  });

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? ageGroup,
    String? hikerType,
    String? emergencyContactName,
    String? emergencyContactPhone,
  });
}
