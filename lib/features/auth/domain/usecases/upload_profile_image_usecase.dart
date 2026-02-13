import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UploadProfileImageUseCase implements UseCase<UserEntity, UploadProfileImageParams> {
  final AuthRepository repository;

  UploadProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UploadProfileImageParams params) async {
    return await repository.uploadProfileImage(filePath: params.filePath);
  }
}

class UploadProfileImageParams {
  final String filePath;

  const UploadProfileImageParams({required this.filePath});
}
