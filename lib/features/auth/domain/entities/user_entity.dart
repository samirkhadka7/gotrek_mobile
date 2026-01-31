class UserEntity {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? phone;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.phone,
    required this.createdAt,
  });
}