import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/admin_user_model.dart';

/// Remote data source for admin user operations
abstract class AdminUserRemoteDataSource {
  Future<UserListResultModel> getAllUsers({
    int page = 1,
    int limit = 10,
    String? search,
  });

  Future<AdminUserModel> getUserById(String userId);

  Future<AdminUserModel> updateUserRole({
    required String userId,
    required String newRole,
  });

  Future<AdminUserModel> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteUser(String userId);

  Future<AdminUserModel> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role,
  });
}

class AdminUserRemoteDataSourceImpl implements AdminUserRemoteDataSource {
  final ApiClient apiClient;

  AdminUserRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserListResultModel> getAllUsers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      print('📊 Fetching all users (page: $page, limit: $limit, search: $search)');
      
      final queryParams = 'page=$page&limit=$limit${search != null && search.isNotEmpty ? '&search=$search' : ''}';
      final response = await apiClient.get('${ApiConstants.users}?$queryParams');

      final responseData = response.data as Map<String, dynamic>;
      print('✓ Users API RESPONSE: ${responseData['success']}');

      if (responseData['success'] == true) {
        final result = UserListResultModel.fromJson(responseData);
        print('✓ Loaded ${result.users.length} users');
        return result;
      } else {
        print('✗ Failed to load users: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Failed to load users');
      }
    } catch (e) {
      print('✗ USERS FETCH ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminUserModel> getUserById(String userId) async {
    try {
      print('👤 Fetching user: $userId');
      final response = await apiClient.get(ApiConstants.userById(userId));

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ User loaded successfully');
        return AdminUserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load user');
      }
    } catch (e) {
      print('✗ USER FETCH ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminUserModel> updateUserRole({
    required String userId,
    required String newRole,
  }) async {
    try {
      print('🔄 Updating user role: $userId to $newRole');
      final response = await apiClient.put(
        ApiConstants.updateUserRole(userId),
        data: {'newRoles': newRole},
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ User role updated successfully');
        return AdminUserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update user role');
      }
    } catch (e) {
      print('✗ UPDATE ROLE ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminUserModel> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      print('🔄 Updating user: $userId');
      final response = await apiClient.put(
        ApiConstants.userById(userId),
        data: data,
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ User updated successfully');
        return AdminUserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      print('✗ UPDATE USER ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      print('🗑️ Deleting user: $userId');
      final response = await apiClient.delete(ApiConstants.userById(userId));

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ User deleted successfully');
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      print('✗ DELETE USER ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminUserModel> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? role,
  }) async {
    try {
      print('➕ Creating new user: $email');
      final response = await apiClient.post(
        '${ApiConstants.users}/create',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
          if (role != null) 'role': role,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ User created successfully');
        return AdminUserModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      print('✗ CREATE USER ERROR: $e');
      rethrow;
    }
  }
}
