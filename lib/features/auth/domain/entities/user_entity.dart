import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';

/// User entity representing the core user data
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String hikerType;
  final String? ageGroup;
  final EmergencyContactEntity? emergencyContact;
  final String bio;
  final String profileImage;
  final DateTime joinDate;
  final String role;
  final String subscription;
  final DateTime? subscriptionExpiresAt;
  final UserStatsEntity stats;
  final List<String> achievements;
  final List<CompletedTrailEntity> completedTrails;
  final List<JoinedTrailEntity> joinedTrails;
  final int groupsCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.hikerType = 'new',
    this.ageGroup,
    this.emergencyContact,
    this.bio = '',
    this.profileImage = '',
    required this.joinDate,
    this.role = 'user',
    this.subscription = 'Basic',
    this.subscriptionExpiresAt,
    required this.stats,
    this.achievements = const [],
    this.completedTrails = const [],
    this.joinedTrails = const [],
    this.groupsCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  /// Check if user is admin
  bool get isAdmin => role == 'admin';

  /// Check if user is guide
  bool get isGuide => role == 'guide';

  /// Check if user has premium subscription
  bool get isPremium => subscription == 'Premium';

  /// Check if user has pro subscription
  bool get isPro => subscription == 'Pro' || subscription == 'Premium';

  /// Check if subscription is active
  bool get hasActiveSubscription {
    if (subscription == 'Basic') return true;
    if (subscriptionExpiresAt == null) return false;
    return subscriptionExpiresAt!.isAfter(DateTime.now());
  }

  /// Get full profile image URL
  /// Converts relative paths like '/uploads/file.jpg' to full URLs
  String get profileImageUrl {
    if (profileImage.isEmpty) return '';
    
    // Already a full URL
    if (profileImage.startsWith('http://') || profileImage.startsWith('https://')) {
      return profileImage;
    }
    
    // Convert relative path to full URL
    if (profileImage.startsWith('/')) {
      return '${ApiConstants.serverUrl}$profileImage';
    }
    
    // If no leading slash, add it
    return '${ApiConstants.serverUrl}/$profileImage';
  }

  /// Create a copy with updated fields
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? hikerType,
    String? ageGroup,
    EmergencyContactEntity? emergencyContact,
    String? bio,
    String? profileImage,
    DateTime? joinDate,
    String? role,
    String? subscription,
    DateTime? subscriptionExpiresAt,
    UserStatsEntity? stats,
    List<String>? achievements,
    List<CompletedTrailEntity>? completedTrails,
    List<JoinedTrailEntity>? joinedTrails,
    int? groupsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      hikerType: hikerType ?? this.hikerType,
      ageGroup: ageGroup ?? this.ageGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      joinDate: joinDate ?? this.joinDate,
      role: role ?? this.role,
      subscription: subscription ?? this.subscription,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      stats: stats ?? this.stats,
      achievements: achievements ?? this.achievements,
      completedTrails: completedTrails ?? this.completedTrails,
      joinedTrails: joinedTrails ?? this.joinedTrails,
      groupsCount: groupsCount ?? this.groupsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        hikerType,
        ageGroup,
        emergencyContact,
        bio,
        profileImage,
        joinDate,
        role,
        subscription,
        subscriptionExpiresAt,
        stats,
        achievements,
        completedTrails,
        joinedTrails,
        groupsCount,
      ];
}

/// Emergency contact entity
class EmergencyContactEntity extends Equatable {
  final String? name;
  final String? phone;

  const EmergencyContactEntity({
    this.name,
    this.phone,
  });

  @override
  List<Object?> get props => [name, phone];
}

/// User statistics entity
class UserStatsEntity extends Equatable {
  final int totalHikes;
  final double totalDistance;
  final double totalElevation;
  final double totalHours;
  final int hikesJoined;
  final int hikesLed;

  const UserStatsEntity({
    this.totalHikes = 0,
    this.totalDistance = 0,
    this.totalElevation = 0,
    this.totalHours = 0,
    this.hikesJoined = 0,
    this.hikesLed = 0,
  });

  @override
  List<Object?> get props => [
        totalHikes,
        totalDistance,
        totalElevation,
        totalHours,
        hikesJoined,
        hikesLed,
      ];
}

/// Completed trail entity
class CompletedTrailEntity extends Equatable {
  final String trailId;
  final String trailName;
  final DateTime completedAt;

  const CompletedTrailEntity({
    required this.trailId,
    this.trailName = '',
    required this.completedAt,
  });

  @override
  List<Object?> get props => [trailId, trailName, completedAt];
}

/// Joined trail entity
class JoinedTrailEntity extends Equatable {
  final String? id;
  final String trailId;
  final String trailName;
  final String trailLocation;
  final String trailDifficulty;
  final DateTime scheduledDate;
  final DateTime addedAt;

  const JoinedTrailEntity({
    this.id,
    required this.trailId,
    this.trailName = '',
    this.trailLocation = '',
    this.trailDifficulty = 'Easy',
    required this.scheduledDate,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, trailId, trailName, trailLocation, trailDifficulty, scheduledDate, addedAt];
}
