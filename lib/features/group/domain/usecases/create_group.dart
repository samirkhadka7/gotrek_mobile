import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/group_entity.dart';
import '../repositories/group_repository.dart';

/// Parameters for creating a group
class CreateGroupParams extends Equatable {
  final String name;
  final String? description;
  final String trailId;
  final DateTime startDate;
  final DateTime? endDate;
  final int maxParticipants;
  final MeetingPoint? meetingPoint;
  final String leaderId;
  final List<File> photos;

  const CreateGroupParams({
    required this.name,
    this.description,
    required this.trailId,
    required this.startDate,
    this.endDate,
    required this.maxParticipants,
    this.meetingPoint,
    required this.leaderId,
    this.photos = const [],
  });

  @override
  List<Object?> get props => [
        name,
        description,
        trailId,
        startDate,
        endDate,
        maxParticipants,
        meetingPoint,
      leaderId,
        photos,
      ];
}

/// Use case for creating a new group
class CreateGroupUseCase implements UseCase<GroupEntity, CreateGroupParams> {
  final GroupRepository repository;

  CreateGroupUseCase(this.repository);

  @override
  Future<Either<Failure, GroupEntity>> call(CreateGroupParams params) async {
    return await repository.createGroup(
      name: params.name,
      description: params.description,
      trailId: params.trailId,
      startDate: params.startDate,
      endDate: params.endDate,
      maxParticipants: params.maxParticipants,
      meetingPoint: params.meetingPoint,
      leaderId: params.leaderId,
      photos: params.photos,
    );
  }
}
