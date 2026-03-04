import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/trail_model.dart';

/// Remote data source for trail operations
abstract class TrailRemoteDataSource {
  /// Get all trails with optional filters
  Future<List<TrailModel>> getTrails({Map<String, String>? queryParams});

  /// Get a single trail by ID
  Future<TrailModel> getTrailById(String id);

  /// Search trails by query
  Future<List<TrailModel>> searchTrails(String query);

  /// Join a trail with a specific date
  Future<void> joinTrailWithDate({
    required String trailId,
    required DateTime startDate,
  });

  /// Complete a joined trail
  Future<void> completeTrail(String joinedTrailId);

  /// Cancel a joined trail
  Future<void> cancelJoinedTrail(String joinedTrailId);

  /// Rate a trail
  Future<void> rateTrail({
    required String trailId,
    required int rating,
    String? review,
  });
}

/// Implementation of TrailRemoteDataSource
class TrailRemoteDataSourceImpl implements TrailRemoteDataSource {
  final ApiClient apiClient;

  TrailRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TrailModel>> getTrails({Map<String, String>? queryParams}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.trails,
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final trailsData = data['data'] as List? ?? [];
        return trailsData.map((json) => TrailModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to fetch trails',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching trails: ${e.toString()}');
    }
  }

  @override
  Future<TrailModel> getTrailById(String id) async {
    try {
      final response = await apiClient.get(
        ApiConstants.trailById(id),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true && data['data'] != null) {
        return TrailModel.fromJson(data['data'] as Map<String, dynamic>);
      } else {
        throw NotFoundException(message: 'Trail not found');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error fetching trail: ${e.toString()}');
    }
  }

  @override
  Future<List<TrailModel>> searchTrails(String query) async {
    try {
      final response = await apiClient.get(
        ApiConstants.trails,
        queryParameters: {'search': query},
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] == true) {
        final trailsData = data['data'] as List? ?? [];
        return trailsData.map((json) => TrailModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException(
          message: data['message'] ?? 'Failed to search trails',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error searching trails: ${e.toString()}');
    }
  }

  @override
  Future<void> joinTrailWithDate({
    required String trailId,
    required DateTime startDate,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.joinTrailWithDate(trailId),
        data: {
          'startDate': startDate.toIso8601String(),
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to join trail',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error joining trail: ${e.toString()}');
    }
  }

  @override
  Future<void> completeTrail(String joinedTrailId) async {
    try {
      final response = await apiClient.post(
        ApiConstants.completeTrail(joinedTrailId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to complete trail',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error completing trail: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelJoinedTrail(String joinedTrailId) async {
    try {
      final response = await apiClient.delete(
        ApiConstants.cancelJoinedTrail(joinedTrailId),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to cancel trail',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error cancelling trail: ${e.toString()}');
    }
  }

  @override
  Future<void> rateTrail({
    required String trailId,
    required int rating,
    String? review,
  }) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.trailById(trailId)}/rate',
        data: {
          'rating': rating,
          if (review != null) 'review': review,
        },
      );

      final data = response.data as Map<String, dynamic>;

      if (data['success'] != true) {
        throw ServerException(
          message: data['message'] ?? 'Failed to rate trail',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Error rating trail: ${e.toString()}');
    }
  }
}
