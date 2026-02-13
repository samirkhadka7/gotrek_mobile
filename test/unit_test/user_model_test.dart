import 'package:flutter_test/flutter_test.dart';
import 'package:gotrek/features/auth/data/models/user_model.dart';
import 'package:gotrek/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel', () {
    final tUserModel = UserModel(
      id: '1',
      username: 'testuser',
      email: 'test@example.com',
      fullName: 'Test User',
      phone: '1234567890',
      profileImageUrl: 'http://example.com/image.jpg',
      createdAt: DateTime.parse('2024-01-31'),
      token: 'test_token_123',
    );

    test('should create UserModel from JSON correctly', () {
      // Arrange
      final jsonMap = {
        'id': '1',
        '_id': '1',
        'username': 'testuser',
        'email': 'test@example.com',
        'fullName': 'Test User',
        'phone': '1234567890',
        'profileImageUrl': 'http://example.com/image.jpg',
        'createdAt': '2024-01-31T00:00:00.000Z',
        'token': 'test_token_123',
      };

      // Act
      final result = UserModel.fromJson(jsonMap);

      // Assert
      expect(result.id, '1');
      expect(result.username, 'testuser');
      expect(result.email, 'test@example.com');
      expect(result.fullName, 'Test User');
      expect(result.token, 'test_token_123');
    });

    test('should convert UserModel to JSON correctly', () {
      // Act
      final json = tUserModel.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
      expect(json['fullName'], 'Test User');
      expect(json['token'], 'test_token_123');
    });

    test('should convert UserModel to Entity correctly', () {
      // Act
      final entity = tUserModel.toEntity();

      // Assert
      expect(entity, isA<UserEntity>());
      expect(entity.id, '1');
      expect(entity.username, 'testuser');
      expect(entity.email, 'test@example.com');
      expect(entity.profileImageUrl, 'http://example.com/image.jpg');
    });

    test('should handle null optional fields in fromJson', () {
      // Arrange
      final jsonMap = {
        'id': '1',
        'username': 'testuser',
        'email': 'test@example.com',
        'createdAt': '2024-01-31T00:00:00.000Z',
      };

      // Act
      final result = UserModel.fromJson(jsonMap);

      // Assert
      expect(result.fullName, null);
      expect(result.phone, null);
      expect(result.profileImageUrl, null);
      expect(result.token, null);
    });

    test('should handle default createdAt when missing in JSON', () {
      // Arrange
      final jsonMap = {
        'id': '1',
        'username': 'testuser',
        'email': 'test@example.com',
      };

      // Act
      final result = UserModel.fromJson(jsonMap);

      // Assert
      expect(result.createdAt, isA<DateTime>());
    });
  });
}
