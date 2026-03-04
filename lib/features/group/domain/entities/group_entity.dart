import 'package:equatable/equatable.dart';

/// Group Status enum
enum GroupStatus {
  forming,
  upcoming,
  active,
  completed,
  cancelled;

  String toDisplayString() {
    switch (this) {
      case GroupStatus.forming:
        return 'Forming';
      case GroupStatus.upcoming:
        return 'Upcoming';
      case GroupStatus.active:
        return 'Active';
      case GroupStatus.completed:
        return 'Completed';
      case GroupStatus.cancelled:
        return 'Cancelled';
    }
  }

  static GroupStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'forming':
        return GroupStatus.forming;
      case 'upcoming':
        return GroupStatus.upcoming;
      case 'active':
        return GroupStatus.active;
      case 'completed':
        return GroupStatus.completed;
      case 'cancelled':
        return GroupStatus.cancelled;
      default:
        return GroupStatus.forming;
    }
  }

  int get colorValue {
    switch (this) {
      case GroupStatus.forming:
        return 0xFF2196F3; // Blue
      case GroupStatus.upcoming:
        return 0xFF3F51B5; // Indigo
      case GroupStatus.active:
        return 0xFF4CAF50; // Green
      case GroupStatus.completed:
        return 0xFF9E9E9E; // Grey
      case GroupStatus.cancelled:
        return 0xFFF44336; // Red
    }
  }
}

/// Participant Role enum
enum ParticipantRole {
  leader,
  member;

  String toDisplayString() {
    switch (this) {
      case ParticipantRole.leader:
        return 'Leader';
      case ParticipantRole.member:
        return 'Member';
    }
  }

  static ParticipantRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'leader':
        return ParticipantRole.leader;
      case 'member':
        return ParticipantRole.member;
      default:
        return ParticipantRole.member;
    }
  }
}

/// Join Request Status enum
enum JoinRequestStatus {
  pending,
  approved,
  denied;

  String toDisplayString() {
    switch (this) {
      case JoinRequestStatus.pending:
        return 'Pending';
      case JoinRequestStatus.approved:
        return 'Approved';
      case JoinRequestStatus.denied:
        return 'Denied';
    }
  }

  static JoinRequestStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return JoinRequestStatus.pending;
      case 'approved':
        return JoinRequestStatus.approved;
      case 'denied':
        return JoinRequestStatus.denied;
      default:
        return JoinRequestStatus.pending;
    }
  }
}

/// Group Participant Entity
class GroupParticipant extends Equatable {
  final String odlUserId;
  final String odlUsername;
  final String? odlProfilePicture;
  final ParticipantRole odlRole;
  final DateTime odlJoinedAt;

  const GroupParticipant({
    required this.odlUserId,
    required this.odlUsername,
    this.odlProfilePicture,
    required this.odlRole,
    required this.odlJoinedAt,
  });

  String get userId => odlUserId;
  String get username => odlUsername;
  String? get profilePicture => odlProfilePicture;
  ParticipantRole get role => odlRole;
  DateTime get joinedAt => odlJoinedAt;

  bool get isLeader => odlRole == ParticipantRole.leader;

  @override
  List<Object?> get props => [odlUserId, odlUsername, odlProfilePicture, odlRole, odlJoinedAt];
}

/// Meeting Point Entity
class MeetingPoint extends Equatable {
  final String odlName;
  final double odlLatitude;
  final double odlLongitude;
  final String? odlDescription;

  const MeetingPoint({
    required this.odlName,
    required this.odlLatitude,
    required this.odlLongitude,
    this.odlDescription,
  });

  String get name => odlName;
  double get latitude => odlLatitude;
  double get longitude => odlLongitude;
  String? get description => odlDescription;

  @override
  List<Object?> get props => [odlName, odlLatitude, odlLongitude, odlDescription];
}

/// Group Comment Entity
class GroupComment extends Equatable {
  final String odlId;
  final String odlUserId;
  final String odlUsername;
  final String? odlUserProfilePicture;
  final String odlContent;
  final DateTime odlCreatedAt;

  const GroupComment({
    required this.odlId,
    required this.odlUserId,
    required this.odlUsername,
    this.odlUserProfilePicture,
    required this.odlContent,
    required this.odlCreatedAt,
  });

  String get id => odlId;
  String get userId => odlUserId;
  String get username => odlUsername;
  String? get userProfilePicture => odlUserProfilePicture;
  String get content => odlContent;
  DateTime get createdAt => odlCreatedAt;

  @override
  List<Object?> get props => [odlId, odlUserId, odlUsername, odlUserProfilePicture, odlContent, odlCreatedAt];
}

/// Join Request Entity
class JoinRequest extends Equatable {
  final String odlId;
  final String odlGroupId;
  final String odlUserId;
  final String odlUsername;
  final String? odlUserProfilePicture;
  final JoinRequestStatus odlStatus;
  final String? odlMessage;
  final DateTime odlCreatedAt;

  const JoinRequest({
    required this.odlId,
    required this.odlGroupId,
    required this.odlUserId,
    required this.odlUsername,
    this.odlUserProfilePicture,
    required this.odlStatus,
    this.odlMessage,
    required this.odlCreatedAt,
  });

  String get id => odlId;
  String get groupId => odlGroupId;
  String get userId => odlUserId;
  String get username => odlUsername;
  String? get userProfilePicture => odlUserProfilePicture;
  JoinRequestStatus get status => odlStatus;
  String? get message => odlMessage;
  DateTime get createdAt => odlCreatedAt;

