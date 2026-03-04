import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Use case for getting pending join requests for groups the user leads
class GetPendingRequestsUseCase implements UseCase<List<JoinRequest>, NoParams> {
  final GroupRepository repository;

  GetPendingRequestsUseCase(this.repository);

  @override
  Future<Either<Failure, List<JoinRequest>>> call(NoParams params) async {
    return await repository.getPendingRequests();
  }
}
