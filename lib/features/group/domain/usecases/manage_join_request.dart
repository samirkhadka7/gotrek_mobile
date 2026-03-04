import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/group_repository.dart';

/// Parameters for managing a join request
class ManageJoinRequestParams extends Equatable {
  final String groupId;
  final String requestId;
  final bool approve;

  const ManageJoinRequestParams({
    required this.groupId,
    required this.requestId,
    required this.approve,
  });

  @override
  List<Object?> get props => [groupId, requestId, approve];
}

/// Use case for approving or denying a join request
class ManageJoinRequestUseCase implements UseCase<void, ManageJoinRequestParams> {
  final GroupRepository repository;

  ManageJoinRequestUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ManageJoinRequestParams params) async {
    if (params.approve) {
      return await repository.approveJoinRequest(
        groupId: params.groupId,
        requestId: params.requestId,
      );
    } else {
      return await repository.denyJoinRequest(
        groupId: params.groupId,
        requestId: params.requestId,
      );
    }
  }
}
