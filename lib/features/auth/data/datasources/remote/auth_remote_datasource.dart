import 'package:dio/dio.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/user_model.dart';

/// Remote data source for authentication operations
abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });

  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  });

  Future<UserModel> login({required String email, required String password});

  Future<UserModel> getCurrentUser();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<UserModel> uploadProfileImage({required String filePath});

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? ageGroup,
    String? hikerType,
    String? emergencyContactName,
    String? emergencyContactPhone,
  });
}

/// Implementation of AuthRemoteDataSource
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Registration failed',
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromJson(data['data']);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to register: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {
          'email': email, // Backend expects 'email' field
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;

      // Debug: Print response structure
      print('LOGIN RESPONSE: $data');

      if (data['success'] != true) {
        throw AuthException(
          message: data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }

      final token = data['token'] as String?;
      print('TOKEN: $token');

      // Backend may return user data as 'data', 'user', or at root level
      final userData =
          data['data'] as Map<String, dynamic>? ??
          data['user'] as Map<String, dynamic>? ??
          data;

      print('USER DATA: $userData');

      // Set the token for subsequent requests
      if (token != null) {
        apiClient.setAuthToken(token);
      }

      print('Creating UserModel...');
      final userModel = UserModel.fromJson(userData, token: token);
      print(
        'UserModel created successfully: ${userModel.id}, ${userModel.name}',
      );

      return userModel;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        message: 'Failed to login: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.get(ApiConstants.userMe);

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to get user',
          statusCode: response.statusCode,
        );
      }

      // Backend may return user data as 'data', 'user', or at root level
      final userData =
          data['data'] as Map<String, dynamic>? ??
          data['user'] as Map<String, dynamic>? ??
          data;

      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get user: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to change password',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to change password: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to request password reset',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to request password reset: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPassword,
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to reset password',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to reset password: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signup,
        data: {
          'username': username,
          'email': email,
          'password': password,
          if (fullName != null) 'fullName': fullName,
          if (phone != null) 'phone': phone,
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Sign up failed',
          statusCode: response.statusCode,
        );
      }

      final token = data['token'] as String?;
      final userData = data['data'] as Map<String, dynamic>;

      // Set the token for subsequent requests
      if (token != null) {
        apiClient.setAuthToken(token);
      }

      return UserModel.fromJson(userData, token: token);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to sign up: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> uploadProfileImage({required String filePath}) async {
    try {
      // Backend expects PUT method with 'profileImage' field name
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(filePath),
      });

      final response = await apiClient.put(
        ApiConstants.uploadProfileImage,
        data: formData,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to upload profile image',
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromJson(data['data']);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to upload profile image: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? ageGroup,
    String? hikerType,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (phone != null) data['phone'] = phone;
      if (bio != null) data['bio'] = bio;
      if (ageGroup != null) data['ageGroup'] = ageGroup;
      if (hikerType != null) data['hikerType'] = hikerType;
      if (emergencyContactName != null || emergencyContactPhone != null) {
        data['emergencyContact'] = {
          if (emergencyContactName != null) 'name': emergencyContactName,
          if (emergencyContactPhone != null) 'phone': emergencyContactPhone,
        };
      }

      final response = await apiClient.put(
        ApiConstants.userMe,
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData['success'] != true) {
        throw ServerException(
          message: responseData['message'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }

      return UserModel.fromJson(responseData['data']);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to update profile: ${e.toString()}',
        originalException: e,
      );
    }
  }
}
