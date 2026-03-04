import 'package:hive/hive.dart';

import '../../../../core/constants/storage_constants.dart';
import '../../domain/entities/trail_entity.dart';

part 'trail_model.g.dart';

/// Trail Model - Data layer representation of a trail
@HiveType(typeId: StorageConstants.trailModelTypeId)
class TrailModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String? region;

  @HiveField(4)
  final double distance;

  @HiveField(5)
  final double elevation;

  @HiveField(6)
  final DurationModel? duration;

  @HiveField(7)
  final int? durationDays;

  @HiveField(8)
  final String difficulty;

  @HiveField(9)
  final String? description;

  @HiveField(10)
  final List<String> highlights;

  @HiveField(11)
  final List<String> images;

  @HiveField(12)
  final List<String> features;

  @HiveField(13)
  final List<String> seasons;

  @HiveField(14)
  final List<RatingModel> ratings;

  @HiveField(15)
  final double averageRating;

  @HiveField(16)
  final int numRatings;

  @HiveField(17)
  final DateTime createdAt;

  @HiveField(18)
  final DateTime updatedAt;

  TrailModel({
    required this.id,
    required this.name,
    required this.location,
    this.region,
    required this.distance,
    required this.elevation,
    this.duration,
    this.durationDays,
    required this.difficulty,
    this.description,
    this.highlights = const [],
    this.images = const [],
    this.features = const [],
    this.seasons = const [],
    this.ratings = const [],
    this.averageRating = 0.0,
    this.numRatings = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory TrailModel.fromJson(Map<String, dynamic> json) {
    List<String> stringListFromJson(dynamic value) {
      if (value is! List) return const [];
      return value
          .map((item) {
            if (item is String) return item;
            if (item is Map && item['url'] is String) return item['url'] as String;
            if (item is Map && item['path'] is String) return item['path'] as String;
            return item?.toString() ?? '';
          })
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return TrailModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      region: json['region'],
      distance: (json['distance'] ?? 0).toDouble(),
      elevation: (json['elevation'] ?? 0).toDouble(),
      duration: json['duration'] != null
          ? DurationModel.fromJson(json['duration'])
          : null,
      durationDays: json['durationDays'],
      difficulty: json['difficulty'] ?? 'Moderate',
      description: json['description'],
      highlights: stringListFromJson(json['highlights']),
      images: stringListFromJson(json['images']),
      features: stringListFromJson(json['features']),
      seasons: stringListFromJson(json['seasons']),
      ratings: (json['ratings'] as List?)
              ?.map((r) => RatingModel.fromJson(r))
              .toList() ??
          [],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      numRatings: json['numRatings'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'location': location,
      'region': region,
      'distance': distance,
      'elevation': elevation,
      'duration': duration?.toJson(),
      'durationDays': durationDays,
      'difficulty': difficulty,
      'description': description,
      'highlights': highlights,
      'images': images,
      'features': features,
      'seasons': seasons,
      'ratings': ratings.map((r) => r.toJson()).toList(),
      'averageRating': averageRating,
      'numRatings': numRatings,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Convert to Entity
  TrailEntity toEntity() {
    return TrailEntity(
      id: id,
      name: name,
      location: location,
      region: region,
      distance: distance,
      elevation: elevation,
      duration: duration?.toEntity(),
      durationDays: durationDays,
      difficulty: TrailDifficulty.fromString(difficulty),
      description: description,
      highlights: highlights,
      images: images,
      features: features,
      seasons: seasons,
      ratings: ratings.map((r) => r.toEntity()).toList(),
      averageRating: averageRating,
      numRatings: numRatings,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from Entity
  factory TrailModel.fromEntity(TrailEntity entity) {
    return TrailModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      region: entity.region,
      distance: entity.distance,
      elevation: entity.elevation,
      duration: entity.duration != null
          ? DurationModel.fromEntity(entity.duration!)
          : null,
      durationDays: entity.durationDays,
      difficulty: entity.difficulty.toDisplayString(),
      description: entity.description,
      highlights: entity.highlights,
      images: entity.images,
      features: entity.features,
      seasons: entity.seasons,
      ratings: entity.ratings.map((r) => RatingModel.fromEntity(r)).toList(),
      averageRating: entity.averageRating,
      numRatings: entity.numRatings,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

/// Duration Model for trail duration range
@HiveType(typeId: StorageConstants.durationModelTypeId)
class DurationModel extends HiveObject {
  @HiveField(0)
  final int min;

  @HiveField(1)
  final int max;

  DurationModel({
    required this.min,
    required this.max,
  });

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }

  DurationEntity toEntity() {
    return DurationEntity(min: min, max: max);
  }

  factory DurationModel.fromEntity(DurationEntity entity) {
    return DurationModel(min: entity.min, max: entity.max);
  }
}

/// Rating Model for trail ratings
@HiveType(typeId: StorageConstants.ratingModelTypeId)
class RatingModel extends HiveObject {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final int rating;

  @HiveField(2)
  final String? review;

  @HiveField(3)
  final DateTime createdAt;

  RatingModel({
    this.userId,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: json['user']?['_id'] ?? json['user'],
      rating: json['rating'] ?? 0,
      review: json['review'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  RatingEntity toEntity() {
    return RatingEntity(
      userId: userId,
      rating: rating,
      review: review,
      createdAt: createdAt,
    );
  }

  factory RatingModel.fromEntity(RatingEntity entity) {
    return RatingModel(
      userId: entity.userId,
      rating: entity.rating,
      review: entity.review,
      createdAt: entity.createdAt,
    );
  }
}
