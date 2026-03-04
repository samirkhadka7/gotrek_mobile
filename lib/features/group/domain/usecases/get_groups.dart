import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Use case for getting all groups with optional filters
class GetGroupsUseCase implements UseCase<List<GroupEntity>, GroupFilterParams?> {
  final GroupRepository repository;

  GetGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<GroupEntity>>> call(GroupFilterParams? params) async {
    return await repository.getGroups(filters: params);
  }
}
