import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    final testDate = DateTime.parse('2024-01-31');

    test('should create UserEntity with all required parameters', () {
      // Act
      final userEntity = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: testDate,
      );

      // Assert
      expect(userEntity.id, '1');
      expect(userEntity.username, 'testuser');
      expect(userEntity.email, 'test@example.com');
      expect(userEntity.createdAt, testDate);
    });

    test('should create UserEntity with optional parameters', () {
      // Act
      final userEntity = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        fullName: 'Test User',
        phone: '1234567890',
        profileImageUrl: 'http://example.com/image.jpg',
        createdAt: testDate,
      );

      // Assert
      expect(userEntity.fullName, 'Test User');
      expect(userEntity.phone, '1234567890');
      expect(userEntity.profileImageUrl, 'http://example.com/image.jpg');
    });

    test('should have null optional fields when not provided', () {
      // Act
      final userEntity = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: testDate,
      );

      // Assert
      expect(userEntity.fullName, null);
      expect(userEntity.phone, null);
      expect(userEntity.profileImageUrl, null);
    });

    test('should have matching field values', () {
      // Arrange
      final user1 = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: testDate,
      );

      final user2 = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: testDate,
      );

      // Assert
      expect(user1.id, user2.id);
      expect(user1.username, user2.username);
      expect(user1.email, user2.email);
      expect(user1.createdAt, user2.createdAt);
    });

    test('should update profileImageUrl correctly', () {
      // Arrange
      var userEntity = UserEntity(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        profileImageUrl: null,
        createdAt: testDate,
      );

      // Act
      userEntity = UserEntity(
        id: userEntity.id,
        username: userEntity.username,
        email: userEntity.email,
        fullName: userEntity.fullName,
        phone: userEntity.phone,
        profileImageUrl: 'http://example.com/new-image.jpg',
        createdAt: userEntity.createdAt,
      );

      // Assert
      expect(userEntity.profileImageUrl, 'http://example.com/new-image.jpg');
    });
  });
}
