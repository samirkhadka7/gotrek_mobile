import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/services/profile_sync_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository with offline-first approach
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ProfileSyncService profileSyncService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.profileSyncService,
  });

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // Validation
    if (name.isEmpty || name.length < 2) {
      return const Left(
        ValidationFailure(message: 'Name must be at least 2 characters'),
      );
    }
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }
    if (password.isEmpty || password.length < 8) {
      return const Left(
        ValidationFailure(message: 'Password must be at least 8 characters'),
      );
    }
    if (phone.isEmpty) {
      return const Left(ValidationFailure(message: 'Phone number is required'));
    }

    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      final userModel = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    // Validation
    if (email.isEmpty) {
      return const Left(ValidationFailure(message: 'Email is required'));
    }
    if (password.isEmpty) {
      return const Left(ValidationFailure(message: 'Password is required'));
    }

    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save user session locally (non-blocking)
      try {
        if (userModel.token != null) {
          await localDataSource.saveUserSession(
            userId: userModel.id,
            email: userModel.email,
            role: userModel.role,
            token: userModel.token!,
          );
        }

        // Cache user data
        await localDataSource.cacheUser(userModel);
      } catch (_) {
        // Ignore local cache errors to allow login success
      }

      return Right(userModel.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAllAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // First try to get from local cache (as fallback)
      final cachedUser = await localDataSource.getCachedUser();

      if (!await networkInfo.isConnected) {
        // Offline - if we have cached user, return it (already logged in)
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        // No cached user + offline = can't authenticate
        return const Left(
          NetworkFailure(
            message: 'No internet connection. Please connect to the internet to continue.',
          ),
        );
      }

      // Fetch fresh data from server
      try {
        // Call the remote datasource which includes token via apiClient
        final userModel = await remoteDataSource.getCurrentUser();

        // Update cache with fresh data
        await localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      } on UnauthorizedException {
        // Token expired, clear auth data
        await localDataSource.clearAllAuthData();
        return const Left(UnauthorizedFailure());
      } catch (e) {
        print('⚠ getCurrentUser API error: $e');
        // If network request fails but we have cached data, return cached
        if (cachedUser != null) {
          return Right(cachedUser.toEntity());
        }
        rethrow;
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // Validation
    if (currentPassword.isEmpty) {
      return const Left(
        ValidationFailure(message: 'Current password is required'),
      );
    }
    if (newPassword.isEmpty || newPassword.length < 8) {
      return const Left(
        ValidationFailure(
          message: 'New password must be at least 8 characters',
        ),
      );
    }

    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }

    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }
    if (otp.isEmpty || otp.length != 6) {
      return const Left(
        ValidationFailure(message: 'Please enter the 6-digit OTP'),
      );
    }
    if (newPassword.isEmpty || newPassword.length < 8) {
      return const Left(
        ValidationFailure(message: 'Password must be at least 8 characters'),
      );
    }

    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getAccessToken() async {
    try {
      final token = await localDataSource.getToken();
      return Right(token);
    } on SecureStorageException catch (e) {
      return Left(SecureStorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isTokenValid() async {
    try {
      final token = await localDataSource.getToken();
      if (token == null || token.isEmpty) {
        return const Right(false);
      }

      // Try to get current user to verify token is valid
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.getCurrentUser();
          return const Right(true);
        } on UnauthorizedException {
          return const Right(false);
        }
      }

      // If offline, assume token is valid (will be verified when online)
      return const Right(true);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    // Validation
    if (username.isEmpty || username.length < 3) {
      return const Left(
        ValidationFailure(message: 'Username must be at least 3 characters'),
      );
    }
    if (email.isEmpty || !_isValidEmail(email)) {
      return const Left(
        ValidationFailure(message: 'Please enter a valid email address'),
      );
    }
    if (password.isEmpty || password.length < 8) {
      return const Left(
        ValidationFailure(message: 'Password must be at least 8 characters'),
      );
    }

    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      final userModel = await remoteDataSource.signUp(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );

      // Save user session locally
      if (userModel.token != null) {
        await localDataSource.saveUserSession(
          userId: userModel.id,
          email: userModel.email,
          role: userModel.role,
          token: userModel.token!,
        );
      }

      // Cache user data
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> uploadProfileImage({
    required String filePath,
  }) async {
    if (filePath.isEmpty) {
      return const Left(ValidationFailure(message: 'File path is required'));
    }

    if (!await networkInfo.isConnected) {
      return const Left(
        NetworkFailure(
          message: 'No internet connection. Please check your network.',
        ),
      );
    }

    try {
      // Get token from storage
      final token = await localDataSource.getToken();
      if (token == null) {
        return const Left(UnauthorizedFailure());
      }

      final userModel = await remoteDataSource.uploadProfileImage(
        filePath: filePath,
      );

      // Update cached user data
      await localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? ageGroup,
    String? hikerType,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    // Build the pending update fields map
    final pendingFields = <String, dynamic>{
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (ageGroup != null) 'ageGroup': ageGroup,
      if (hikerType != null) 'hikerType': hikerType,
      if (emergencyContactName != null) 'emergencyContactName': emergencyContactName,
      if (emergencyContactPhone != null) 'emergencyContactPhone': emergencyContactPhone,
    };

    if (await networkInfo.isConnected) {
      // Online: sync to server immediately
      try {
        final userModel = await remoteDataSource.updateProfile(
          name: name,
          phone: phone,
          bio: bio,
          ageGroup: ageGroup,
          hikerType: hikerType,
          emergencyContactName: emergencyContactName,
          emergencyContactPhone: emergencyContactPhone,
        );

        await localDataSource.clearCachedUser();
        await localDataSource.cacheUser(userModel);

        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
      } catch (e) {
        return Left(UnknownFailure(message: e.toString()));
      }
    } else {
      // Offline: update local cache and queue for sync
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser == null) {
          return const Left(
            CacheFailure(message: 'No cached user data available to update offline.'),
          );
        }

        // Create updated model locally
        final updatedModel = UserModel(
          id: cachedUser.id,
          name: name ?? cachedUser.name,
          email: cachedUser.email,
          phone: phone ?? cachedUser.phone,
          hikerType: hikerType ?? cachedUser.hikerType,
          ageGroup: ageGroup ?? cachedUser.ageGroup,
          emergencyContact: (emergencyContactName != null || emergencyContactPhone != null)
              ? EmergencyContactModel(
                  name: emergencyContactName ?? cachedUser.emergencyContact?.name,
                  phone: emergencyContactPhone ?? cachedUser.emergencyContact?.phone,
                )
              : cachedUser.emergencyContact,
          bio: bio ?? cachedUser.bio,
          profileImage: cachedUser.profileImage,
          joinDate: cachedUser.joinDate,
          role: cachedUser.role,
          subscription: cachedUser.subscription,
          subscriptionExpiresAt: cachedUser.subscriptionExpiresAt,
          stats: cachedUser.stats,
          achievements: cachedUser.achievements,
          completedTrails: cachedUser.completedTrails,
          joinedTrails: cachedUser.joinedTrails,
          groupsCount: cachedUser.groupsCount,
          createdAt: cachedUser.createdAt,
          updatedAt: DateTime.now(),
          token: cachedUser.token,
        );

        // Save updated user to local cache
        await localDataSource.clearCachedUser();
        await localDataSource.cacheUser(updatedModel);

        // Queue pending update for sync when online
        await profileSyncService.savePendingProfileUpdate(pendingFields);

        return Right(updatedModel.toEntity());
      } catch (e) {
        return Left(UnknownFailure(message: 'Failed to update profile offline: $e'));
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}
