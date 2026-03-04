import '../../../../core/network/api_client.dart';
import '../../domain/entities/steps_entity.dart';
import '../models/steps_model.dart';

/// Remote data source for steps tracking
abstract class StepsRemoteDataSource {
  Future<StepRecordModel> getTodaySteps();
  Future<StepRecordModel> logSteps({
    required int steps,
    double? distance,
    int? calories,
  });
  Future<List<StepRecordModel>> getStepHistory({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<StepsStatsModel> getWeeklyStats();
  Future<StepsStatsModel> getMonthlyStats();
  Future<StepGoalModel> updateGoal(StepGoal goal);
  Future<StepGoalModel> getGoal();
  Future<StepSessionModel> startSession({String? trailId, String? trailName});
  Future<StepSessionModel> updateSession({
    required String sessionId,
    int? steps,
    double? distance,
    int? calories,
  });
  Future<StepSessionModel> endSession(String sessionId);
  Future<StepSessionModel?> getActiveSession();
  Future<List<StepSessionModel>> getSessionHistory({int page, int limit});
  Future<List<StepAchievementModel>> getAchievements();
  Future<StepRecordModel> syncFromDevice(int deviceSteps);
}

/// Implementation of StepsRemoteDataSource
class StepsRemoteDataSourceImpl implements StepsRemoteDataSource {
  final ApiClient _apiClient;

  StepsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<StepRecordModel> getTodaySteps() async {
    final response = await _apiClient.get('/step/today');
    final data = response.data as Map<String, dynamic>;
    return StepRecordModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepRecordModel> logSteps({
    required int steps,
    double? distance,
    int? calories,
  }) async {
    final response = await _apiClient.post(
      '/step/log',
      data: {
        'steps': steps,
        if (distance != null) 'distance': distance,
        if (calories != null) 'calories': calories,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return StepRecordModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<StepRecordModel>> getStepHistory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.get(
      '/step/history',
      queryParameters: {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
      },
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => StepRecordModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<StepsStatsModel> getWeeklyStats() async {
    final response = await _apiClient.get('/step/stats/weekly');
    final data = response.data as Map<String, dynamic>;
    return StepsStatsModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepsStatsModel> getMonthlyStats() async {
    final response = await _apiClient.get('/step/stats/monthly');
    final data = response.data as Map<String, dynamic>;
    return StepsStatsModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepGoalModel> updateGoal(StepGoal goal) async {
    final goalModel = StepGoalModel.fromEntity(goal);
    final response = await _apiClient.put(
      '/step/goal',
      data: goalModel.toJson(),
    );
    final data = response.data as Map<String, dynamic>;
    return StepGoalModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepGoalModel> getGoal() async {
    final response = await _apiClient.get('/step/goal');
    final data = response.data as Map<String, dynamic>;
    return StepGoalModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepSessionModel> startSession({
    String? trailId,
    String? trailName,
  }) async {
    final response = await _apiClient.post(
      '/step/session/start',
      data: {
        if (trailId != null) 'trailId': trailId,
        if (trailName != null) 'trailName': trailName,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return StepSessionModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepSessionModel> updateSession({
    required String sessionId,
    int? steps,
    double? distance,
    int? calories,
  }) async {
    final response = await _apiClient.patch(
      '/step/session/$sessionId',
      data: {
        if (steps != null) 'steps': steps,
        if (distance != null) 'distance': distance,
        if (calories != null) 'calories': calories,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return StepSessionModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepSessionModel> endSession(String sessionId) async {
    final response = await _apiClient.post(
      '/step/session/$sessionId/end',
    );
    final data = response.data as Map<String, dynamic>;
    return StepSessionModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<StepSessionModel?> getActiveSession() async {
    try {
      final response = await _apiClient.get('/step/session/active');
      final data = response.data as Map<String, dynamic>;
      if (data['data'] == null) return null;
      return StepSessionModel.fromJson(data['data'] as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<StepSessionModel>> getSessionHistory({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      '/step/session/history',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => StepSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<StepAchievementModel>> getAchievements() async {
    final response = await _apiClient.get('/step/achievements');
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => StepAchievementModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<StepRecordModel> syncFromDevice(int deviceSteps) async {
    final response = await _apiClient.post(
      '/step/sync',
      data: {'deviceSteps': deviceSteps},
    );
    final data = response.data as Map<String, dynamic>;
    return StepRecordModel.fromJson(data['data'] as Map<String, dynamic>);
  }
}
