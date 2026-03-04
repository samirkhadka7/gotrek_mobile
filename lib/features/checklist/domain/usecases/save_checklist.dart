import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_entity.dart';
import '../repositories/checklist_repository.dart';

/// Use case for saving/updating the user's checklist
class SaveChecklistUseCase implements UseCase<UserChecklist, SaveChecklistParams> {
  final ChecklistRepository repository;

  SaveChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, UserChecklist>> call(SaveChecklistParams params) {
    return repository.saveChecklist(
      items: params.items,
      config: params.config,
    );
  }
}

/// Parameters for saving checklist
class SaveChecklistParams extends Equatable {
  final List<ChecklistItem> items;
  final ChecklistConfig config;

  const SaveChecklistParams({
    required this.items,
    required this.config,
  });

  @override
  List<Object?> get props => [items, config];
}
