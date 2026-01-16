import 'package:gotrek/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gotrek/features/auth/data/models/user_hive_model.dart';
import 'package:gotrek/features/auth/domain/entities/user.dart';
import 'package:gotrek/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> registerUser(User user) async {
    final userHiveModel = UserHiveModel(
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
    );
    await localDataSource.registerUser(userHiveModel);
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    final userHiveModel = await localDataSource.loginUser(email, password);
    if (userHiveModel != null) {
      return User(
        id: userHiveModel.id,
        name: userHiveModel.name,
        email: userHiveModel.email,
        password: userHiveModel.password,
      );
    }
    return null;
  }

  @override
  Future<bool> isUserRegistered(String email) async {
    return await localDataSource.isUserRegistered(email);
  }
}