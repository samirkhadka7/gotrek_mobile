import 'package:equatable/equatable.dart';

/// Base event for Admin Trail
abstract class AdminTrailEvent extends Equatable {
  const AdminTrailEvent();

  @override
  List<Object?> get props => [];
}

/// Load all trails with filters
class LoadAllTrailsEvent extends AdminTrailEvent {
  final int page;
  final int limit;
  final String? search;
  final double? maxDistance;
  final double? maxElevation;
  final String? difficulty;

  const LoadAllTrailsEvent({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.maxDistance,
    this.maxElevation,
    this.difficulty,
  });

  @override
  List<Object?> get props =>
      [page, limit, search, maxDistance, maxElevation, difficulty];
}

/// Load trail details by ID
class LoadTrailDetailsEvent extends AdminTrailEvent {
  final String trailId;

  const LoadTrailDetailsEvent(this.trailId);

  @override
  List<Object?> get props => [trailId];
}

/// Create new trail
class CreateTrailEvent extends AdminTrailEvent {
  final String name;
  final String description;
  final String location;
  final double distance;
  final double elevation;
  final String difficulty;
  final int? durationMin;
  final int? durationMax;
  final List<String> imagePaths;

  const CreateTrailEvent({
    required this.name,
    required this.description,
    required this.location,
    required this.distance,
    required this.elevation,
    required this.difficulty,
    this.durationMin,
    this.durationMax,
    this.imagePaths = const [],
  });

  @override
  List<Object?> get props => [
    name,
    description,
    location,
    distance,
    elevation,
    difficulty,
    durationMin,
    durationMax,
    imagePaths,
  ];
}

/// Update trail
class UpdateTrailEvent extends AdminTrailEvent {
  final String trailId;
  final String name;
  final String description;
  final String location;
  final double distance;
  final double elevation;
  final String difficulty;
  final int? durationMin;
  final int? durationMax;
  final List<String> imagePaths;

  const UpdateTrailEvent({
    required this.trailId,
    required this.name,
    required this.description,
    required this.location,
    required this.distance,
    required this.elevation,
    required this.difficulty,
    this.durationMin,
    this.durationMax,
    this.imagePaths = const [],
  });

  @override
  List<Object?> get props => [
    trailId,
    name,
    description,
    location,
    distance,
    elevation,
    difficulty,
    durationMin,
    durationMax,
    imagePaths,
  ];
}

/// Delete trail
class DeleteTrailEvent extends AdminTrailEvent {
  final String trailId;

  const DeleteTrailEvent(this.trailId);

  @override
  List<Object?> get props => [trailId];
}

/// Refresh trails list
class RefreshTrailsEvent extends AdminTrailEvent {
  const RefreshTrailsEvent();
}
