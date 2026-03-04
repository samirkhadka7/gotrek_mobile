import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/checklist_entity.dart';

/// Repository for checklist operations
abstract class ChecklistRepository {
  /// Generate a new checklist based on config
  Future<Either<Failure, GeneratedChecklist>> generateChecklist(
    ChecklistConfig config,
  );

  /// Get the user's saved checklist
  Future<Either<Failure, UserChecklist?>> getMyChecklist();

  /// Save/update the user's checklist
  Future<Either<Failure, UserChecklist>> saveChecklist({
    required List<ChecklistItem> items,
    required ChecklistConfig config,
  });

  /// Update a single checklist item (toggle checked state)
  Future<Either<Failure, UserChecklist>> updateChecklistItem({
    required String itemId,
    required bool isChecked,
  });

  /// Clear the user's checklist
  Future<Either<Failure, void>> clearChecklist();
}
