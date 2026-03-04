import '../../../../core/constants/api_constants.dart';

/// Admin User Entity with additional administrative fields
class AdminUserEntity {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role; // 'user', 'guide', 'admin'
  final String? profileImage;
  final String? hikerType;
  final String? ageGroup;
  final String? bio;
  final bool active;
  final DateTime createdAt;
  final int totalHikes;
  final int completedHikes;

  const AdminUserEntity({
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
    this.totalHikes = 0,
    this.completedHikes = 0,
  });

  /// Get full profile image URL
  /// Converts relative paths like '/uploads/file.jpg' to full URLs
  String get profileImageUrl {
    if (profileImage == null || profileImage!.isEmpty) return '';
    
    // Already a full URL
    if (profileImage!.startsWith('http://') || profileImage!.startsWith('https://')) {
      return profileImage!;
    }
    
    // Convert relative path to full URL
    if (profileImage!.startsWith('/')) {
      return '${ApiConstants.serverUrl}$profileImage';
    }
    
    // If no leading slash, add it
    return '${ApiConstants.serverUrl}/$profileImage';
  }
}

/// Pagination result for users
class UserListResult {
  final List<AdminUserEntity> users;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const UserListResult({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
