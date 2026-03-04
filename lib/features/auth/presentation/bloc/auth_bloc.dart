import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// BLoC for handling authentication state and operations
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final UploadProfileImageUseCase? uploadProfileImageUseCase;
  final UpdateProfileUseCase? updateProfileUseCase;

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
    required this.changePasswordUseCase,
    required this.forgotPasswordUseCase,
    required this.resetPasswordUseCase,
    this.uploadProfileImageUseCase,
    this.updateProfileUseCase,
  }) : super(const AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<ResetPasswordEvent>(_onResetPassword);
    on<ClearAuthErrorEvent>(_onClearError);
    on<UploadProfileImageEvent>(_onUploadProfileImage);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  /// Check if user is authenticated on app start
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      return;
    }
    emit(const AuthLoading(message: 'Checking authentication...'));

    final result = await checkAuthStatusUseCase(const NoParams());

    await result.fold(
      (failure) async {
        if (state is! AuthAuthenticated) {
          emit(const AuthUnauthenticated());
        }
      },
      (isLoggedIn) async {
        if (isLoggedIn) {
          // Get user details if logged in
          final userResult = await getCurrentUserUseCase(const NoParams());
          userResult.fold(
            (failure) => emit(const AuthUnauthenticated()),
            (user) => emit(AuthAuthenticated(user)),
          );
        } else {
          if (state is! AuthAuthenticated) {
            emit(const AuthUnauthenticated());
          }
        }
      },
    );
  }

  /// Handle login event
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Logging in...'));

    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle registration event
  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Creating account...'));

    final result = await registerUseCase(RegisterParams(
      name: event.name,
      email: event.email,
      password: event.password,
      phone: event.phone,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (user) => emit(RegisterSuccess(user)),
    );
  }

  /// Handle logout event
  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Logging out...'));

    final result = await logoutUseCase(const NoParams());

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Get current user details
  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final existingUser = state is AuthAuthenticated
        ? (state as AuthAuthenticated).user
        : null;

    // Avoid losing authenticated state while refreshing user data
    if (existingUser == null) {
      emit(const AuthLoading());
    }

    final result = await getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) {
        if (failure is UnauthorizedFailure) {
          emit(const AuthUnauthenticated());
          return;
        }

        if (existingUser != null) {
          emit(AuthAuthenticated(existingUser));
          return;
        }

        emit(AuthError(
          message: failure.message,
          type: AuthErrorTypeExtension.fromMessage(failure.message),
        ));
      },
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle password change event
  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Changing password...'));

    final result = await changePasswordUseCase(ChangePasswordParams(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const PasswordChangeSuccess()),
    );
  }

  /// Handle forgot password event
  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Sending OTP...'));

    final result = await forgotPasswordUseCase(ForgotPasswordParams(
      email: event.email,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(ForgotPasswordSuccess(
        message: 'OTP sent to ${event.email}. Please check your email.',
        email: event.email,
      )),
    );
  }

  /// Handle password reset event
  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Resetting password...'));

    final result = await resetPasswordUseCase(ResetPasswordParams(
      email: event.email,
      otp: event.otp,
      newPassword: event.newPassword,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const PasswordResetSuccess()),
    );
  }

  /// Clear error state
  void _onClearError(
    ClearAuthErrorEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthInitial());
  }

  /// Handle profile image upload event
  Future<void> _onUploadProfileImage(
    UploadProfileImageEvent event,
    Emitter<AuthState> emit,
  ) async {
    print('🖼️ Starting profile image upload...');
    print('📁 File path: ${event.filePath}');

    if (uploadProfileImageUseCase == null) {
      print('❌ UPLOAD FAILED: uploadProfileImageUseCase is null');
      emit(const AuthError(
        message: 'Upload profile image feature is not available',
        type: AuthErrorType.unknown,
      ));
      return;
    }

    print('✓ UploadProfileImageUseCase is available');
    emit(const AuthLoading(message: 'Uploading profile image...'));

    final result = await uploadProfileImageUseCase!(
      UploadProfileImageParams(filePath: event.filePath),
    );

    result.fold(
      (failure) {
        print('❌ UPLOAD ERROR: ${failure.message}');
        emit(AuthError(
          message: failure.message,
          type: AuthErrorTypeExtension.fromMessage(failure.message),
        ));
      },
      (user) {
        print('✓ Profile image uploaded successfully');
        print('🖼️ New profile image URL: ${user.profileImageUrl}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  /// Handle profile update event
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (updateProfileUseCase == null) {
      emit(const AuthError(
        message: 'Update profile feature is not available',
        type: AuthErrorType.unknown,
      ));
      return;
    }

    emit(const AuthLoading(message: 'Updating profile...'));

    final result = await updateProfileUseCase!(UpdateProfileParams(
      name: event.name,
      phone: event.phone,
      bio: event.bio,
      ageGroup: event.ageGroup,
      hikerType: event.hikerType,
      emergencyContactName: event.emergencyContactName,
      emergencyContactPhone: event.emergencyContactPhone,
    ));

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        type: AuthErrorTypeExtension.fromMessage(failure.message),
      )),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
