import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> logout();

  /// Get current user details - requires auth token
  Future<UserModel?> getCurrentUser({String? token});

  Future<UserModel> uploadProfileImage({
    required String filePath,
    String? token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    final response = await apiService.post(
      ApiConstants.signup,
      body: {
        'username': username,
        'email': email,
        'password': password,
        if (fullName != null) 'fullName': fullName,
        if (phone != null) 'phone': phone,
      },
    );

    if (response['success'] == true) {
      final userData = response['data'];
      final token = response['token'];

      print('✓ SIGNUP API RESPONSE: Success');
      print('✓ Token received: ${token != null ? 'Yes' : 'No'}');

      // Note: Repository will handle saving token and user data via localDataSource
      return UserModel.fromJson(userData, token: token as String?);
    } else {
      print('✗ SIGNUP FAILED: ${response['message']}');
      throw Exception(response['message']);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        ApiConstants.login,
        body: {'email': email, 'password': password},
      );

      print('✓ LOGIN API RESPONSE: $response');

      if (response['success'] == true) {
        final userData = response['data'];
        final token = response['token'];

        print(
          '✓ Login successful - User: ${userData['email']}, Token: ${token != null ? 'Present' : 'Missing'}',
        );

        // Note: Repository will handle saving token and user data via localDataSource
        return UserModel.fromJson(userData, token: token as String?);
      } else {
        print('✗ Login failed: ${response['message']}');
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('✗ LOGIN ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiService.post(
        ApiConstants.login,
      ); // You might have a logout endpoint
      print('✓ Logout successful');
    } catch (e) {
      print('⚠ Logout API error: $e');
      // Don't throw - logout should succeed even if API call fails
    }
  }

  @override
  Future<UserModel?> getCurrentUser({String? token}) async {
    if (token == null || token.isEmpty) {
      print('⚠ getCurrentUser called without token');
      return null;
    }

    try {
      final response = await apiService.get(ApiConstants.getMe, token: token);

      print('✓ GET /me API RESPONSE: ${response['success']}');

      if (response['success'] == true) {
        final userData = response['data'];
        return UserModel.fromJson(userData, token: token);
      } else {
        print('✗ Get current user failed: ${response['message']}');
        return null;
      }
    } catch (e) {
      print('✗ GET CURRENT USER ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel> uploadProfileImage({
    required String filePath,
    String? token,
  }) async {
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token required for profile image upload');
    }

    try {
      final response = await apiService.postMultipart(
        ApiConstants.uploadProfileImage,
        filePath: filePath,
        fieldName: 'image',
        token: token,
      );

      print('✓ PROFILE IMAGE UPLOAD API RESPONSE: ${response['success']}');

      if (response['success'] == true) {
        final userData = response['data'];
        return UserModel.fromJson(userData, token: token);
      } else {
        print('✗ Profile image upload failed: ${response['message']}');
        throw Exception(response['message'] ?? 'Upload failed');
      }
    } catch (e) {
      print('✗ PROFILE IMAGE UPLOAD ERROR: $e');
      rethrow;
    }
  }
}
