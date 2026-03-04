import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../core/constants/storage_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/network_info.dart';
import '../core/services/barometer_service.dart';
import '../core/services/biometric_service.dart';
import '../core/services/gps_tracking_service.dart';
import '../core/services/hive_service.dart';
import '../core/services/secure_storage_service.dart';
import '../core/services/socket_service.dart';
import '../core/services/profile_sync_service.dart';

// Auth Feature
import '../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../features/auth/data/datasources/remote/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/change_password_usecase.dart';
import '../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/reset_password_usecase.dart';
import '../features/auth/domain/usecases/upload_profile_image_usecase.dart';
import '../features/auth/domain/usecases/update_profile_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Trail Feature
import '../features/trail/data/datasources/local/trail_local_datasource.dart';
import '../features/trail/data/datasources/remote/trail_remote_datasource.dart';
import '../features/trail/data/repositories/trail_repository_impl.dart';
import '../features/trail/domain/repositories/trail_repository.dart';
import '../features/trail/domain/usecases/complete_trail_usecase.dart';
import '../features/trail/domain/usecases/get_popular_trails_usecase.dart';
import '../features/trail/domain/usecases/get_trail_by_id_usecase.dart';
import '../features/trail/domain/usecases/get_trails_usecase.dart';
import '../features/trail/domain/usecases/join_trail_usecase.dart';
import '../features/trail/domain/usecases/search_trails_usecase.dart';
import '../features/trail/presentation/bloc/trail_bloc.dart';

// Admin Feature
import '../features/admin/data/datasources/admin_user_remote_datasource.dart';
import '../features/admin/data/datasources/admin_trail_remote_datasource.dart';
import '../features/admin/data/repositories/admin_user_repository_impl.dart';
import '../features/admin/data/repositories/admin_trail_repository_impl.dart';
import '../features/admin/domain/repositories/admin_user_repository.dart';
import '../features/admin/domain/repositories/admin_trail_repository.dart';
import '../features/admin/domain/usecases/get_all_users.dart';
import '../features/admin/domain/usecases/update_user_role.dart';
import '../features/admin/domain/usecases/delete_user.dart';
import '../features/admin/domain/usecases/get_all_trails.dart';
import '../features/admin/domain/usecases/create_trail.dart';
import '../features/admin/domain/usecases/update_trail.dart';
import '../features/admin/domain/usecases/delete_trail.dart';
import '../features/admin/presentation/bloc/admin_user_bloc.dart';
import '../features/admin/presentation/bloc/admin_trail_bloc.dart';

// Chatbot Feature
import '../features/chatbot/data/datasources/chatbot_remote_datasource.dart';
import '../features/chatbot/data/repositories/chatbot_repository_impl.dart';
import '../features/chatbot/domain/repositories/chatbot_repository.dart';
import '../features/chatbot/domain/usecases/send_chatbot_query.dart';
import '../features/chatbot/presentation/bloc/chatbot_bloc.dart';

// Checklist Feature
import '../features/checklist/data/datasources/checklist_local_datasource.dart';
import '../features/checklist/data/datasources/checklist_remote_datasource.dart';
import '../features/checklist/data/repositories/checklist_repository_impl.dart';
import '../features/checklist/domain/repositories/checklist_repository.dart';
import '../features/checklist/domain/usecases/clear_checklist.dart';
import '../features/checklist/domain/usecases/generate_checklist.dart';
import '../features/checklist/domain/usecases/get_my_checklist.dart';
import '../features/checklist/domain/usecases/save_checklist.dart';
import '../features/checklist/domain/usecases/update_checklist_item.dart';
import '../features/checklist/presentation/bloc/checklist_bloc.dart';

// Activity Feature
import '../features/activity/data/datasources/activity_remote_datasource.dart';
import '../features/activity/data/repositories/activity_repository_impl.dart';
import '../features/activity/domain/repositories/activity_repository.dart';
import '../features/activity/domain/usecases/get_recent_activities.dart';
import '../features/activity/presentation/bloc/activity_bloc.dart';

