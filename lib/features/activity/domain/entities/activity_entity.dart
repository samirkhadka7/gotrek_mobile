/// Activity types
enum ActivityType {
  userJoined,
  groupCreated,
  hikeJoined,
  hikeCompleted,
  hikeCancelled,
}

/// Activity Entity
class ActivityEntity {
  final String id;
  final ActivityType type;
  final String user;
  final String? avatar;
  final String? trail;
  final DateTime time;

  const ActivityEntity({
    required this.id,
    required this.type,
    required this.user,
    this.avatar,
    this.trail,
    required this.time,
  });

  // Get display text based on activity type
  String get displayText {
    switch (type) {
      case ActivityType.userJoined:
        return '$user joined GoTrek';
      case ActivityType.groupCreated:
        return '$user created a group${trail != null ? ' for $trail' : ''}';
      case ActivityType.hikeJoined:
        return '$user joined ${trail ?? 'a trek'}';
      case ActivityType.hikeCompleted:
        return '$user completed ${trail ?? 'a trek'}';
      case ActivityType.hikeCancelled:
        return '$user cancelled ${trail ?? 'a trek'}';
    }
  }

  // Get icon based on activity type
  String get icon {
    switch (type) {
      case ActivityType.userJoined:
        return '👋';
      case ActivityType.groupCreated:
        return '👥';
      case ActivityType.hikeJoined:
        return '🥾';
      case ActivityType.hikeCompleted:
        return '✅';
      case ActivityType.hikeCancelled:
        return '❌';
    }
  }
}
