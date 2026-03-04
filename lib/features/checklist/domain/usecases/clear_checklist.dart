import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/checklist_repository.dart';

/// Use case for clearing the user's checklist
class ClearChecklistUseCase implements UseCase<void, NoParams> {
  final ChecklistRepository repository;

  ClearChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.clearChecklist();
  }
}
