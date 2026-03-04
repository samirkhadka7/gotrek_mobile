import 'package:hive/hive.dart';

import '../models/steps_model.dart';

/// Local data source for steps (offline support)
abstract class StepsLocalDataSource {
  Future<StepRecordModel?> getCachedTodaySteps();
  Future<void> cacheTodaySteps(StepRecordModel record);
  Future<StepGoalModel?> getCachedGoal();
  Future<void> cacheGoal(StepGoalModel goal);
  Future<StepSessionModel?> getCachedActiveSession();
  Future<void> cacheActiveSession(StepSessionModel? session);
  Future<void> clearCache();
}

/// Implementation using Hive
class StepsLocalDataSourceImpl implements StepsLocalDataSource {
  static const String _boxName = 'steps_box';
  static const String _todayStepsKey = 'today_steps';
  static const String _goalKey = 'step_goal';
  static const String _activeSessionKey = 'active_session';

  Future<Box<dynamic>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<dynamic>(_boxName);
    }
    return Hive.box<dynamic>(_boxName);
  }

  @override
  Future<StepRecordModel?> getCachedTodaySteps() async {
    final box = await _box;
    final data = box.get(_todayStepsKey);
    if (data != null && data is Map) {
      return StepRecordModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> cacheTodaySteps(StepRecordModel record) async {
    final box = await _box;
    await box.put(_todayStepsKey, record.toJson());
  }

  @override
  Future<StepGoalModel?> getCachedGoal() async {
    final box = await _box;
    final data = box.get(_goalKey);
    if (data != null && data is Map) {
      return StepGoalModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> cacheGoal(StepGoalModel goal) async {
    final box = await _box;
    await box.put(_goalKey, goal.toJson());
  }

  @override
  Future<StepSessionModel?> getCachedActiveSession() async {
    final box = await _box;
    final data = box.get(_activeSessionKey);
    if (data != null && data is Map) {
      return StepSessionModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> cacheActiveSession(StepSessionModel? session) async {
    final box = await _box;
    if (session == null) {
      await box.delete(_activeSessionKey);
    } else {
      await box.put(_activeSessionKey, session.toJson());
    }
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.clear();
  }
}
