import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/group_repository.dart';

/// Parameters for requesting to join a group
class RequestJoinGroupParams extends Equatable {
  final String groupId;
  final String? message;

  const RequestJoinGroupParams({
    required this.groupId,
    this.message,
  });

  @override
  List<Object?> get props => [groupId, message];
}

/// Use case for requesting to join a group
class RequestJoinGroupUseCase implements UseCase<void, RequestJoinGroupParams> {
  final GroupRepository repository;

  RequestJoinGroupUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RequestJoinGroupParams params) async {
    return await repository.requestJoinGroup(
      groupId: params.groupId,
      message: params.message,
    );
  }
}
