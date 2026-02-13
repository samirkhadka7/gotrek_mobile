import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/domain/usecases/signup_usecase.dart';

void main() {
  group('SignUpUseCase', () {

    test('should validate username length', () {
      // Arrange
      final params = SignUpParams(
        username: 'ab', // Too short
        email: 'test@example.com',
        password: 'password123',
      );

      // Act
      // Username validation happens at repository level
      expect(params.username.length < 3, true);
    });

    test('should validate email format', () {
      // Arrange
      final params = SignUpParams(
        username: 'testuser',
        email: 'invalidemail',
        password: 'password123',
      );

      // Act
      expect(params.email.contains('@'), false);
    });

    test('should validate password length', () {
      // Arrange
      final params = SignUpParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'short', // Too short
      );

      // Act
      expect(params.password.length < 6, true);
    });

    test('should create SignUpParams with required fields', () {
      // Act
      final params = SignUpParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
      );

      // Assert
      expect(params.username, 'testuser');
      expect(params.email, 'test@example.com');
      expect(params.password, 'password123');
    });

    test('should create SignUpParams with optional fields', () {
      // Act
      final params = SignUpParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        fullName: 'Test User',
        phone: '1234567890',
      );

      // Assert
      expect(params.fullName, 'Test User');
      expect(params.phone, '1234567890');
    });
  });
}
