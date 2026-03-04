import 'package:hive/hive.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../domain/entities/group_entity.dart';

part 'group_model.g.dart';

/// Group Participant Model for Hive storage
@HiveType(typeId: StorageConstants.groupParticipantTypeId)
class GroupParticipantModel extends GroupParticipant {
  @HiveField(0)
  final String odlUserId;
  @HiveField(1)
  final String odlUsername;
  @HiveField(2)
  final String? odlProfilePicture;
  @HiveField(3)
  final String odlRoleString;
  @HiveField(4)
  final DateTime odlJoinedAt;

  GroupParticipantModel({
    required this.odlUserId,
    required this.odlUsername,
    this.odlProfilePicture,
    required this.odlRoleString,
    required this.odlJoinedAt,
  }) : super(
          odlUserId: odlUserId,
          odlUsername: odlUsername,
          odlProfilePicture: odlProfilePicture,
          odlRole: ParticipantRole.fromString(odlRoleString),
          odlJoinedAt: odlJoinedAt,
        );

  factory GroupParticipantModel.fromJson(Map<String, dynamic> json) {
    // Handle nested user object from API
    String userId = json['userId'] ?? '';
    String username = json['username'] ?? json['name'] ?? '';
    String? profilePicture = json['profilePicture'];

    if (json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      userId = user['_id'] ?? user['id'] ?? userId;
      username = user['name'] ?? user['username'] ?? username;
      profilePicture = profilePicture ?? user['profilePicture'] ?? user['profileImage'];
    } else if (json['user'] is String) {
      userId = json['user'] as String;
    }

    // Fallback: if userId is still empty, try _id
    if (userId.isEmpty) {
      userId = json['_id'] ?? '';
    }

    return GroupParticipantModel(
      odlUserId: userId,
      odlUsername: username,
      odlProfilePicture: profilePicture,
      odlRoleString: json['role'] ?? 'member',
      odlJoinedAt: json['joinedAt'] != null
          ? DateTime.parse(json['joinedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': odlUserId,
      'username': odlUsername,
      'profilePicture': odlProfilePicture,
      'role': odlRoleString,
      'joinedAt': odlJoinedAt.toIso8601String(),
    };
  }

  factory GroupParticipantModel.fromEntity(GroupParticipant entity) {
    return GroupParticipantModel(
      odlUserId: entity.userId,
      odlUsername: entity.username,
      odlProfilePicture: entity.profilePicture,
      odlRoleString: entity.role.name,
      odlJoinedAt: entity.joinedAt,
    );
  }
}

/// Meeting Point Model for Hive storage
@HiveType(typeId: StorageConstants.meetingPointTypeId)
class MeetingPointModel extends MeetingPoint {
  @HiveField(0)
  final String odlName;
  @HiveField(1)
  final double odlLatitude;
  @HiveField(2)
  final double odlLongitude;
  @HiveField(3)
  final String? odlDescription;

  MeetingPointModel({
    required this.odlName,
    required this.odlLatitude,
    required this.odlLongitude,
    this.odlDescription,
  }) : super(
          odlName: odlName,
          odlLatitude: odlLatitude,
          odlLongitude: odlLongitude,
          odlDescription: odlDescription,
        );

  factory MeetingPointModel.fromJson(Map<String, dynamic> json) {
    return MeetingPointModel(
      odlName: json['name'] ?? '',
      odlLatitude: (json['latitude'] ?? 0.0).toDouble(),
      odlLongitude: (json['longitude'] ?? 0.0).toDouble(),
      odlDescription: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': odlName,
      'latitude': odlLatitude,
      'longitude': odlLongitude,
      if (odlDescription != null) 'description': odlDescription,
    };
  }

  factory MeetingPointModel.fromEntity(MeetingPoint entity) {
    return MeetingPointModel(
      odlName: entity.name,
      odlLatitude: entity.latitude,
      odlLongitude: entity.longitude,
      odlDescription: entity.description,
    );
  }
}

/// Group Comment Model for Hive storage
@HiveType(typeId: StorageConstants.groupCommentTypeId)
class GroupCommentModel extends GroupComment {
  @HiveField(0)
  final String odlId;
  @HiveField(1)
  final String odlUserId;
  @HiveField(2)
  final String odlUsername;
  @HiveField(3)
  final String? odlUserProfilePicture;
  @HiveField(4)
  final String odlContent;
  @HiveField(5)
  final DateTime odlCreatedAt;

  GroupCommentModel({
    required this.odlId,
    required this.odlUserId,
    required this.odlUsername,
    this.odlUserProfilePicture,
    required this.odlContent,
    required this.odlCreatedAt,
  }) : super(
          odlId: odlId,
          odlUserId: odlUserId,
          odlUsername: odlUsername,
          odlUserProfilePicture: odlUserProfilePicture,
          odlContent: odlContent,
          odlCreatedAt: odlCreatedAt,
        );

  factory GroupCommentModel.fromJson(Map<String, dynamic> json) {
    return GroupCommentModel(
      odlId: json['_id'] ?? json['id'] ?? '',
      odlUserId: json['userId'] ?? (json['user'] is Map ? json['user']['_id'] : ''),
      odlUsername: json['username'] ?? (json['user'] is Map ? json['user']['name'] : ''),
      odlUserProfilePicture: json['userProfilePicture'] ?? (json['user'] is Map ? json['user']['profilePicture'] : null),
      odlContent: json['content'] ?? '',
      odlCreatedAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': odlId,
      'userId': odlUserId,
      'username': odlUsername,
      'userProfilePicture': odlUserProfilePicture,
      'content': odlContent,
      'createdAt': odlCreatedAt.toIso8601String(),
    };
  }

  factory GroupCommentModel.fromEntity(GroupComment entity) {
    return GroupCommentModel(
      odlId: entity.id,
      odlUserId: entity.userId,
      odlUsername: entity.username,
      odlUserProfilePicture: entity.userProfilePicture,
      odlContent: entity.content,
      odlCreatedAt: entity.createdAt,
    );
  }
}

/// Join Request Model
class JoinRequestModel extends JoinRequest {
  JoinRequestModel({
    required String id,
    required String groupId,
    required String userId,
    required String username,
    String? userProfilePicture,
    required JoinRequestStatus status,
    String? message,
    required DateTime createdAt,
  }) : super(
          odlId: id,
          odlGroupId: groupId,
          odlUserId: userId,
          odlUsername: username,
          odlUserProfilePicture: userProfilePicture,
          odlStatus: status,
          odlMessage: message,
          odlCreatedAt: createdAt,
        );

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    return JoinRequestModel(
      id: json['_id'] ?? json['id'] ?? '',
      groupId: json['groupId'] ?? (json['group'] is Map ? json['group']['_id'] : '') ?? '',
      userId: json['userId'] ?? (json['user'] is Map ? json['user']['_id'] : ''),
      username: json['username'] ?? (json['user'] is Map ? json['user']['name'] : ''),
      userProfilePicture: json['userProfilePicture'] ?? (json['user'] is Map ? json['user']['profilePicture'] : null),
      status: JoinRequestStatus.fromString(json['status'] ?? 'pending'),
      message: json['message'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': odlId,
      'groupId': odlGroupId,
      'userId': odlUserId,
      'username': odlUsername,
      'userProfilePicture': odlUserProfilePicture,
      'status': odlStatus.name,
      'message': odlMessage,
      'createdAt': odlCreatedAt.toIso8601String(),
    };
  }
}

/// Group Model for API response and Hive storage
@HiveType(typeId: StorageConstants.groupModelTypeId)
class GroupModel extends GroupEntity {
  @HiveField(0)
  final String odlId;
  @HiveField(1)
  final String odlName;
  @HiveField(2)
  final String? odlDescription;
  @HiveField(3)
  final String odlTrailId;
  @HiveField(4)
  final String odlTrailName;
  @HiveField(5)
  final String? odlTrailImage;
  @HiveField(6)
  final DateTime odlStartDate;
  @HiveField(7)
  final DateTime? odlEndDate;
  @HiveField(8)
  final int odlMaxParticipants;
  @HiveField(9)
  final String odlStatusString;
  @HiveField(10)
  final List<GroupParticipantModel> odlParticipantModels;
  @HiveField(11)
  final MeetingPointModel? odlMeetingPointModel;
  @HiveField(12)
  final List<GroupCommentModel> odlCommentModels;
  @HiveField(13)
  final String odlCreatorId;
  @HiveField(14)
  final DateTime odlCreatedAt;
  @HiveField(15)
  final DateTime odlUpdatedAt;

  GroupModel({
    required this.odlId,
    required this.odlName,
    this.odlDescription,
    required this.odlTrailId,
    required this.odlTrailName,
    this.odlTrailImage,
    required this.odlStartDate,
    this.odlEndDate,
    required this.odlMaxParticipants,
    required this.odlStatusString,
    required this.odlParticipantModels,
    this.odlMeetingPointModel,
    required this.odlCommentModels,
    List<JoinRequest>? joinRequests,
    required this.odlCreatorId,
    required this.odlCreatedAt,
    required this.odlUpdatedAt,
  }) : super(
          odlId: odlId,
          odlName: odlName,
          odlDescription: odlDescription,
          odlTrailId: odlTrailId,
          odlTrailName: odlTrailName,
          odlTrailImage: odlTrailImage,
          odlStartDate: odlStartDate,
          odlEndDate: odlEndDate,
          odlMaxParticipants: odlMaxParticipants,
          odlStatus: GroupStatus.fromString(odlStatusString),
          odlParticipants: odlParticipantModels,
          odlMeetingPoint: odlMeetingPointModel,
          odlComments: odlCommentModels,
          odlJoinRequests: joinRequests ?? [],
          odlCreatorId: odlCreatorId,
          odlCreatedAt: odlCreatedAt,
          odlUpdatedAt: odlUpdatedAt,
        );

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    String? normalizeImageUrl(String? path) {
      if (path == null || path.isEmpty) return null;
      if (path.startsWith('http')) return path;
      if (path.startsWith('/')) return '${ApiConstants.serverUrl}$path';
      return '${ApiConstants.serverUrl}/$path';
    }

    // Parse trail info (might be populated or just ID)
    String trailId = '';
    String trailName = '';
    String? trailImage;

    if (json['trail'] is Map) {
      final trail = json['trail'] as Map<String, dynamic>;
      trailId = trail['_id'] ?? '';
      trailName = trail['name'] ?? '';
      trailImage = trail['images'] is List && (trail['images'] as List).isNotEmpty
          ? normalizeImageUrl((trail['images'] as List).first?.toString())
          : null;
    } else {
      trailId = json['trail'] ?? json['trailId'] ?? '';
      trailName = json['trailName'] ?? '';
      trailImage = normalizeImageUrl(json['trailImage']);
    }

    if (json['photos'] is List && (json['photos'] as List).isNotEmpty) {
      trailImage = normalizeImageUrl((json['photos'] as List).first?.toString());
    }

    // Parse participants - separate confirmed from pending/declined
    final participantsJson = json['participants'] as List? ?? [];
    final allParticipants = participantsJson
        .where((p) => p is Map<String, dynamic> && p['user'] != null)
        .map((p) => p as Map<String, dynamic>)
        .toList();

    // Only confirmed participants go into the participants list
    final participants = allParticipants
        .where((p) => (p['status'] ?? 'confirmed') == 'confirmed')
        .map((p) => GroupParticipantModel.fromJson(p))
        .toList();

    // Parse comments
    final commentsJson = json['comments'] as List? ?? [];
    final comments = commentsJson
        .map((c) => GroupCommentModel.fromJson(c as Map<String, dynamic>))
        .toList();

    // Build join requests from participants with pending status + any explicit joinRequests
    final pendingParticipants = allParticipants
        .where((p) => (p['status'] ?? '') == 'pending')
        .map((p) {
      final groupId = json['_id'] ?? json['id'] ?? '';
      return JoinRequestModel.fromJson({
        ...p,
        'groupId': groupId,
        'status': 'pending',
      });
    }).toList();

    final requestsJson = json['joinRequests'] as List? ?? [];
    final explicitJoinRequests = requestsJson
        .map((r) => JoinRequestModel.fromJson(r as Map<String, dynamic>))
        .toList();

    final joinRequests = [...pendingParticipants, ...explicitJoinRequests];

    // Parse meeting point
    MeetingPointModel? meetingPoint;
    if (json['meetingPoint'] != null && json['meetingPoint'] is Map) {
      meetingPoint = MeetingPointModel.fromJson(json['meetingPoint']);
    }

    // Parse creator/leader
    String creatorId = '';
    if (json['leader'] is Map) {
      creatorId = (json['leader'] as Map)['_id'] ?? '';
    } else if (json['leader'] is String) {
      creatorId = json['leader'] as String;
    }
    if (creatorId.isEmpty) {
      if (json['creator'] is Map) {
        creatorId = (json['creator'] as Map)['_id'] ?? '';
      } else {
        creatorId = json['creator'] ?? json['creatorId'] ?? '';
      }
    }

    return GroupModel(
      odlId: json['_id'] ?? json['id'] ?? '',
      odlName: json['title'] ?? json['name'] ?? '',
      odlDescription: json['description'],
      odlTrailId: trailId,
      odlTrailName: trailName,
      odlTrailImage: trailImage,
      odlStartDate: json['date'] != null
        ? DateTime.parse(json['date'])
        : json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      odlEndDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : null,
      odlMaxParticipants: json['maxSize'] ?? json['maxParticipants'] ?? 10,
      odlStatusString: json['status'] ?? 'forming',
      odlParticipantModels: participants,
      odlMeetingPointModel: meetingPoint,
      odlCommentModels: comments,
      joinRequests: joinRequests,
      odlCreatorId: creatorId,
      odlCreatedAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      odlUpdatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': odlId,
      'name': odlName,
      'description': odlDescription,
      'trailId': odlTrailId,
      'trailName': odlTrailName,
      'trailImage': odlTrailImage,
      'startDate': odlStartDate.toIso8601String(),
      'endDate': odlEndDate?.toIso8601String(),
      'maxParticipants': odlMaxParticipants,
      'status': odlStatusString,
      'participants': odlParticipantModels.map((p) => p.toJson()).toList(),
      'meetingPoint': odlMeetingPointModel?.toJson(),
      'comments': odlCommentModels.map((c) => c.toJson()).toList(),
      'creatorId': odlCreatorId,
      'createdAt': odlCreatedAt.toIso8601String(),
      'updatedAt': odlUpdatedAt.toIso8601String(),
    };
  }

  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      odlId: entity.id,
      odlName: entity.name,
      odlDescription: entity.description,
      odlTrailId: entity.trailId,
      odlTrailName: entity.trailName,
      odlTrailImage: entity.trailImage,
      odlStartDate: entity.startDate,
      odlEndDate: entity.endDate,
      odlMaxParticipants: entity.maxParticipants,
      odlStatusString: entity.status.name,
      odlParticipantModels: entity.participants
          .map((p) => GroupParticipantModel.fromEntity(p))
          .toList(),
      odlMeetingPointModel: entity.meetingPoint != null
          ? MeetingPointModel.fromEntity(entity.meetingPoint!)
          : null,
      odlCommentModels: entity.comments
          .map((c) => GroupCommentModel.fromEntity(c))
          .toList(),
      joinRequests: entity.joinRequests,
      odlCreatorId: entity.creatorId,
      odlCreatedAt: entity.createdAt,
      odlUpdatedAt: entity.updatedAt,
    );
  }
}
