import '../../../../core/network/api_client.dart';
import '../../domain/entities/checklist_entity.dart';
import '../models/checklist_model.dart';

/// Remote data source for checklist operations
abstract class ChecklistRemoteDataSource {
  /// Generate a new checklist based on config
  Future<GeneratedChecklistModel> generateChecklist(ChecklistConfig config);

  /// Get the user's saved checklist
  Future<UserChecklistModel?> getMyChecklist();

  /// Save/update the user's checklist
  Future<UserChecklistModel> saveChecklist({
    required List<ChecklistItem> items,
    required ChecklistConfig config,
  });

  /// Update a single checklist item
  Future<UserChecklistModel> updateChecklistItem({
    required String itemId,
    required bool isChecked,
  });

  /// Clear the user's checklist
  Future<void> clearChecklist();
}

/// Implementation of ChecklistRemoteDataSource
class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final ApiClient _apiClient;

  ChecklistRemoteDataSourceImpl(this._apiClient);

  @override
  Future<GeneratedChecklistModel> generateChecklist(ChecklistConfig config) async {
    final response = await _apiClient.post(
      '/api/v1/checklist/generate',
      data: {
        'experience': config.experience.apiValue,
        'duration': config.duration.apiValue,
        'weather': config.weather.apiValue,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return GeneratedChecklistModel.fromJson(data['data'] ?? data);
  }

  @override
  Future<UserChecklistModel?> getMyChecklist() async {
    final response = await _apiClient.get('/api/v1/checklist/my-checklist');
    final data = response.data as Map<String, dynamic>;

    if (data['data'] == null) {
      return null;
    }

    return UserChecklistModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserChecklistModel> saveChecklist({
    required List<ChecklistItem> items,
    required ChecklistConfig config,
  }) async {
    // Group items by category for the API
    final Map<String, List<Map<String, dynamic>>> groupedItems = {};
    for (final item in items) {
      if (!groupedItems.containsKey(item.category)) {
        groupedItems[item.category] = [];
      }
      groupedItems[item.category]!.add({
        'id': item.id,
        'name': item.name,
        'isChecked': item.isChecked,
      });
    }

    final response = await _apiClient.post(
      '/api/v1/checklist/save',
      data: {
        'items': groupedItems,
        'config': {
          'experience': config.experience.apiValue,
          'duration': config.duration.apiValue,
          'weather': config.weather.apiValue,
        },
      },
    );

    final data = response.data as Map<String, dynamic>;
    return UserChecklistModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<UserChecklistModel> updateChecklistItem({
    required String itemId,
    required bool isChecked,
  }) async {
    final response = await _apiClient.patch(
      '/api/v1/checklist/item/$itemId',
      data: {
        'isChecked': isChecked,
      },
    );

    final data = response.data as Map<String, dynamic>;
    return UserChecklistModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> clearChecklist() async {
    await _apiClient.delete('/api/v1/checklist/clear');
  }
}
