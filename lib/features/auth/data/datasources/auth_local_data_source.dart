import 'package:hive/hive.dart';
import 'package:gotrek/features/auth/data/models/user_hive_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserHiveModel user);
  Future<UserHiveModel?> loginUser(String email, String password);
  Future<bool> isUserRegistered(String email);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserHiveModel> userBox;

  AuthLocalDataSourceImpl(this.userBox);

  @override
  Future<void> registerUser(UserHiveModel user) async {
    await userBox.put(user.email, user);
  }

  @override
  Future<UserHiveModel?> loginUser(String email, String password) async {
    final user = userBox.get(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }

  @override
  Future<bool> isUserRegistered(String email) async {
    return userBox.containsKey(email);
  }
}
