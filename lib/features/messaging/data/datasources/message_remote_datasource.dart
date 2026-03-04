import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/message_model.dart';

/// Abstract remote data source for message operations
abstract class MessageRemoteDataSource {
  /// Get all messages for a specific group
  Future<List<MessageModel>> getMessagesByGroup(String groupId);
}

/// Implementation of MessageRemoteDataSource
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final ApiClient apiClient;

  MessageRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<MessageModel>> getMessagesByGroup(String groupId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.messagesByGroup(groupId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final messagesData = data['data'] as List? ?? [];
        return messagesData
            .map((json) => MessageModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to fetch messages',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching messages: ${e.toString()}');
    }
  }
}
