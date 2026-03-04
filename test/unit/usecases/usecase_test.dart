import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/core/errors/failures.dart';
import 'package:gotrek/core/usecases/usecase.dart';
import 'package:gotrek/features/auth/domain/entities/user_entity.dart';
import 'package:gotrek/features/auth/domain/usecases/login_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/signup_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/logout_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:gotrek/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:gotrek/features/trail/domain/entities/trail_entity.dart';
import 'package:gotrek/features/trail/domain/usecases/get_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/search_trails_usecase.dart';
import 'package:gotrek/features/trail/domain/usecases/join_trail_usecase.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helpers.dart';
import '../../helpers/test_helpers.mocks.dart';

void main() {
  // ======================================================================
  // USE CASE TEST 1: LoginUseCase
  // ======================================================================
  group('LoginUseCase', () {
    late LoginUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = LoginUseCase(mockRepository);
    });

    final tUser = createTestUser();
    const tParams = LoginParams(
      email: 'test@example.com',
      password: 'password123',
    );

    test('should return UserEntity on successful login', () async {
      // arrange
      when(mockRepository.login(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => Right(tUser));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, Right(tUser));
      verify(mockRepository.login(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return AuthFailure when login fails', () async {
      // arrange
      when(mockRepository.login(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer(
        (_) async => const Left(AuthFailure(message: 'Invalid credentials')),
      );

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Left(AuthFailure(message: 'Invalid credentials')));
      verify(mockRepository.login(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });
  });

  // ======================================================================
  // USE CASE TEST 2: SignUpUseCase
  // ======================================================================
  group('SignUpUseCase', () {
    late SignUpUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = SignUpUseCase(mockRepository);
    });

    final tUser = createTestUser(name: 'New User', email: 'new@example.com');
    final tParams = SignUpParams(
      username: 'newuser',
      email: 'new@example.com',
      password: 'password123',
      fullName: 'New User',
      phone: '9800000000',
    );

    test('should return UserEntity on successful signup', () async {
      when(mockRepository.signUp(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        phone: '9800000000',
      )).thenAnswer((_) async => Right(tUser));

      final result = await usecase(tParams);

      expect(result, Right(tUser));
      verify(mockRepository.signUp(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        phone: '9800000000',
      )).called(1);
    });

    test('should return failure when email already exists', () async {
      when(mockRepository.signUp(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        fullName: 'New User',
        phone: '9800000000',
      )).thenAnswer(
        (_) async =>
            const Left(DuplicateFailure(message: 'Email already exists')),
      );

      final result = await usecase(tParams);

      expect(result,
          const Left(DuplicateFailure(message: 'Email already exists')));
    });
  });

  // ======================================================================
  // USE CASE TEST 3: LogoutUseCase
  // ======================================================================
  group('LogoutUseCase', () {
    late LogoutUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = LogoutUseCase(mockRepository);
    });

    test('should return void on successful logout', () async {
      when(mockRepository.logout())
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(const NoParams());

      expect(result, const Right(null));
      verify(mockRepository.logout()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when logout fails', () async {
      when(mockRepository.logout()).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Server error')),
      );

      final result = await usecase(const NoParams());

      expect(result, const Left(ServerFailure(message: 'Server error')));
    });
  });

  // ======================================================================
  // USE CASE TEST 4: GetCurrentUserUseCase
  // ======================================================================
  group('GetCurrentUserUseCase', () {
    late GetCurrentUserUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = GetCurrentUserUseCase(mockRepository);
    });

    final tUser = createTestUser();

    test('should return current user when authenticated', () async {
      when(mockRepository.getCurrentUser())
          .thenAnswer((_) async => Right(tUser));

      final result = await usecase(const NoParams());

      expect(result, Right(tUser));
      verify(mockRepository.getCurrentUser()).called(1);
    });

    test('should return UnauthorizedFailure when not authenticated', () async {
      when(mockRepository.getCurrentUser()).thenAnswer(
        (_) async => const Left(UnauthorizedFailure()),
      );

      final result = await usecase(const NoParams());

      expect(result, const Left(UnauthorizedFailure()));
    });
  });

  // ======================================================================
  // USE CASE TEST 5: CheckAuthStatusUseCase
  // ======================================================================
  group('CheckAuthStatusUseCase', () {
    late CheckAuthStatusUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = CheckAuthStatusUseCase(mockRepository);
    });

    test('should return true when user is logged in', () async {
      when(mockRepository.isLoggedIn())
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(const NoParams());

      expect(result, const Right(true));
      verify(mockRepository.isLoggedIn()).called(1);
    });

    test('should return false when user is not logged in', () async {
      when(mockRepository.isLoggedIn())
          .thenAnswer((_) async => const Right(false));

      final result = await usecase(const NoParams());

      expect(result, const Right(false));
    });
  });

  // ======================================================================
  // USE CASE TEST 6: ChangePasswordUseCase
  // ======================================================================
  group('ChangePasswordUseCase', () {
    late ChangePasswordUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = ChangePasswordUseCase(mockRepository);
    });

    const tParams = ChangePasswordParams(
      currentPassword: 'oldPass123',
      newPassword: 'newPass456',
    );

    test('should return void on successful password change', () async {
      when(mockRepository.changePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass456',
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, const Right(null));
      verify(mockRepository.changePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass456',
      )).called(1);
    });

    test('should return failure when current password is wrong', () async {
      when(mockRepository.changePassword(
        currentPassword: 'oldPass123',
        newPassword: 'newPass456',
      )).thenAnswer(
        (_) async =>
            const Left(AuthFailure(message: 'Current password is incorrect')),
      );

      final result = await usecase(tParams);

      expect(result,
          const Left(AuthFailure(message: 'Current password is incorrect')));
    });
  });

  // ======================================================================
  // USE CASE TEST 7: ForgotPasswordUseCase
  // ======================================================================
  group('ForgotPasswordUseCase', () {
    late ForgotPasswordUseCase usecase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      usecase = ForgotPasswordUseCase(mockRepository);
    });

    const tParams = ForgotPasswordParams(email: 'test@example.com');

    test('should return void on successful forgot password request', () async {
      when(mockRepository.forgotPassword(email: 'test@example.com'))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, const Right(null));
      verify(mockRepository.forgotPassword(email: 'test@example.com'))
          .called(1);
    });

    test('should return NotFoundFailure when email not found', () async {
      when(mockRepository.forgotPassword(email: 'test@example.com')).thenAnswer(
        (_) async => const Left(NotFoundFailure(message: 'Email not found')),
      );

      final result = await usecase(tParams);

      expect(result, const Left(NotFoundFailure(message: 'Email not found')));
    });
  });

  // ======================================================================
  // USE CASE TEST 8: GetTrailsUseCase
  // ======================================================================
  group('GetTrailsUseCase', () {
    late GetTrailsUseCase usecase;
    late MockTrailRepository mockRepository;

    setUp(() {
      mockRepository = MockTrailRepository();
      usecase = GetTrailsUseCase(mockRepository);
    });

    final tTrails = [
      createTestTrail(id: 'trail-1', name: 'Annapurna Base Camp'),
      createTestTrail(id: 'trail-2', name: 'Everest Base Camp'),
    ];

    test('should return list of trails on success', () async {
      when(mockRepository.getTrails(filters: null))
          .thenAnswer((_) async => Right(tTrails));

      final result = await usecase(const GetTrailsParams());

      expect(result, Right(tTrails));
      verify(mockRepository.getTrails(filters: null)).called(1);
    });

    test('should return NetworkFailure when no connection', () async {
      when(mockRepository.getTrails(filters: null)).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      final result = await usecase(const GetTrailsParams());

      expect(result, const Left(NetworkFailure()));
    });
  });

  // ======================================================================
  // USE CASE TEST 9: SearchTrailsUseCase
  // ======================================================================
  group('SearchTrailsUseCase', () {
    late SearchTrailsUseCase usecase;
    late MockTrailRepository mockRepository;

    setUp(() {
      mockRepository = MockTrailRepository();
      usecase = SearchTrailsUseCase(mockRepository);
    });

    final tTrails = [
      createTestTrail(id: 'trail-1', name: 'Annapurna Base Camp'),
    ];

    test('should return matching trails for search query', () async {
      when(mockRepository.searchTrails('Annapurna'))
          .thenAnswer((_) async => Right(tTrails));

      final result =
          await usecase(const SearchTrailsParams(query: 'Annapurna'));

      expect(result, Right(tTrails));
      verify(mockRepository.searchTrails('Annapurna')).called(1);
    });

    test('should return empty list when no trails match', () async {
      when(mockRepository.searchTrails('NonexistentTrail'))
          .thenAnswer((_) async => const Right([]));

      final result =
          await usecase(const SearchTrailsParams(query: 'NonexistentTrail'));

      expect(result, const Right(<TrailEntity>[]));
    });
  });

  // ======================================================================
  // USE CASE TEST 10: JoinTrailUseCase
  // ======================================================================
  group('JoinTrailUseCase', () {
    late JoinTrailUseCase usecase;
    late MockTrailRepository mockRepository;

    setUp(() {
      mockRepository = MockTrailRepository();
      usecase = JoinTrailUseCase(mockRepository);
    });

    final tParams = JoinTrailParams(
      trailId: 'trail-1',
      startDate: DateTime(2024, 6, 15),
    );

    test('should return void on successful trail join', () async {
      when(mockRepository.joinTrailWithDate(
        trailId: 'trail-1',
        startDate: DateTime(2024, 6, 15),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase(tParams);

      expect(result, const Right(null));
      verify(mockRepository.joinTrailWithDate(
        trailId: 'trail-1',
        startDate: DateTime(2024, 6, 15),
      )).called(1);
    });

    test('should return failure when trail not found', () async {
      when(mockRepository.joinTrailWithDate(
        trailId: 'trail-1',
        startDate: DateTime(2024, 6, 15),
      )).thenAnswer(
        (_) async => const Left(NotFoundFailure(message: 'Trail not found')),
      );

      final result = await usecase(tParams);

      expect(result, const Left(NotFoundFailure(message: 'Trail not found')));
    });
  });
}
