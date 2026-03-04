import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/core/errors/failures.dart';
import 'package:gotrek/core/usecases/usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/login_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/register_usecase.dart';
import 'package:gotrek/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gotrek/features/auth/presentation/bloc/auth_event.dart';
import 'package:gotrek/features/auth/presentation/bloc/auth_state.dart';
import 'package:gotrek/features/group/domain/usecases/create_group.dart';
import 'package:gotrek/features/group/domain/usecases/request_join_group.dart';
import 'package:gotrek/features/group/presentation/bloc/group_bloc.dart';
import 'package:gotrek/features/group/presentation/bloc/group_event.dart';
import 'package:gotrek/features/group/presentation/bloc/group_state.dart';
import 'package:gotrek/features/trail/domain/usecases/get_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/get_trail_by_id_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/search_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/get_popular_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/join_trail_usecase.dart';
import 'package:gotrek/features/trail/presentation/bloc/trail_bloc.dart';
import 'package:gotrek/features/trail/presentation/bloc/trail_event.dart';
import 'package:gotrek/features/trail/presentation/bloc/trail_state.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_helpers.mocks.dart';

void main() {
  // ======================================================================
  // VIEWMODEL TEST 1: AuthBloc - Login Success
  // ======================================================================
  group('AuthBloc - Login', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        forgotPasswordUseCase: mockForgotPasswordUseCase,
        resetPasswordUseCase: mockResetPasswordUseCase,
      );
    });

    tearDown(() => authBloc.close());

    final tUser = createTestUser();

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] when login succeeds',
      build: () {
        when(mockLoginUseCase(any)).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        const AuthLoading(message: 'Logging in...'),
        AuthAuthenticated(tUser),
      ],
      verify: (_) {
        verify(mockLoginUseCase(any)).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockLoginUseCase(any)).thenAnswer(
          (_) async =>
              const Left(AuthFailure(message: 'Invalid credentials')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const LoginEvent(
        email: 'wrong@example.com',
        password: 'wrongpass',
      )),
      expect: () => [
        const AuthLoading(message: 'Logging in...'),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Invalid credentials'),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 2: AuthBloc - Register
  // ======================================================================
  group('AuthBloc - Register', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        forgotPasswordUseCase: mockForgotPasswordUseCase,
        resetPasswordUseCase: mockResetPasswordUseCase,
      );
    });

    tearDown(() => authBloc.close());

    final tUser = createTestUser(name: 'New User');

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, RegisterSuccess] when register succeeds',
      build: () {
        when(mockRegisterUseCase(any)).thenAnswer((_) async => Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterEvent(
        name: 'New User',
        email: 'new@example.com',
        password: 'password123',
        phone: '9800000000',
      )),
      expect: () => [
        const AuthLoading(message: 'Creating account...'),
        RegisterSuccess(tUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when register fails',
      build: () {
        when(mockRegisterUseCase(any)).thenAnswer(
          (_) async =>
              const Left(DuplicateFailure(message: 'Email already exists')),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(const RegisterEvent(
        name: 'New User',
        email: 'existing@example.com',
        password: 'password123',
        phone: '9800000000',
      )),
      expect: () => [
        const AuthLoading(message: 'Creating account...'),
        isA<AuthError>()
            .having((e) => e.message, 'message', 'Email already exists'),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 3: AuthBloc - Logout
  // ======================================================================
  group('AuthBloc - Logout', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        forgotPasswordUseCase: mockForgotPasswordUseCase,
        resetPasswordUseCase: mockResetPasswordUseCase,
      );
    });

    tearDown(() => authBloc.close());

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout succeeds',
      build: () {
        when(mockLogoutUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const LogoutEvent()),
      expect: () => [
        const AuthLoading(message: 'Logging out...'),
        const AuthUnauthenticated(),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 4: AuthBloc - Change Password
  // ======================================================================
  group('AuthBloc - Change Password', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        forgotPasswordUseCase: mockForgotPasswordUseCase,
        resetPasswordUseCase: mockResetPasswordUseCase,
      );
    });

    tearDown(() => authBloc.close());

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, PasswordChangeSuccess] when password change succeeds',
      build: () {
        when(mockChangePasswordUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const ChangePasswordEvent(
        currentPassword: 'oldPass',
        newPassword: 'newPass',
      )),
      expect: () => [
        const AuthLoading(message: 'Changing password...'),
        const PasswordChangeSuccess(),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 5: AuthBloc - Forgot Password
  // ======================================================================
  group('AuthBloc - Forgot Password', () {
    late AuthBloc authBloc;
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
    late MockChangePasswordUseCase mockChangePasswordUseCase;
    late MockForgotPasswordUseCase mockForgotPasswordUseCase;
    late MockResetPasswordUseCase mockResetPasswordUseCase;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
      mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
      mockChangePasswordUseCase = MockChangePasswordUseCase();
      mockForgotPasswordUseCase = MockForgotPasswordUseCase();
      mockResetPasswordUseCase = MockResetPasswordUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
        changePasswordUseCase: mockChangePasswordUseCase,
        forgotPasswordUseCase: mockForgotPasswordUseCase,
        resetPasswordUseCase: mockResetPasswordUseCase,
      );
    });

    tearDown(() => authBloc.close());

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, ForgotPasswordSuccess] when forgot password succeeds',
      build: () {
        when(mockForgotPasswordUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) =>
          bloc.add(const ForgotPasswordEvent(email: 'test@example.com')),
      expect: () => [
        const AuthLoading(message: 'Sending OTP...'),
        const ForgotPasswordSuccess(
          message:
              'OTP sent to test@example.com. Please check your email.',
          email: 'test@example.com',
        ),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 6: TrailBloc - Load Trails
  // ======================================================================
  group('TrailBloc - Load Trails', () {
    late TrailBloc trailBloc;
    late MockGetTrailsUseCase mockGetTrailsUseCase;
    late MockGetTrailByIdUseCase mockGetTrailByIdUseCase;
    late MockSearchTrailsUseCase mockSearchTrailsUseCase;
    late MockGetPopularTrailsUseCase mockGetPopularTrailsUseCase;
    late MockJoinTrailUseCase mockJoinTrailUseCase;
    late MockCompleteTrailUseCase mockCompleteTrailUseCase;
    late MockTrailRepository mockTrailRepository;

    setUp(() {
      mockGetTrailsUseCase = MockGetTrailsUseCase();
      mockGetTrailByIdUseCase = MockGetTrailByIdUseCase();
      mockSearchTrailsUseCase = MockSearchTrailsUseCase();
      mockGetPopularTrailsUseCase = MockGetPopularTrailsUseCase();
      mockJoinTrailUseCase = MockJoinTrailUseCase();
      mockCompleteTrailUseCase = MockCompleteTrailUseCase();
      mockTrailRepository = MockTrailRepository();

      trailBloc = TrailBloc(
        getTrailsUseCase: mockGetTrailsUseCase,
        getTrailByIdUseCase: mockGetTrailByIdUseCase,
        searchTrailsUseCase: mockSearchTrailsUseCase,
        getPopularTrailsUseCase: mockGetPopularTrailsUseCase,
        joinTrailUseCase: mockJoinTrailUseCase,
        completeTrailUseCase: mockCompleteTrailUseCase,
        trailRepository: mockTrailRepository,
      );
    });

    tearDown(() => trailBloc.close());

    final tTrails = [
      createTestTrail(id: 'trail-1', name: 'Annapurna BC'),
      createTestTrail(id: 'trail-2', name: 'Everest BC'),
    ];

    blocTest<TrailBloc, TrailState>(
      'emits [TrailsLoading, TrailsLoaded] when loading trails succeeds',
      build: () {
        when(mockGetTrailsUseCase(any))
            .thenAnswer((_) async => Right(tTrails));
        return trailBloc;
      },
      act: (bloc) => bloc.add(const LoadTrailsEvent()),
      expect: () => [
        const TrailsLoading(message: 'Loading trails...'),
        TrailsLoaded(trails: tTrails),
      ],
    );

    blocTest<TrailBloc, TrailState>(
      'emits [TrailsLoading, TrailError] when loading trails fails',
      build: () {
        when(mockGetTrailsUseCase(any)).thenAnswer(
          (_) async => const Left(NetworkFailure()),
        );
        return trailBloc;
      },
      act: (bloc) => bloc.add(const LoadTrailsEvent()),
      expect: () => [
        const TrailsLoading(message: 'Loading trails...'),
        isA<TrailError>(),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 7: TrailBloc - Search Trails
  // ======================================================================
  group('TrailBloc - Search Trails', () {
    late TrailBloc trailBloc;
    late MockGetTrailsUseCase mockGetTrailsUseCase;
    late MockGetTrailByIdUseCase mockGetTrailByIdUseCase;
    late MockSearchTrailsUseCase mockSearchTrailsUseCase;
    late MockGetPopularTrailsUseCase mockGetPopularTrailsUseCase;
    late MockJoinTrailUseCase mockJoinTrailUseCase;
    late MockCompleteTrailUseCase mockCompleteTrailUseCase;
    late MockTrailRepository mockTrailRepository;

    setUp(() {
      mockGetTrailsUseCase = MockGetTrailsUseCase();
      mockGetTrailByIdUseCase = MockGetTrailByIdUseCase();
      mockSearchTrailsUseCase = MockSearchTrailsUseCase();
      mockGetPopularTrailsUseCase = MockGetPopularTrailsUseCase();
      mockJoinTrailUseCase = MockJoinTrailUseCase();
      mockCompleteTrailUseCase = MockCompleteTrailUseCase();
      mockTrailRepository = MockTrailRepository();

      trailBloc = TrailBloc(
        getTrailsUseCase: mockGetTrailsUseCase,
        getTrailByIdUseCase: mockGetTrailByIdUseCase,
        searchTrailsUseCase: mockSearchTrailsUseCase,
        getPopularTrailsUseCase: mockGetPopularTrailsUseCase,
        joinTrailUseCase: mockJoinTrailUseCase,
        completeTrailUseCase: mockCompleteTrailUseCase,
        trailRepository: mockTrailRepository,
      );
    });

    tearDown(() => trailBloc.close());

    final tTrails = [createTestTrail(name: 'Annapurna BC')];

    blocTest<TrailBloc, TrailState>(
      'emits [TrailsLoading, TrailSearchResults] when search succeeds',
      build: () {
        when(mockSearchTrailsUseCase(any))
            .thenAnswer((_) async => Right(tTrails));
        return trailBloc;
      },
      act: (bloc) =>
          bloc.add(const SearchTrailsEvent(query: 'Annapurna')),
      expect: () => [
        const TrailsLoading(message: 'Searching...'),
        TrailSearchResults(results: tTrails, query: 'Annapurna'),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 8: TrailBloc - Join Trail
  // ======================================================================
  group('TrailBloc - Join Trail', () {
    late TrailBloc trailBloc;
    late MockGetTrailsUseCase mockGetTrailsUseCase;
    late MockGetTrailByIdUseCase mockGetTrailByIdUseCase;
    late MockSearchTrailsUseCase mockSearchTrailsUseCase;
    late MockGetPopularTrailsUseCase mockGetPopularTrailsUseCase;
    late MockJoinTrailUseCase mockJoinTrailUseCase;
    late MockCompleteTrailUseCase mockCompleteTrailUseCase;
    late MockTrailRepository mockTrailRepository;

    setUp(() {
      mockGetTrailsUseCase = MockGetTrailsUseCase();
      mockGetTrailByIdUseCase = MockGetTrailByIdUseCase();
      mockSearchTrailsUseCase = MockSearchTrailsUseCase();
      mockGetPopularTrailsUseCase = MockGetPopularTrailsUseCase();
      mockJoinTrailUseCase = MockJoinTrailUseCase();
      mockCompleteTrailUseCase = MockCompleteTrailUseCase();
      mockTrailRepository = MockTrailRepository();

      trailBloc = TrailBloc(
        getTrailsUseCase: mockGetTrailsUseCase,
        getTrailByIdUseCase: mockGetTrailByIdUseCase,
        searchTrailsUseCase: mockSearchTrailsUseCase,
        getPopularTrailsUseCase: mockGetPopularTrailsUseCase,
        joinTrailUseCase: mockJoinTrailUseCase,
        completeTrailUseCase: mockCompleteTrailUseCase,
        trailRepository: mockTrailRepository,
      );
    });

    tearDown(() => trailBloc.close());

    blocTest<TrailBloc, TrailState>(
      'emits [TrailOperationInProgress, TrailOperationSuccess] when join succeeds',
      build: () {
        when(mockJoinTrailUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return trailBloc;
      },
      act: (bloc) => bloc.add(JoinTrailEvent(
        trailId: 'trail-1',
        startDate: DateTime(2024, 6, 15),
      )),
      expect: () => [
        const TrailOperationInProgress(operation: 'join', trailId: 'trail-1'),
        const TrailOperationSuccess(
          operation: 'join',
          message: 'Successfully joined the trail!',
        ),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 9: GroupBloc - Load Groups
  // ======================================================================
  group('GroupBloc - Load Groups', () {
    late GroupBloc groupBloc;
    late MockGetGroupsUseCase mockGetGroupsUseCase;
    late MockGetGroupByIdUseCase mockGetGroupByIdUseCase;
    late MockGetMyGroupsUseCase mockGetMyGroupsUseCase;
    late MockCreateGroupUseCase mockCreateGroupUseCase;
    late MockRequestJoinGroupUseCase mockRequestJoinGroupUseCase;
    late MockManageJoinRequestUseCase mockManageJoinRequestUseCase;
    late MockGetPendingRequestsUseCase mockGetPendingRequestsUseCase;
    late MockLeaveGroupUseCase mockLeaveGroupUseCase;
    late MockUpdateGroupUseCase mockUpdateGroupUseCase;

    setUp(() {
      mockGetGroupsUseCase = MockGetGroupsUseCase();
      mockGetGroupByIdUseCase = MockGetGroupByIdUseCase();
      mockGetMyGroupsUseCase = MockGetMyGroupsUseCase();
      mockCreateGroupUseCase = MockCreateGroupUseCase();
      mockRequestJoinGroupUseCase = MockRequestJoinGroupUseCase();
      mockManageJoinRequestUseCase = MockManageJoinRequestUseCase();
      mockGetPendingRequestsUseCase = MockGetPendingRequestsUseCase();
      mockLeaveGroupUseCase = MockLeaveGroupUseCase();
      mockUpdateGroupUseCase = MockUpdateGroupUseCase();

      groupBloc = GroupBloc(
        getGroupsUseCase: mockGetGroupsUseCase,
        getGroupByIdUseCase: mockGetGroupByIdUseCase,
        getMyGroupsUseCase: mockGetMyGroupsUseCase,
        createGroupUseCase: mockCreateGroupUseCase,
        requestJoinGroupUseCase: mockRequestJoinGroupUseCase,
        manageJoinRequestUseCase: mockManageJoinRequestUseCase,
        getPendingRequestsUseCase: mockGetPendingRequestsUseCase,
        leaveGroupUseCase: mockLeaveGroupUseCase,
        updateGroupUseCase: mockUpdateGroupUseCase,
      );
    });

    tearDown(() => groupBloc.close());

    final tGroups = [
      createTestGroup(id: 'group-1', name: 'ABC Team'),
      createTestGroup(id: 'group-2', name: 'EBC Team'),
    ];

    blocTest<GroupBloc, GroupState>(
      'emits [GroupsLoading, GroupsLoaded] when loading groups succeeds',
      build: () {
        when(mockGetGroupsUseCase(any))
            .thenAnswer((_) async => Right(tGroups));
        return groupBloc;
      },
      act: (bloc) => bloc.add(const LoadGroupsEvent()),
      expect: () => [
        const GroupsLoading(),
        GroupsLoaded(groups: tGroups),
      ],
    );

    blocTest<GroupBloc, GroupState>(
      'emits [GroupsLoading, GroupError] when loading groups fails',
      build: () {
        when(mockGetGroupsUseCase(any)).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Server error')),
        );
        return groupBloc;
      },
      act: (bloc) => bloc.add(const LoadGroupsEvent()),
      expect: () => [
        const GroupsLoading(),
        isA<GroupError>().having((e) => e.message, 'message', 'Server error'),
      ],
    );
  });

  // ======================================================================
  // VIEWMODEL TEST 10: GroupBloc - Leave Group
  // ======================================================================
  group('GroupBloc - Leave Group', () {
    late GroupBloc groupBloc;
    late MockGetGroupsUseCase mockGetGroupsUseCase;
    late MockGetGroupByIdUseCase mockGetGroupByIdUseCase;
    late MockGetMyGroupsUseCase mockGetMyGroupsUseCase;
    late MockCreateGroupUseCase mockCreateGroupUseCase;
    late MockRequestJoinGroupUseCase mockRequestJoinGroupUseCase;
    late MockManageJoinRequestUseCase mockManageJoinRequestUseCase;
    late MockGetPendingRequestsUseCase mockGetPendingRequestsUseCase;
    late MockLeaveGroupUseCase mockLeaveGroupUseCase;
    late MockUpdateGroupUseCase mockUpdateGroupUseCase;

    setUp(() {
      mockGetGroupsUseCase = MockGetGroupsUseCase();
      mockGetGroupByIdUseCase = MockGetGroupByIdUseCase();
      mockGetMyGroupsUseCase = MockGetMyGroupsUseCase();
      mockCreateGroupUseCase = MockCreateGroupUseCase();
      mockRequestJoinGroupUseCase = MockRequestJoinGroupUseCase();
      mockManageJoinRequestUseCase = MockManageJoinRequestUseCase();
      mockGetPendingRequestsUseCase = MockGetPendingRequestsUseCase();
      mockLeaveGroupUseCase = MockLeaveGroupUseCase();
      mockUpdateGroupUseCase = MockUpdateGroupUseCase();

      groupBloc = GroupBloc(
        getGroupsUseCase: mockGetGroupsUseCase,
        getGroupByIdUseCase: mockGetGroupByIdUseCase,
        getMyGroupsUseCase: mockGetMyGroupsUseCase,
        createGroupUseCase: mockCreateGroupUseCase,
        requestJoinGroupUseCase: mockRequestJoinGroupUseCase,
        manageJoinRequestUseCase: mockManageJoinRequestUseCase,
        getPendingRequestsUseCase: mockGetPendingRequestsUseCase,
        leaveGroupUseCase: mockLeaveGroupUseCase,
        updateGroupUseCase: mockUpdateGroupUseCase,
      );
    });

    tearDown(() => groupBloc.close());

    blocTest<GroupBloc, GroupState>(
      'emits [GroupActionInProgress, GroupLeft] when leaving group succeeds',
      build: () {
        when(mockLeaveGroupUseCase(any))
            .thenAnswer((_) async => const Right(null));
        return groupBloc;
      },
      act: (bloc) =>
          bloc.add(const LeaveGroupEvent(groupId: 'group-1')),
      expect: () => [
        const GroupActionInProgress(action: 'Leaving group'),
        const GroupLeft(groupId: 'group-1'),
      ],
    );

    blocTest<GroupBloc, GroupState>(
      'emits [GroupActionInProgress, GroupError] when leaving group fails',
      build: () {
        when(mockLeaveGroupUseCase(any)).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'Cannot leave group')),
        );
        return groupBloc;
      },
      act: (bloc) =>
          bloc.add(const LeaveGroupEvent(groupId: 'group-1')),
      expect: () => [
        const GroupActionInProgress(action: 'Leaving group'),
        isA<GroupError>()
            .having((e) => e.message, 'message', 'Cannot leave group'),
      ],
    );
  });
}
