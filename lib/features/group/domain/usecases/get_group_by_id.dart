import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Use case for getting a single group by ID
class GetGroupByIdUseCase implements UseCase<GroupEntity, String> {
  final GroupRepository repository;

  GetGroupByIdUseCase(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call(String params) async {
    return await repository.getGroupById(params);
  }
}
