import 'package:equatable/equatable.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Event to login user with email and password
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event to register a new user
class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  List<Object?> get props => [name, email, password, phone];
}

/// Event to logout user
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

/// Event to get current user details
class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}

/// Event to change password
class ChangePasswordEvent extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Event to request password reset
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to reset password with OTP
class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, otp, newPassword];
}

/// Event to clear any error state
class ClearAuthErrorEvent extends AuthEvent {
  const ClearAuthErrorEvent();
}

/// Event to upload profile image
class UploadProfileImageEvent extends AuthEvent {
  final String filePath;

  const UploadProfileImageEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

/// Event to update user profile
class UpdateProfileEvent extends AuthEvent {
  final String? name;
  final String? phone;
  final String? bio;
  final String? ageGroup;
  final String? hikerType;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  const UpdateProfileEvent({
    this.name,
    this.phone,
    this.bio,
    this.ageGroup,
    this.hikerType,
    this.emergencyContactName,
    this.emergencyContactPhone,
  });

  @override
  List<Object?> get props => [
        name,
        phone,
        bio,
        ageGroup,
        hikerType,
        emergencyContactName,
        emergencyContactPhone,
      ];
}
