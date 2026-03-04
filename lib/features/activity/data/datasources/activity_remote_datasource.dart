import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/activity_model.dart';

/// Remote data source for activity operations
abstract class ActivityRemoteDataSource {
  Future<List<ActivityModel>> getRecentActivities();
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final ApiClient apiClient;

  ActivityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ActivityModel>> getRecentActivities() async {
    try {
      print('📊 Fetching recent activities...');
      final response = await apiClient.get(ApiConstants.recentActivities);
      
      final responseData = response.data as Map<String, dynamic>;
      print('✓ Activity API RESPONSE: ${responseData['success']}');
      
      if (responseData['success'] == true) {
        final List<dynamic> data = responseData['data'] ?? [];
        final activities = data.map((json) => ActivityModel.fromJson(json)).toList();
        print('✓ Loaded ${activities.length} activities');
        return activities;
      } else {
        print('✗ Failed to load activities: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Failed to load activities');
      }
    } catch (e) {
      print('✗ ACTIVITY FETCH ERROR: $e');
      rethrow;
    }
  }
}