// Analytics Feature
import '../features/analytics/data/datasources/analytics_remote_datasource.dart';
import '../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../features/analytics/domain/repositories/analytics_repository.dart';
import '../features/analytics/domain/usecases/get_analytics.dart';
import '../features/analytics/presentation/bloc/analytics_bloc.dart';

// Steps Feature
import '../features/steps/data/datasources/steps_local_datasource.dart';
import '../features/steps/data/datasources/steps_remote_datasource.dart';
import '../features/steps/data/repositories/steps_repository_impl.dart';
import '../features/steps/domain/repositories/steps_repository.dart';
import '../features/steps/domain/usecases/get_steps_stats.dart';
import '../features/steps/domain/usecases/get_today_steps.dart';
import '../features/steps/domain/usecases/log_steps.dart';
import '../features/steps/presentation/bloc/steps_bloc.dart';

// Group Feature
import '../features/group/data/datasources/local/group_local_datasource.dart';
import '../features/group/data/datasources/remote/group_remote_datasource.dart';
import '../features/group/data/models/group_model.dart';
import '../features/group/data/repositories/group_repository_impl.dart';
import '../features/group/domain/repositories/group_repository.dart';
import '../features/group/domain/usecases/create_group.dart';
import '../features/group/domain/usecases/get_group_by_id.dart';
import '../features/group/domain/usecases/get_groups.dart';
import '../features/group/domain/usecases/get_my_groups.dart';
import '../features/group/domain/usecases/get_pending_requests.dart';
import '../features/group/domain/usecases/leave_group.dart';
import '../features/group/domain/usecases/manage_join_request.dart';
import '../features/group/domain/usecases/request_join_group.dart';
import '../features/group/domain/usecases/update_group.dart';
import '../features/group/presentation/bloc/group_bloc.dart';

// Payment Feature
import '../features/payment/data/datasources/payment_remote_datasource.dart';
import '../features/payment/data/repositories/payment_repository_impl.dart';
import '../features/payment/domain/repositories/payment_repository.dart';
import '../features/payment/domain/usecases/initialize_payment.dart';
import '../features/payment/presentation/bloc/payment_bloc.dart';

// Messaging Feature
import '../features/messaging/data/datasources/message_remote_datasource.dart';
import '../features/messaging/data/repositories/message_repository_impl.dart';
import '../features/messaging/domain/repositories/message_repository.dart';
import '../features/messaging/domain/usecases/get_messages_by_group.dart';
import '../features/messaging/presentation/bloc/message_bloc.dart';

