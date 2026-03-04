import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_entity.dart';
import '../repositories/checklist_repository.dart';

/// Use case for updating a single checklist item
class UpdateChecklistItemUseCase
    implements UseCase<UserChecklist, UpdateChecklistItemParams> {
  final ChecklistRepository repository;

  UpdateChecklistItemUseCase(this.repository);

  @override
  Future<Either<Failure, UserChecklist>> call(UpdateChecklistItemParams params) {
    return repository.updateChecklistItem(
      itemId: params.itemId,
      isChecked: params.isChecked,
    );
  }
}

/// Parameters for updating a checklist item
class UpdateChecklistItemParams extends Equatable {
  final String itemId;
  final bool isChecked;

  const UpdateChecklistItemParams({
    required this.itemId,
    required this.isChecked,
  });

  @override
  List<Object?> get props => [itemId, isChecked];
}
