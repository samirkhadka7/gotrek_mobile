import 'package:hive/hive.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

/// User model for API communication and local storage
@HiveType(typeId: StorageConstants.userModelTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? phone;

  @HiveField(4)
  final String hikerType;

  @HiveField(5)
  final String? ageGroup;

  @HiveField(6)
  final EmergencyContactModel? emergencyContact;

  @HiveField(7)
  final String bio;

  @HiveField(8)
  final String profileImage;

  @HiveField(9)
  final DateTime joinDate;

  @HiveField(10)
  final String role;

  @HiveField(11)
  final String subscription;

  @HiveField(12)
  final DateTime? subscriptionExpiresAt;

  @HiveField(13)
  final UserStatsModel stats;

  @HiveField(14)
  final List<String> achievements;

  @HiveField(15)
  final List<CompletedTrailModel> completedTrails;

  @HiveField(16)
  final List<JoinedTrailModel> joinedTrails;

  @HiveField(17)
  final DateTime? createdAt;

  @HiveField(18)
  final DateTime? updatedAt;

  @HiveField(19)
  final String? token;

  /// Groups count from API (not persisted in older Hive versions)
  final int groupsCount;

  UserModel({
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
    this.token,
  });

  /// Factory constructor from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      hikerType: json['hikerType'] ?? 'new',
      ageGroup: json['ageGroup'],
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContactModel.fromJson(json['emergencyContact'])
          : null,
      bio: json['bio'] ?? '',
      profileImage: json['profileImage'] ?? '',
      joinDate: json['joinDate'] != null
          ? DateTime.parse(json['joinDate'])
          : DateTime.now(),
      role: json['role'] ?? 'user',
      subscription: json['subscription'] ?? 'Basic',
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'])
          : null,
      stats: json['stats'] != null
          ? UserStatsModel.fromJson(json['stats'])
          : const UserStatsModel(),
      achievements: json['achievements'] != null
          ? List<String>.from(json['achievements'].map((e) => e.toString()))
          : [],
      completedTrails: json['completedTrails'] != null
          ? (json['completedTrails'] as List)
                .where((e) => e != null && e is Map<String, dynamic>)
                .map((e) => CompletedTrailModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      joinedTrails: json['joinedTrails'] != null
          ? (json['joinedTrails'] as List)
                .where((e) => e != null && e is Map<String, dynamic>)
                .map((e) => JoinedTrailModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      groupsCount: json['groups'] != null && json['groups'] is List
          ? (json['groups'] as List).length
          : 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      token: token ?? json['token'],
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'hikerType': hikerType,
      'ageGroup': ageGroup,
      'emergencyContact': emergencyContact?.toJson(),
      'bio': bio,
      'profileImage': profileImage,
      'joinDate': joinDate.toIso8601String(),
      'role': role,
      'subscription': subscription,
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
      'stats': stats.toJson(),
      'achievements': achievements,
      'completedTrails': completedTrails.map((e) => e.toJson()).toList(),
      'joinedTrails': joinedTrails.map((e) => e.toJson()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      hikerType: hikerType,
      ageGroup: ageGroup,
      emergencyContact: emergencyContact?.toEntity(),
      bio: bio,
      profileImage: profileImage,
      joinDate: joinDate,
      role: role,
      subscription: subscription,
      subscriptionExpiresAt: subscriptionExpiresAt,
      stats: stats.toEntity(),
      achievements: achievements,
      completedTrails: completedTrails.map((e) => e.toEntity()).toList(),
      joinedTrails: joinedTrails.map((e) => e.toEntity()).toList(),
      groupsCount: groupsCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from entity
  factory UserModel.fromEntity(UserEntity entity, {String? token}) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      hikerType: entity.hikerType,
      ageGroup: entity.ageGroup,
      emergencyContact: entity.emergencyContact != null
          ? EmergencyContactModel.fromEntity(entity.emergencyContact!)
          : null,
      bio: entity.bio,
      profileImage: entity.profileImage,
      joinDate: entity.joinDate,
      role: entity.role,
      subscription: entity.subscription,
      subscriptionExpiresAt: entity.subscriptionExpiresAt,
      stats: UserStatsModel.fromEntity(entity.stats),
      achievements: entity.achievements,
      completedTrails: entity.completedTrails
          .map((e) => CompletedTrailModel.fromEntity(e))
          .toList(),
      joinedTrails: entity.joinedTrails
          .map((e) => JoinedTrailModel.fromEntity(e))
          .toList(),
      groupsCount: entity.groupsCount,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      token: token,
    );
  }
}

/// Emergency Contact model
@HiveType(typeId: StorageConstants.emergencyContactModelTypeId)
class EmergencyContactModel {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? phone;

  const EmergencyContactModel({this.name, this.phone});

  factory EmergencyContactModel.fromJson(Map<String, dynamic> json) {
    return EmergencyContactModel(name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone};
  }

  EmergencyContactEntity toEntity() {
    return EmergencyContactEntity(name: name, phone: phone);
  }

  factory EmergencyContactModel.fromEntity(EmergencyContactEntity entity) {
    return EmergencyContactModel(name: entity.name, phone: entity.phone);
  }
}

/// User Stats model
@HiveType(typeId: StorageConstants.userStatsModelTypeId)
class UserStatsModel {
  @HiveField(0)
  final int totalHikes;

  @HiveField(1)
  final double totalDistance;

  @HiveField(2)
  final double totalElevation;

  @HiveField(3)
  final double totalHours;

  @HiveField(4)
  final int hikesJoined;

  @HiveField(5)
  final int hikesLed;

  const UserStatsModel({
    this.totalHikes = 0,
    this.totalDistance = 0,
    this.totalElevation = 0,
    this.totalHours = 0,
    this.hikesJoined = 0,
    this.hikesLed = 0,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalHikes: (json['totalHikes'] is int) ? json['totalHikes'] : (json['totalHikes'] as num?)?.toInt() ?? 0,
      totalDistance: (json['totalDistance'] ?? 0).toDouble(),
      totalElevation: (json['totalElevation'] ?? 0).toDouble(),
      totalHours: (json['totalHours'] ?? 0).toDouble(),
      hikesJoined: (json['hikesJoined'] is int) ? json['hikesJoined'] : (json['hikesJoined'] as num?)?.toInt() ?? 0,
      hikesLed: (json['hikesLed'] is int) ? json['hikesLed'] : (json['hikesLed'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalHikes': totalHikes,
      'totalDistance': totalDistance,
      'totalElevation': totalElevation,
      'totalHours': totalHours,
      'hikesJoined': hikesJoined,
      'hikesLed': hikesLed,
    };
  }

  UserStatsEntity toEntity() {
    return UserStatsEntity(
      totalHikes: totalHikes,
      totalDistance: totalDistance,
      totalElevation: totalElevation,
      totalHours: totalHours,
      hikesJoined: hikesJoined,
      hikesLed: hikesLed,
    );
  }

  factory UserStatsModel.fromEntity(UserStatsEntity entity) {
    return UserStatsModel(
      totalHikes: entity.totalHikes,
      totalDistance: entity.totalDistance,
      totalElevation: entity.totalElevation,
      totalHours: entity.totalHours,
      hikesJoined: entity.hikesJoined,
      hikesLed: entity.hikesLed,
    );
  }
}

/// Completed Trail model
@HiveType(typeId: StorageConstants.completedTrailModelTypeId)
class CompletedTrailModel {
  @HiveField(0)
  final String trailId;

  @HiveField(1)
  final DateTime completedAt;

  /// Trail name from populated response (transient, not in Hive)
  final String trailName;

  const CompletedTrailModel({
    required this.trailId,
    required this.completedAt,
    this.trailName = '',
  });

  factory CompletedTrailModel.fromJson(Map<String, dynamic> json) {
    // Handle populated trail object or just trail ID
    String trailId;
    String trailName = '';
    if (json['trail'] is Map) {
      trailId = json['trail']['_id'] ?? json['trail']['id'] ?? '';
      trailName = json['trail']['name'] ?? '';
    } else {
      trailId = json['trail']?.toString() ?? '';
    }

    return CompletedTrailModel(
      trailId: trailId,
      trailName: trailName,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'trail': trailId, 'completedAt': completedAt.toIso8601String()};
  }

  CompletedTrailEntity toEntity() {
    return CompletedTrailEntity(
      trailId: trailId,
      trailName: trailName,
      completedAt: completedAt,
    );
  }

  factory CompletedTrailModel.fromEntity(CompletedTrailEntity entity) {
    return CompletedTrailModel(
      trailId: entity.trailId,
      trailName: entity.trailName,
      completedAt: entity.completedAt,
    );
  }
}

/// Joined Trail model
@HiveType(typeId: StorageConstants.joinedTrailModelTypeId)
class JoinedTrailModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String trailId;

  @HiveField(2)
  final DateTime scheduledDate;

  @HiveField(3)
  final DateTime addedAt;

  /// Trail details from populated response (transient, not in Hive)
  final String trailName;
  final String trailLocation;
  final String trailDifficulty;

  const JoinedTrailModel({
    this.id,
    required this.trailId,
    required this.scheduledDate,
    required this.addedAt,
    this.trailName = '',
    this.trailLocation = '',
    this.trailDifficulty = 'Easy',
  });

  factory JoinedTrailModel.fromJson(Map<String, dynamic> json) {
    // Handle populated trail object or just trail ID
    String trailId;
    String trailName = '';
    String trailLocation = '';
    String trailDifficulty = 'Easy';
    if (json['trail'] is Map) {
      trailId = json['trail']['_id'] ?? json['trail']['id'] ?? '';
      trailName = json['trail']['name'] ?? '';
      trailLocation = json['trail']['location'] ?? '';
      trailDifficulty = json['trail']['difficulty'] ?? 'Easy';
    } else {
      trailId = json['trail']?.toString() ?? '';
    }

    return JoinedTrailModel(
      id: json['_id']?.toString(),
      trailId: trailId,
      trailName: trailName,
      trailLocation: trailLocation,
      trailDifficulty: trailDifficulty,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'])
          : DateTime.now(),
      addedAt: json['addedAt'] != null
          ? DateTime.parse(json['addedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'trail': trailId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'addedAt': addedAt.toIso8601String(),
    };
  }

  JoinedTrailEntity toEntity() {
    return JoinedTrailEntity(
      id: id,
      trailId: trailId,
      trailName: trailName,
      trailLocation: trailLocation,
      trailDifficulty: trailDifficulty,
      scheduledDate: scheduledDate,
      addedAt: addedAt,
    );
  }

  factory JoinedTrailModel.fromEntity(JoinedTrailEntity entity) {
    return JoinedTrailModel(
      id: entity.id,
      trailId: entity.trailId,
      trailName: entity.trailName,
      trailLocation: entity.trailLocation,
      trailDifficulty: entity.trailDifficulty,
      scheduledDate: entity.scheduledDate,
      addedAt: entity.addedAt,
    );
  }
}
