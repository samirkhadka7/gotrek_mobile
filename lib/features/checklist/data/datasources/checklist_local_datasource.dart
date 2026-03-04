import 'package:hive/hive.dart';

import '../models/checklist_model.dart';

/// Local data source for checklist operations (offline support)
abstract class ChecklistLocalDataSource {
  /// Get cached checklist
  Future<UserChecklistModel?> getCachedChecklist();

  /// Cache the user's checklist
  Future<void> cacheChecklist(UserChecklistModel checklist);

  /// Clear cached checklist
  Future<void> clearCache();
}

/// Implementation of ChecklistLocalDataSource using Hive
class ChecklistLocalDataSourceImpl implements ChecklistLocalDataSource {
  static const String _boxName = 'checklist_box';
  static const String _checklistKey = 'user_checklist';

  Future<Box<UserChecklistModel>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<UserChecklistModel>(_boxName);
    }
    return Hive.box<UserChecklistModel>(_boxName);
  }

  @override
  Future<UserChecklistModel?> getCachedChecklist() async {
    final box = await _box;
    return box.get(_checklistKey);
  }

  @override
  Future<void> cacheChecklist(UserChecklistModel checklist) async {
    final box = await _box;
    await box.put(_checklistKey, checklist);
  }

  @override
  Future<void> clearCache() async {
    final box = await _box;
    await box.delete(_checklistKey);
  }
}
