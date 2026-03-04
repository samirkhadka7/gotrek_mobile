import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_entity.dart';
import '../repositories/checklist_repository.dart';

/// Use case for getting the user's saved checklist
class GetMyChecklistUseCase implements UseCase<UserChecklist?, NoParams> {
  final ChecklistRepository repository;

  GetMyChecklistUseCase(this.repository);

  @override
  Future<Either<Failure, UserChecklist?>> call(NoParams params) {
    return repository.getMyChecklist();
  }
}
