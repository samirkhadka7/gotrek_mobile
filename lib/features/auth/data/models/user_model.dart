import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? token;

  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.fullName,
    super.phone,
    required super.createdAt,
    this.token,
  });

  // API response bata Model banauney
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'],
      phone: json['phone'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      token: json['token'],
    );
  }

  // Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      fullName: fullName,
      phone: phone,
      createdAt: createdAt,
    );
  }
}