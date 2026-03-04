import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';

/// Remote data source for chatbot operations
abstract class ChatbotRemoteDataSource {
  /// Send a query to the chatbot API
  Future<String> sendQuery(String query);
}

/// Implementation of ChatbotRemoteDataSource
class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final ApiClient apiClient;

  ChatbotRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> sendQuery(String query) async {
    try {
      final response = await apiClient.post(
        ApiConstants.chatbotQuery,
        data: {'query': query},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        final responseData = data['data'] as Map<String, dynamic>;
        return responseData['response'] as String? ?? 'I could not understand that. Please try again.';
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to get chatbot response',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error getting chatbot response: ${e.toString()}');
    }
  }
}
