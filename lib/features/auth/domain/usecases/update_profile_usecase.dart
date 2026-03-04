import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for updating user profile
class UpdateProfileUseCase implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) {
    return repository.updateProfile(
      name: params.name,
      phone: params.phone,
      bio: params.bio,
      ageGroup: params.ageGroup,
      hikerType: params.hikerType,
      emergencyContactName: params.emergencyContactName,
      emergencyContactPhone: params.emergencyContactPhone,
    );
  }
}

/// Parameters for updating profile
class UpdateProfileParams extends Equatable {
  final String? name;
  final String? phone;
  final String? bio;
  final String? ageGroup;
  final String? hikerType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  const UpdateProfileParams({
    this.name,
    this.phone,
    this.bio,
    this.ageGroup,
    this.hikerType,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  @override
  List<Object?> get props => [
        name,
        phone,
        bio,
        ageGroup,
        hikerType,
        emergencyContactName,
        emergencyContactPhone,
      ];
}
