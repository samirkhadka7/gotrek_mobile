/// Admin Trail Entity
class AdminTrailEntity {
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
  final int totalParticipants;
  final List<String>? ratings;

  const AdminTrailEntity({
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
    this.totalParticipants = 0,
    this.ratings,
  });
}

/// Trail list result for pagination
class TrailListResult {
  final List<AdminTrailEntity> trails;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const TrailListResult({
    required this.trails,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
