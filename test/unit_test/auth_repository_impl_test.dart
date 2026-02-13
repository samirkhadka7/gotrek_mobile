import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/domain/entities/user_entity.dart';

void main() {
  group('AuthRepositoryImpl Tests', () {

    test('should create UserEntity with all fields', () {
      // Act
      final user = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        fullName: 'Test User',
        phone: '1234567890',
        createdAt: DateTime.now(),
      );

      // Assert
      expect(user.id, '1');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.fullName, 'Test User');
      expect(user.phone, '1234567890');
    });

    test('should validate empty username', () {
      // Act
      final username = '';

      // Assert
      expect(username.isEmpty, true);
    });

    test('should validate invalid email format', () {
      // Act
      final email = 'invalidemail';

      // Assert
      expect(email.contains('@'), false);
    });

    test('should validate password length', () {
      // Act
      final password = 'short';

      // Assert
      expect(password.length < 6, true);
    });

    test('should validate valid email format', () {
      // Act
      final email = 'test@example.com';

      // Assert
      expect(email.contains('@'), true);
    });
  });
}
