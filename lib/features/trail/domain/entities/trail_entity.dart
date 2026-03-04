import 'package:equatable/equatable.dart';

import '../../../../core/constants/api_constants.dart';

/// Trail Entity - Domain layer representation of a trail
class TrailEntity extends Equatable {
  final String id;
  final String name;
  final String location;
  final String? region;
  final double distance;
  final double elevation;
  final DurationEntity? duration;
  final int? durationDays;
  final TrailDifficulty difficulty;
  final String? description;
  final List<String> highlights;
  final List<String> images;
  final List<String> features;
  final List<String> seasons;
  final List<RatingEntity> ratings;
  final double averageRating;
  final int numRatings;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TrailEntity({
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

  /// Get first image or default placeholder with full URL
  String get primaryImage {
    if (images.isEmpty) {
      return 'https://via.placeholder.com/400x300?text=No+Image';
    }
    return _getFullImageUrl(images.first);
  }

  /// Get all images as full URLs
  List<String> get allImagesWithFullUrls => images.map(_getFullImageUrl).toList();

  /// Convert relative image path to full URL
  String _getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return 'https://via.placeholder.com/400x300?text=No+Image';
    }
    
    // Already a full URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Handle absolute local file paths that include uploads folder
    final uploadsIndex = imagePath.indexOf('/uploads/');
    if (uploadsIndex != -1) {
      final relativePath = imagePath.substring(uploadsIndex);
      return '${ApiConstants.serverUrl}$relativePath';
    }
    
    // Convert relative path to full URL
    if (imagePath.startsWith('/')) {
      return '${ApiConstants.serverUrl}$imagePath';
    }
    
    // If no leading slash, add it
    return '${ApiConstants.serverUrl}/$imagePath';
  }

  /// Get formatted distance string
  String get formattedDistance => '${distance.toStringAsFixed(1)} km';

  /// Get formatted elevation string
  String get formattedElevation => '${elevation.toInt()} m';

  /// Get formatted duration string
  String get formattedDuration {
    if (durationDays != null) {
      return '$durationDays days';
    }
    if (duration != null) {
      if (duration!.min == duration!.max) {
        return '${duration!.min} hours';
      }
      return '${duration!.min}-${duration!.max} hours';
    }
    return 'Unknown';
  }

  /// Check if trail has good ratings
  bool get isHighlyRated => averageRating >= 4.0 && numRatings >= 5;

  /// Check if trail is suitable for the season
  bool isSuitableForSeason(String season) =>
      seasons.isEmpty || seasons.contains(season);

  @override
  List<Object?> get props => [
        id,
        name,
        location,
        region,
        distance,
        elevation,
        duration,
        durationDays,
        difficulty,
        description,
        highlights,
        images,
        features,
        seasons,
        ratings,
        averageRating,
        numRatings,
        createdAt,
        updatedAt,
      ];
}

/// Duration entity for trail duration range
class DurationEntity extends Equatable {
  final int min;
  final int max;

  const DurationEntity({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];
}

/// Rating entity for trail ratings
class RatingEntity extends Equatable {
  final String? userId;
  final int rating;
  final String? review;
  final DateTime createdAt;

  const RatingEntity({
    this.userId,
    required this.rating,
    this.review,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [userId, rating, review, createdAt];
}

/// Trail difficulty enum
enum TrailDifficulty {
  easy,
  moderate,
  hard;

  /// Convert from string
  static TrailDifficulty fromString(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return TrailDifficulty.easy;
      case 'moderate':
        return TrailDifficulty.moderate;
      case 'hard':
        return TrailDifficulty.hard;
      default:
        return TrailDifficulty.moderate;
    }
  }

  /// Convert to string
  String toDisplayString() {
    switch (this) {
      case TrailDifficulty.easy:
        return 'Easy';
      case TrailDifficulty.moderate:
        return 'Moderate';
      case TrailDifficulty.hard:
        return 'Hard';
    }
  }

  /// Get color for difficulty
  int get colorValue {
    switch (this) {
      case TrailDifficulty.easy:
        return 0xFF4CAF50; // Green
      case TrailDifficulty.moderate:
        return 0xFFFF9800; // Orange
      case TrailDifficulty.hard:
        return 0xFFF44336; // Red
    }
  }
}

/// Trail filter params for search/filter
class TrailFilterParams extends Equatable {
  final String? searchQuery;
  final TrailDifficulty? difficulty;
  final double? minDistance;
  final double? maxDistance;
  final double? minElevation;
  final double? maxElevation;
  final String? region;
  final String? season;
  final double? minRating;
  final int? page;
  final int? limit;
  final TrailSortBy? sortBy;
  final bool? ascending;

  const TrailFilterParams({
    this.searchQuery,
    this.difficulty,
    this.minDistance,
    this.maxDistance,
    this.minElevation,
    this.maxElevation,
    this.region,
    this.season,
    this.minRating,
    this.page,
    this.limit,
    this.sortBy,
    this.ascending,
  });

  /// Create copy with new values
  TrailFilterParams copyWith({
    String? searchQuery,
    TrailDifficulty? difficulty,
    double? minDistance,
    double? maxDistance,
    double? minElevation,
    double? maxElevation,
    String? region,
    String? season,
    double? minRating,
    int? page,
    int? limit,
    TrailSortBy? sortBy,
    bool? ascending,
  }) {
    return TrailFilterParams(
      searchQuery: searchQuery ?? this.searchQuery,
      difficulty: difficulty ?? this.difficulty,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      minElevation: minElevation ?? this.minElevation,
      maxElevation: maxElevation ?? this.maxElevation,
      region: region ?? this.region,
      season: season ?? this.season,
      minRating: minRating ?? this.minRating,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  /// Convert to query parameters map
  Map<String, String> toQueryParams() {
    final params = <String, String>{};

    if (searchQuery != null && searchQuery!.isNotEmpty) {
      params['search'] = searchQuery!;
    }
    if (difficulty != null) {
      params['difficulty'] = difficulty!.toDisplayString();
    }
    if (minDistance != null) {
      params['minDistance'] = minDistance.toString();
    }
    if (maxDistance != null) {
      params['maxDistance'] = maxDistance.toString();
    }
    if (minElevation != null) {
      params['minElevation'] = minElevation.toString();
    }
    if (maxElevation != null) {
      params['maxElevation'] = maxElevation.toString();
    }
    if (region != null && region!.isNotEmpty) {
      params['region'] = region!;
    }
    if (season != null && season!.isNotEmpty) {
      params['season'] = season!;
    }
    if (minRating != null) {
      params['minRating'] = minRating.toString();
    }
    if (page != null) {
      params['page'] = page.toString();
    }
    if (limit != null) {
      params['limit'] = limit.toString();
    }
    if (sortBy != null) {
      params['sortBy'] = sortBy!.value;
    }
    if (ascending != null) {
      params['order'] = ascending! ? 'asc' : 'desc';
    }

    return params;
  }

  @override
  List<Object?> get props => [
        searchQuery,
        difficulty,
        minDistance,
        maxDistance,
        minElevation,
        maxElevation,
        region,
        season,
        minRating,
        page,
        limit,
        sortBy,
        ascending,
      ];
}

/// Sort options for trails
enum TrailSortBy {
  name('name'),
  distance('distance'),
  elevation('elevation'),
  difficulty('difficulty'),
  rating('averageRating'),
  newest('createdAt');

  final String value;
  const TrailSortBy(this.value);
}
