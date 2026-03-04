import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Base class for all auth states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during auth operations
class AuthLoading extends AuthState {
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// User is authenticated
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Auth operation failed
class AuthError extends AuthState {
  final String message;
  final AuthErrorType type;

  const AuthError({
    required this.message,
    this.type = AuthErrorType.unknown,
  });

  @override
  List<Object?> get props => [message, type];
}

/// Registration successful
class RegisterSuccess extends AuthState {
  final UserEntity user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

/// Password change successful
class PasswordChangeSuccess extends AuthState {
  const PasswordChangeSuccess();
}

/// Forgot password OTP sent to email
class ForgotPasswordSuccess extends AuthState {
  final String message;
  final String email;

  const ForgotPasswordSuccess({
    required this.message,
    required this.email,
  });

  @override
  List<Object?> get props => [message, email];
}

/// Password reset successful
class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

/// Types of auth errors for handling in UI
enum AuthErrorType {
  unknown,
  network,
  server,
  invalidCredentials,
  emailAlreadyExists,
  weakPassword,
  invalidEmail,
  userNotFound,
  tokenExpired,
  unauthorized,
}

/// Extension to map error messages to types
extension AuthErrorTypeExtension on AuthErrorType {
  static AuthErrorType fromMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('network') || lowerMessage.contains('connection')) {
      return AuthErrorType.network;
    }
    if (lowerMessage.contains('invalid') && lowerMessage.contains('credential')) {
      return AuthErrorType.invalidCredentials;
    }
    if (lowerMessage.contains('email') && lowerMessage.contains('exist')) {
      return AuthErrorType.emailAlreadyExists;
    }
    if (lowerMessage.contains('weak') && lowerMessage.contains('password')) {
      return AuthErrorType.weakPassword;
    }
    if (lowerMessage.contains('invalid') && lowerMessage.contains('email')) {
      return AuthErrorType.invalidEmail;
    }
    if (lowerMessage.contains('user') && lowerMessage.contains('not found')) {
      return AuthErrorType.userNotFound;
    }
    if (lowerMessage.contains('token') && lowerMessage.contains('expired')) {
      return AuthErrorType.tokenExpired;
    }
    if (lowerMessage.contains('unauthorized') || lowerMessage.contains('401')) {
      return AuthErrorType.unauthorized;
    }
    if (lowerMessage.contains('server') || lowerMessage.contains('500')) {
      return AuthErrorType.server;
    }

    return AuthErrorType.unknown;
  }
}
