import 'package:gotrek/features/auth/domain/entities/user.dart';
import 'package:gotrek/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<void> call(User user) async {
    return await repository.registerUser(user);
  }
}