import '../features/settings/data/repositories/theme_repository.dart';
import '../features/settings/presentation/bloc/theme_bloc.dart';
/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // ==================== Core ====================

  // External
  sl.registerLazySingleton(() => Connectivity());

  // Services
  sl.registerLazySingleton(() => SecureStorageService());
  sl.registerLazySingleton(() => HiveService());
  sl.registerLazySingleton(() => SocketService());

  // Network
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: sl()),
  );

  sl.registerLazySingleton(
    () => ApiClient(networkInfo: sl()),
  );

  // Profile Sync Service (registered early, wired after auth feature init)
  sl.registerLazySingleton(
    () => ProfileSyncService(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ==================== Features ====================

  // Auth Feature
  await _initAuthFeature();

  // Trail Feature
  await _initTrailFeature();

  // Group Feature
  await _initGroupFeature();

  // Chatbot Feature
  await _initChatbotFeature();

  // Checklist Feature
  await _initChecklistFeature();

  // Steps Feature
  await _initStepsFeature();

  // Payment Feature
  await _initPaymentFeature();

  // Activity Feature
  await _initActivityFeature();

  // Analytics Feature
  await _initAnalyticsFeature();

  // Admin Feature
  await _initAdminFeature();

  // Messaging Feature
  await _initMessagingFeature();

  // Settings Feature
  await _initSettingsFeature();
}
/// Initialize Auth feature dependencies
Future<void> _initAuthFeature() async {
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
      profileSyncService: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // BLoC
  sl.registerLazySingleton(
    () => AuthBloc(
      registerUseCase: sl(),
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      checkAuthStatusUseCase: sl(),
      changePasswordUseCase: sl(),
      forgotPasswordUseCase: sl(),
      resetPasswordUseCase: sl(),
      uploadProfileImageUseCase: sl(),
      updateProfileUseCase: sl(),
    ),
  );
}

/// Initialize Trail feature dependencies
Future<void> _initTrailFeature() async {
  // Data Sources
  sl.registerLazySingleton<TrailRemoteDataSource>(
    () => TrailRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<TrailLocalDataSource>(
    () => TrailLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<TrailRepository>(
    () => TrailRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTrailsUseCase(sl()));
  sl.registerLazySingleton(() => GetTrailByIdUseCase(sl()));
  sl.registerLazySingleton(() => SearchTrailsUseCase(sl()));
  sl.registerLazySingleton(() => GetPopularTrailsUseCase(sl()));
  sl.registerLazySingleton(() => JoinTrailUseCase(sl()));
  sl.registerLazySingleton(() => CompleteTrailUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => TrailBloc(
      getTrailsUseCase: sl(),
      getTrailByIdUseCase: sl(),
      searchTrailsUseCase: sl(),
      getPopularTrailsUseCase: sl(),
      joinTrailUseCase: sl(),
      completeTrailUseCase: sl(),
      trailRepository: sl(),
    ),
  );
}

/// Initialize Group feature dependencies
Future<void> _initGroupFeature() async {
  // Data Sources
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(apiClient: sl()),
  );

  sl.registerLazySingleton<GroupLocalDataSource>(
    () => GroupLocalDataSourceImpl(
      groupBox: Hive.box<GroupModel>(StorageConstants.groupBox),
      cacheBox: Hive.box(StorageConstants.cacheBox),
    ),
  );

  // Repository
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetGroupsUseCase(sl()));
  sl.registerLazySingleton(() => GetGroupByIdUseCase(sl()));
  sl.registerLazySingleton(() => GetMyGroupsUseCase(sl()));
  sl.registerLazySingleton(() => CreateGroupUseCase(sl()));
  sl.registerLazySingleton(() => UpdateGroupUseCase(sl()));
  sl.registerLazySingleton(() => RequestJoinGroupUseCase(sl()));
  sl.registerLazySingleton(() => ManageJoinRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetPendingRequestsUseCase(sl()));
  sl.registerLazySingleton(() => LeaveGroupUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => GroupBloc(
      getGroupsUseCase: sl(),
      getGroupByIdUseCase: sl(),
      getMyGroupsUseCase: sl(),
      createGroupUseCase: sl(),
      requestJoinGroupUseCase: sl(),
      manageJoinRequestUseCase: sl(),
      getPendingRequestsUseCase: sl(),
      leaveGroupUseCase: sl(),
      updateGroupUseCase: sl(),
    ),
  );
}

/// Initialize Chatbot feature dependencies
Future<void> _initChatbotFeature() async {
  // Data Sources
  sl.registerLazySingleton<ChatbotRemoteDataSource>(
    () => ChatbotRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ChatbotRepository>(
    () => ChatbotRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => SendChatbotQueryUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => ChatbotBloc(sendChatbotQueryUseCase: sl()),
  );
}

/// Initialize Checklist feature dependencies
Future<void> _initChecklistFeature() async {
  // Data Sources
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
    () => ChecklistRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ChecklistLocalDataSource>(
    () => ChecklistLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GenerateChecklistUseCase(sl()));
  sl.registerLazySingleton(() => GetMyChecklistUseCase(sl()));
  sl.registerLazySingleton(() => SaveChecklistUseCase(sl()));
  sl.registerLazySingleton(() => UpdateChecklistItemUseCase(sl()));
  sl.registerLazySingleton(() => ClearChecklistUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => ChecklistBloc(
      generateChecklistUseCase: sl(),
      getMyChecklistUseCase: sl(),
      saveChecklistUseCase: sl(),
      updateChecklistItemUseCase: sl(),
      clearChecklistUseCase: sl(),
    ),
  );
}

/// Initialize Steps feature dependencies
Future<void> _initStepsFeature() async {
  // Data Sources
  sl.registerLazySingleton<StepsRemoteDataSource>(
    () => StepsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<StepsLocalDataSource>(
    () => StepsLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<StepsRepository>(
    () => StepsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetTodayStepsUseCase(sl()));
  sl.registerLazySingleton(() => LogStepsUseCase(sl()));
  sl.registerLazySingleton(() => GetWeeklyStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetMonthlyStatsUseCase(sl()));

  // Biometric Service
  sl.registerLazySingleton(() => BiometricService());

  // Barometer Service
  sl.registerLazySingleton(() => BarometerService());

  // GPS Tracking Service
  sl.registerLazySingleton(() => GpsTrackingService(barometerService: sl()));

  // BLoC
  sl.registerFactory(
    () => StepsBloc(
      getTodayStepsUseCase: sl(),
      logStepsUseCase: sl(),
      getWeeklyStatsUseCase: sl(),
      getMonthlyStatsUseCase: sl(),
      gpsTrackingService: sl(),
      localDataSource: sl(),
    ),
  );
}

/// Initialize Payment feature dependencies
Future<void> _initPaymentFeature() async {
  // Data Sources
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => InitializeESewaPaymentUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => PaymentBloc(
      initializePaymentUseCase: sl(),
      repository: sl(),
    ),
  );
}

/// Initialize Activity feature dependencies
Future<void> _initActivityFeature() async {
  // Data Sources
  sl.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetRecentActivitiesUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => ActivityBloc(getRecentActivitiesUseCase: sl()),
  );
}

/// Initialize Analytics feature dependencies
Future<void> _initAnalyticsFeature() async {
  // Data Sources
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => AnalyticsRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAnalyticsUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AnalyticsBloc(getAnalyticsUseCase: sl()),
  );
}

/// Initialize Admin feature dependencies
Future<void> _initAdminFeature() async {
  // ==================== Admin User Feature ====================

  // Data Sources
  sl.registerLazySingleton<AdminUserRemoteDataSource>(
    () => AdminUserRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdminUserRepository>(
    () => AdminUserRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserRoleUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AdminUserBloc(
      getAllUsersUseCase: sl(),
      updateUserRoleUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );

  // ==================== Admin Trail Feature ====================

  // Data Sources
  sl.registerLazySingleton<AdminTrailRemoteDataSource>(
    () => AdminTrailRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AdminTrailRepository>(
    () => AdminTrailRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllTrailsUseCase(sl()));
  sl.registerLazySingleton(() => CreateTrailUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTrailUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTrailUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AdminTrailBloc(
      getAllTrailsUseCase: sl(),
      createTrailUseCase: sl(),
      updateTrailUseCase: sl(),
      deleteTrailUseCase: sl(),
    ),
  );
}

/// Initialize Messaging feature dependencies
Future<void> _initMessagingFeature() async {
  // Data Sources
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(apiClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetMessagesByGroup(sl()));

  // BLoC
  sl.registerFactory(
    () => MessageBloc(
      getMessagesByGroup: sl(),
      socketService: sl(),
    ),
  );
}

/// Initialize Settings feature dependencies
Future<void> _initSettingsFeature() async {
  // Initialize theme box
  await ThemeRepository.initializeThemeBox();

  // Repository
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepository(),
  );

  // BLoC
  sl.registerFactory(
    () => ThemeBloc(themeRepository: sl()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
