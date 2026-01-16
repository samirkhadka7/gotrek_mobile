import 'package:gotrek/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<void> registerUser(User user);
  Future<User?> loginUser(String email, String password);
  Future<bool> isUserRegistered(String email);
}