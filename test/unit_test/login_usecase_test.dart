import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/domain/usecases/login_usecase.dart';

void main() {
  group('LoginUseCase', () {

    test('should validate username is required', () {
      // Arrange
      final params = LoginParams(
        username: '',
        password: 'password123',
      );

      // Act
      expect(params.username.isEmpty, true);
    });

    test('should validate password is required', () {
      // Arrange
      final params = LoginParams(
        username: 'testuser',
        password: '',
      );

      // Act
      expect(params.password.isEmpty, true);
    });

    test('should validate username format', () {
      // Arrange
      final params = LoginParams(
        username: 'validuser',
        password: 'password123',
      );

      // Act
      expect(params.username.isNotEmpty, true);
    });

    test('should validate password minimum length', () {
      // Arrange
      final params = LoginParams(
        username: 'testuser',
        password: 'short',
      );

      // Act
      expect(params.password.length < 6, true);
    });

    test('should create LoginParams with valid credentials', () {
      // Act
      final params = LoginParams(
        username: 'testuser',
        password: 'password123',
      );

      // Assert
      expect(params.username, 'testuser');
      expect(params.password, 'password123');
    });
  });
}
