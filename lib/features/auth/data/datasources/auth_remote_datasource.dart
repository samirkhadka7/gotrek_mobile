import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/network/hive_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
    String? phone,
  });
  
  Future<UserModel> login({
    required String username,
    required String password,
  });
  
  Future<void> logout();
  
  Future<UserModel?> getCurrentUser();

  Future<UserModel> uploadProfileImage({
    required String filePath,
  });
  
  bool isLoggedIn();
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
      
      // Save token locally
      await HiveService.saveToken(userData['token']);
      await HiveService.saveUserData(userData);
      
      return UserModel.fromJson(userData);
    } else {
      throw Exception(response['message']);
    }
  }

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await apiService.post(
      ApiConstants.login,
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response['success'] == true) {
      final userData = response['data'];
      
      // Save token locally
      await HiveService.saveToken(userData['token']);
      await HiveService.saveUserData(userData);
      
      return UserModel.fromJson(userData);
    } else {
      throw Exception(response['message']);
    }
  }

  @override
  Future<void> logout() async {
    await HiveService.clearAll();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // First check local storage
    final localData = HiveService.getUserData();
    if (localData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(localData));
    }
    
    // If token exists, fetch from API
    final token = HiveService.getToken();
    if (token != null) {
      try {
        final response = await apiService.get(
          ApiConstants.getMe,
          token: token,
        );
        
        if (response['success'] == true) {
          final userData = response['data'];
          await HiveService.saveUserData(userData);
          return UserModel.fromJson(userData);
        }
      } catch (e) {
        // Token expired or invalid
        await HiveService.clearAll();
      }
    }
    
    return null;
  }

  @override
  Future<UserModel> uploadProfileImage({
    required String filePath,
  }) async {
    final token = HiveService.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await apiService.postMultipart(
      ApiConstants.uploadProfileImage,
      filePath: filePath,
      fieldName: 'image',
      token: token,
    );

    if (response['success'] == true) {
      final userData = response['data'];
      await HiveService.saveUserData(userData);
      return UserModel.fromJson(userData);
    } else {
      throw Exception(response['message']);
    }
  }

  @override
  bool isLoggedIn() {
    return HiveService.isLoggedIn();
  }
}