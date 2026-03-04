import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Parameters for updating a group
class UpdateGroupParams extends Equatable {
  final String groupId;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? maxParticipants;
  final List<String>? existingPhotos;
  final List<String>? newPhotoPaths;

  const UpdateGroupParams({
    required this.groupId,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.maxParticipants,
    this.existingPhotos,
    this.newPhotoPaths,
  });

  @override
  List<Object?> get props => [
        groupId,
        name,
        description,
        startDate,
        endDate,
        maxParticipants,
        existingPhotos,
        newPhotoPaths,
      ];
}

/// Use case for updating a group
class UpdateGroupUseCase implements UseCase<GroupEntity, UpdateGroupParams> {
  final GroupRepository repository;

  UpdateGroupUseCase(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call(UpdateGroupParams params) {
    return repository.updateGroup(
      groupId: params.groupId,
      name: params.name,
      description: params.description,
      startDate: params.startDate,
      endDate: params.endDate,
      maxParticipants: params.maxParticipants,
      existingPhotos: params.existingPhotos,
      newPhotoPaths: params.newPhotoPaths,
    );
  }
}
