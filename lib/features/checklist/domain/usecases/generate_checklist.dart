import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_entity.dart';
import '../repositories/checklist_repository.dart';

/// Use case for generating a checklist based on config
class GenerateChecklistUseCase
    implements UseCase<GeneratedChecklist, ChecklistConfig> {
  final ChecklistRepository repository;

  GenerateChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, GeneratedChecklist>> call(ChecklistConfig params) {
    return repository.generateChecklist(params);
  }
}
