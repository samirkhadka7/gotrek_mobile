import '../../domain/entities/admin_user_entity.dart';

/// Admin User Model for data layer
class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String? profileImage;
  final String? hikerType;
  final String? ageGroup;
  final String? bio;
  final bool active;
  final DateTime createdAt;
  final Map<String, dynamic>? stats;
  final List<dynamic>? completedTrails;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.profileImage,
    this.hikerType,
    this.ageGroup,
    this.bio,
    required this.active,
    required this.createdAt,
    this.stats,
    this.completedTrails,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'user',
      profileImage: json['profileImage'],
      hikerType: json['hikerType'],
      ageGroup: json['ageGroup'],
      bio: json['bio'],
      active: json['active'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      stats: json['stats'],
      completedTrails: json['completedTrails'],
    );
  }

  AdminUserEntity toEntity() {
    return AdminUserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      profileImage: profileImage,
      hikerType: hikerType,
      ageGroup: ageGroup,
      bio: bio,
      active: active,
      createdAt: createdAt,
      totalHikes: stats?['totalHikes'] ?? 0,
      completedHikes: completedTrails?.length ?? 0,
    );
  }
}

/// Pagination result model
class UserListResultModel {
  final List<AdminUserModel> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  UserListResultModel({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory UserListResultModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> usersData = json['data'] ?? [];
    final pagination = json['pagination'] ?? {};

    return UserListResultModel(
      users: usersData.map((user) => AdminUserModel.fromJson(user)).toList(),
      total: pagination['total'] ?? 0,
      page: pagination['page'] ?? 1,
      limit: pagination['limit'] ?? 10,
      totalPages: pagination['totalPages'] ?? 0,
    );
  }

  UserListResult toEntity() {
    return UserListResult(
      users: users.map((model) => model.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}
