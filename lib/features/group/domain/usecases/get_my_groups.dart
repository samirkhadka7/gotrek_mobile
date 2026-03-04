import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Use case for getting groups the current user is a member of
class GetMyGroupsUseCase implements UseCase<List<GroupEntity>, NoParams> {
  final GroupRepository repository;

  GetMyGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(NoParams params) async {
    return await repository.getMyGroups();
  }
}
