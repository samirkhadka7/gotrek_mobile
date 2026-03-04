import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_user_repository.dart';

/// Use case for getting all users
class GetAllUsersUseCase implements UseCase<UserListResult, GetAllUsersParams> {
  final AdminUserRepository repository;

  GetAllUsersUseCase(this.repository);

  @override
  Future<Either<Failure, UserListResult>> call(GetAllUsersParams params) {
    return repository.getAllUsers(
      page: params.page,
      limit: params.limit,
      search: params.search,
    );
  }
}

class GetAllUsersParams extends Equatable {
  final int page;
  final int limit;
  final String? search;

  const GetAllUsersParams({
    this.page = 1,
    this.limit = 10,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}
