import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_user_repository.dart';

/// Use case for deleting user
class DeleteUserUseCase implements UseCase<void, String> {
  final AdminUserRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repository.deleteUser(userId);
  }
}
