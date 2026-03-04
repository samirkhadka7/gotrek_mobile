/// Auth Feature barrel export
///
/// This file exports all public APIs for the auth feature
/// following Clean Architecture principles.

// Domain Layer
export 'domain/entities/user_entity.dart';
export 'domain/repositories/auth_repository.dart';
export 'domain/usecases/check_auth_status_usecase.dart';
export 'domain/usecases/change_password_usecase.dart';
export 'domain/usecases/forgot_password_usecase.dart';
export 'domain/usecases/get_current_user_usecase.dart';
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/logout_usecase.dart';
export 'domain/usecases/register_usecase.dart';
export 'domain/usecases/reset_password_usecase.dart';

// Data Layer
export 'data/models/user_model.dart';
export 'data/datasources/local/auth_local_datasource.dart';
export 'data/datasources/remote/auth_remote_datasource.dart';
export 'data/repositories/auth_repository_impl.dart';

// Presentation Layer
export 'presentation/bloc/bloc.dart';
export 'presentation/pages/pages.dart';
export 'presentation/widgets/widgets.dart';
