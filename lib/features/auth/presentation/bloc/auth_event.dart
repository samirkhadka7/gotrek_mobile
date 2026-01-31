abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String? fullName;
  final String? phone;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.phone,
  });
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class GetCurrentUserEvent extends AuthEvent {}