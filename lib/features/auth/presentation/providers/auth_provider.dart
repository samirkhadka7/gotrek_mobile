import 'package:flutter/material.dart';
import 'package:gotrek/features/auth/domain/entities/user.dart';
import 'package:gotrek/features/auth/domain/usecases/register_user.dart';
import 'package:gotrek/features/auth/domain/usecases/login_user.dart';
import 'package:gotrek/features/auth/domain/usecases/is_user_registered.dart';

class AuthProvider with ChangeNotifier {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final IsUserRegistered isUserRegistered;

  AuthProvider({
    required this.registerUser,
    required this.loginUser,
    required this.isUserRegistered,
  });

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
      );

      await registerUser(user);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await loginUser(email, password);
      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> checkUserRegistered(String email) async {
    try {
      return await isUserRegistered(email);
    } catch (e) {
      return false;
    }
  }
}