  bool get isPending => odlStatus == JoinRequestStatus.pending;

  @override
  List<Object?> get props => [
        odlId,
        odlGroupId,
        odlUserId,
        odlUsername,
        odlUserProfilePicture,
        odlStatus,
        odlMessage,
        odlCreatedAt,
      ];
}

/// Group Entity
class GroupEntity extends Equatable {
  final String odlId;
  final String odlName;
  final String? odlDescription;
  final String odlTrailId;
  final String odlTrailName;
  final String? odlTrailImage;
  final DateTime odlStartDate;
  final DateTime? odlEndDate;
  final int odlMaxParticipants;
  final GroupStatus odlStatus;
  final List<GroupParticipant> odlParticipants;
  final MeetingPoint? odlMeetingPoint;
  final List<GroupComment> odlComments;
  final List<JoinRequest> odlJoinRequests;
  final String odlCreatorId;
  final DateTime odlCreatedAt;
  final DateTime odlUpdatedAt;

  const GroupEntity({
    required this.odlId,
    required this.odlName,
    this.odlDescription,
    required this.odlTrailId,
    required this.odlTrailName,
    this.odlTrailImage,
    required this.odlStartDate,
    this.odlEndDate,
    required this.odlMaxParticipants,
    required this.odlStatus,
    required this.odlParticipants,
    this.odlMeetingPoint,
    required this.odlComments,
    required this.odlJoinRequests,
    required this.odlCreatorId,
    required this.odlCreatedAt,
    required this.odlUpdatedAt,
  });

  // Getters
  String get id => odlId;
  String get name => odlName;
  String? get description => odlDescription;
  String get trailId => odlTrailId;
  String get trailName => odlTrailName;
  String? get trailImage => odlTrailImage;
  DateTime get startDate => odlStartDate;
  DateTime? get endDate => odlEndDate;
  int get maxParticipants => odlMaxParticipants;
  GroupStatus get status => odlStatus;
  List<GroupParticipant> get participants => odlParticipants;
  MeetingPoint? get meetingPoint => odlMeetingPoint;
  List<GroupComment> get comments => odlComments;
  List<JoinRequest> get joinRequests => odlJoinRequests;
  String get creatorId => odlCreatorId;
  DateTime get createdAt => odlCreatedAt;
  DateTime get updatedAt => odlUpdatedAt;

  // Computed properties
  int get currentParticipants => odlParticipants.length;
  int get availableSlots => odlMaxParticipants - currentParticipants;
  bool get isFull => currentParticipants >= odlMaxParticipants;
  bool get isForming => odlStatus == GroupStatus.forming;
  bool get isActive => odlStatus == GroupStatus.active;
  bool get isCompleted => odlStatus == GroupStatus.completed;

  GroupParticipant? get leader => odlParticipants.where((p) => p.isLeader).firstOrNull;

  bool isUserMember(String userId) => odlParticipants.any((p) => p.userId == userId);

  bool isUserLeader(String userId) =>
      odlParticipants.any((p) => p.userId == userId && p.isLeader);

  List<JoinRequest> get pendingRequests =>
      odlJoinRequests.where((r) => r.isPending).toList();

  String get participantCountText => '$currentParticipants/$odlMaxParticipants';

  String get formattedStartDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[odlStartDate.month - 1]} ${odlStartDate.day}, ${odlStartDate.year}';
  }

  @override
  List<Object?> get props => [
        odlId,
        odlName,
        odlDescription,
        odlTrailId,
        odlTrailName,
        odlTrailImage,
        odlStartDate,
        odlEndDate,
        odlMaxParticipants,
        odlStatus,
        odlParticipants,
        odlMeetingPoint,
        odlComments,
        odlJoinRequests,
        odlCreatorId,
        odlCreatedAt,
        odlUpdatedAt,
      ];
}

/// Filter params for groups
class GroupFilterParams extends Equatable {
  final GroupStatus? status;
  final String? trailId;
  final DateTime? startDateFrom;
  final DateTime? startDateTo;
  final bool? hasAvailableSlots;
  final GroupSortBy? sortBy;
  final bool? ascending;

  const GroupFilterParams({
    this.status,
    this.trailId,
    this.startDateFrom,
    this.startDateTo,
    this.hasAvailableSlots,
    this.sortBy,
    this.ascending,
  });

  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (status != null) params['status'] = status!.name;
    if (trailId != null) params['trailId'] = trailId!;
    if (startDateFrom != null) params['startDateFrom'] = startDateFrom!.toIso8601String();
    if (startDateTo != null) params['startDateTo'] = startDateTo!.toIso8601String();
    if (hasAvailableSlots != null) params['hasAvailableSlots'] = hasAvailableSlots.toString();
    if (sortBy != null) params['sortBy'] = sortBy!.name;
    if (ascending != null) params['ascending'] = ascending.toString();
    return params;
  }

  @override
  List<Object?> get props => [status, trailId, startDateFrom, startDateTo, hasAvailableSlots, sortBy, ascending];
}

/// Sort options for groups
enum GroupSortBy {
  name,
  startDate,
  participants,
  createdAt;

  String toDisplayString() {
    switch (this) {
      case GroupSortBy.name:
        return 'Name';
      case GroupSortBy.startDate:
        return 'Start Date';
      case GroupSortBy.participants:
        return 'Participants';
      case GroupSortBy.createdAt:
        return 'Created Date';
    }
  }
}
