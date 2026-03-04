import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  UserHiveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserHiveModel.fromJson(Map<String, dynamic> json) {
    return UserHiveModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }
}
