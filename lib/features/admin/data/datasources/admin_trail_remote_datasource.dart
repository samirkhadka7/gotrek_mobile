import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/admin_trail_model.dart';

/// Remote data source for admin trail operations
abstract class AdminTrailRemoteDataSource {
  Future<TrailListResultModel> getAllTrails({
    int page = 1,
    int limit = 10,
    String? search,
    double? maxDistance,
    double? maxElevation,
    String? difficulty,
  });

  Future<AdminTrailModel> getTrailById(String trailId);

  Future<AdminTrailModel> createTrail({
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  });

  Future<AdminTrailModel> updateTrail({
    required String trailId,
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  });

  Future<void> deleteTrail(String trailId);
}

class AdminTrailRemoteDataSourceImpl implements AdminTrailRemoteDataSource {
  final ApiClient apiClient;

  AdminTrailRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TrailListResultModel> getAllTrails({
    int page = 1,
    int limit = 10,
    String? search,
    double? maxDistance,
    double? maxElevation,
    String? difficulty,
  }) async {
    try {
      print('🥾 Fetching all trails (page: $page, limit: $limit)');
      
      final queryParams = StringBuffer('page=$page&limit=$limit');
      if (search != null && search.isNotEmpty) {
        queryParams.write('&search=$search');
      }
      if (maxDistance != null) {
        queryParams.write('&maxDistance=$maxDistance');
      }
      if (maxElevation != null) {
        queryParams.write('&maxElevation=$maxElevation');
      }
      if (difficulty != null && difficulty.isNotEmpty) {
        queryParams.write('&difficulty=$difficulty');
      }

      final response = await apiClient.get('${ApiConstants.trails}?$queryParams');

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ Trails loaded successfully');
        return TrailListResultModel.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load trails');
      }
    } catch (e) {
      print('✗ TRAILS FETCH ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminTrailModel> getTrailById(String trailId) async {
    try {
      print('🥾 Fetching trail: $trailId');
      final response = await apiClient.get(ApiConstants.trailById(trailId));

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ Trail loaded successfully');
        return AdminTrailModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to load trail');
      }
    } catch (e) {
      print('✗ TRAIL FETCH ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminTrailModel> createTrail({
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  }) async {
    try {
      print('➕ Creating new trail: $name');
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'location': location,
        'distance': distance,
        'elevation': elevation,
        'difficulty': difficulty,
        if (durationMin != null) 'duration[min]': durationMin,
        if (durationMax != null) 'duration[max]': durationMax,
      };

      final response = imagePaths.isNotEmpty
          ? await apiClient.uploadFiles(
              ApiConstants.createTrail,
              filePaths: imagePaths,
              fieldName: 'images',
              additionalFields: body,
            )
          : await apiClient.post(
              ApiConstants.createTrail,
              data: body,
            );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ Trail created successfully');
        return AdminTrailModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create trail');
      }
    } catch (e) {
      print('✗ CREATE TRAIL ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<AdminTrailModel> updateTrail({
    required String trailId,
    required String name,
    required String description,
    required String location,
    required double distance,
    required double elevation,
    required String difficulty,
    int? durationMin,
    int? durationMax,
    List<String> imagePaths = const [],
  }) async {
    try {
      print('🔄 Updating trail: $trailId');
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'location': location,
        'distance': distance,
        'elevation': elevation,
        'difficulty': difficulty,
        if (durationMin != null) 'duration[min]': durationMin,
        if (durationMax != null) 'duration[max]': durationMax,
      };

      final response = imagePaths.isNotEmpty
          ? await apiClient.put(
              ApiConstants.trailById(trailId),
              data: FormData.fromMap({
                ...body,
                'images': await Future.wait(
                  imagePaths.map((path) => MultipartFile.fromFile(path)),
                ),
              }),
              options: Options(contentType: 'multipart/form-data'),
            )
          : await apiClient.put(
              ApiConstants.trailById(trailId),
              data: body,
            );

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ Trail updated successfully');
        return AdminTrailModel.fromJson(responseData['data']);
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update trail');
      }
    } catch (e) {
      print('✗ UPDATE TRAIL ERROR: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTrail(String trailId) async {
    try {
      print('🗑️ Deleting trail: $trailId');
      final response = await apiClient.delete(ApiConstants.trailById(trailId));

      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        print('✓ Trail deleted successfully');
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete trail');
      }
    } catch (e) {
      print('✗ DELETE TRAIL ERROR: $e');
      rethrow;
    }
  }
}
