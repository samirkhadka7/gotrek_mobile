import 'package:gotrek/features/auth/domain/repositories/auth_repository.dart';

class IsUserRegistered {
  final AuthRepository repository;

  IsUserRegistered(this.repository);

  Future<bool> call(String email) async {
    return await repository.isUserRegistered(email);
  }
}