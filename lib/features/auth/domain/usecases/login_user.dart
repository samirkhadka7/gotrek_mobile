import 'package:gotrek/features/auth/domain/entities/user.dart';
import 'package:gotrek/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User?> call(String email, String password) async {
    return await repository.loginUser(email, password);
  }
}