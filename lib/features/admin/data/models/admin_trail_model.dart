import '../../domain/entities/admin_trail_entity.dart';

/// Trail Model for data layer
class AdminTrailModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final double distance;
  final double elevation;
  final String difficulty;
  final String duration;
  final bool isPublic;
  final String? imageUrl;
  final String? createdBy;
  final DateTime createdAt;
  final Map<String, dynamic>? stats;

  AdminTrailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.distance,
    required this.elevation,
    required this.difficulty,
    required this.duration,
    required this.isPublic,
    this.imageUrl,
    this.createdBy,
    required this.createdAt,
    this.stats,
  });

  factory AdminTrailModel.fromJson(Map<String, dynamic> json) {
    String parseDuration(dynamic value) {
      if (value is String) return value;
      if (value is Map) {
        final min = value['min'];
        final max = value['max'];
        if (min != null && max != null) return '$min-$max';
        if (min != null) return min.toString();
        if (max != null) return max.toString();
      }
      return '';
    }

    String? parseImageUrl(dynamic value) {
      if (value is String) return value;
      if (value is List && value.isNotEmpty) {
        final first = value.first;
        if (first is String) return first;
        if (first is Map && first['url'] is String) return first['url'] as String;
        if (first is Map && first['path'] is String) return first['path'] as String;
      }
      return null;
    }

    return AdminTrailModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      elevation: (json['elevation'] ?? 0).toDouble(),
      difficulty: json['difficulty'] ?? 'Moderate',
      duration: parseDuration(json['duration']),
      isPublic: json['isPublic'] ?? true,
      imageUrl: parseImageUrl(json['imageUrl'] ?? json['images']),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      stats: json['stats'],
    );
  }

  AdminTrailEntity toEntity() {
    return AdminTrailEntity(
      id: id,
      name: name,
      description: description,
      location: location,
      distance: distance,
      elevation: elevation,
      difficulty: difficulty,
      duration: duration,
      isPublic: isPublic,
      imageUrl: imageUrl,
      createdBy: createdBy,
      createdAt: createdAt,
      totalParticipants: stats?['totalParticipants'] ?? 0,
    );
  }
}

/// Trail List Result Model
class TrailListResultModel {
  final List<AdminTrailModel> trails;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  TrailListResultModel({
    required this.trails,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory TrailListResultModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> trailsData = json['data'] ?? [];
    final pagination = json['pagination'] ?? {};

    return TrailListResultModel(
      trails: trailsData.map((trail) => AdminTrailModel.fromJson(trail)).toList(),
      total: pagination['total'] ?? 0,
      page: pagination['page'] ?? 1,
      limit: pagination['limit'] ?? 10,
      totalPages: pagination['totalPages'] ?? 0,
    );
  }

  TrailListResult toEntity() {
    return TrailListResult(
      trails: trails.map((model) => model.toEntity()).toList(),
      total: total,
      page: page,
      limit: limit,
      totalPages: totalPages,
    );
  }
}
