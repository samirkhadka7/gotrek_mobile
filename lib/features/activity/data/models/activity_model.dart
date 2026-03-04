import '../../domain/entities/activity_entity.dart';

/// Activity model for data layer
class ActivityModel {
  final String id;
  final String type;
  final String user;
  final String? avatar;
  final String? trail;
  final DateTime time;

  ActivityModel({
    required this.id,
    required this.type,
    required this.user,
    this.avatar,
    this.trail,
    required this.time,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      user: json['user'] ?? '',
      avatar: json['avatar'],
      trail: json['trail'],
      time: DateTime.parse(json['time'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'user': user,
      'avatar': avatar,
      'trail': trail,
      'time': time.toIso8601String(),
    };
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      type: _parseActivityType(type),
      user: user,
      avatar: avatar,
      trail: trail,
      time: time,
    );
  }

  static ActivityType _parseActivityType(String type) {
    switch (type) {
      case 'user_joined':
        return ActivityType.userJoined;
      case 'group_created':
        return ActivityType.groupCreated;
      case 'hike_joined':
        return ActivityType.hikeJoined;
      case 'hike_completed':
        return ActivityType.hikeCompleted;
      case 'hike_cancelled':
        return ActivityType.hikeCancelled;
      default:
        return ActivityType.userJoined;
    }
  }
}
