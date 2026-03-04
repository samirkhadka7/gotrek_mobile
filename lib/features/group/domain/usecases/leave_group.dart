import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/group_repository.dart';

/// Use case for leaving a group
class LeaveGroupUseCase implements UseCase<void, String> {
  final GroupRepository repository;

  LeaveGroupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.leaveGroup(params);
  }
}
