import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/analytics_model.dart';

/// Remote data source for analytics operations
abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsModel> getAnalytics();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final ApiClient apiClient;

  AnalyticsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AnalyticsModel> getAnalytics() async {
    try {
      print('📊 Fetching analytics data...');
      final response = await apiClient.get(ApiConstants.analytics);

      final responseData = response.data as Map<String, dynamic>;
      print('✓ Analytics API RESPONSE: ${responseData['success']}');

      if (responseData['success'] == true) {
        final analytics = AnalyticsModel.fromJson(responseData['data']);
        print('✓ Analytics loaded successfully');
        return analytics;
      } else {
        print('✗ Failed to load analytics: ${responseData['message']}');
        throw Exception(responseData['message'] ?? 'Failed to load analytics');
      }
    } catch (e) {
      print('✗ ANALYTICS FETCH ERROR: $e');
      rethrow;
    }
  }
}
