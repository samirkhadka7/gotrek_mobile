import 'package:equatable/equatable.dart';

import '../../domain/entities/trail_entity.dart';

/// Base class for all trail events
abstract class TrailEvent extends Equatable {
  const TrailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all trails
class LoadTrailsEvent extends TrailEvent {
  final TrailFilterParams? filters;

  const LoadTrailsEvent({this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Event to refresh trails
class RefreshTrailsEvent extends TrailEvent {
  const RefreshTrailsEvent();
}

/// Event to load a single trail by ID
class LoadTrailDetailsEvent extends TrailEvent {
  final String trailId;

  const LoadTrailDetailsEvent({required this.trailId});

  @override
  List<Object?> get props => [trailId];
}

/// Event to search trails
class SearchTrailsEvent extends TrailEvent {
  final String query;

  const SearchTrailsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to clear search
class ClearSearchEvent extends TrailEvent {
  const ClearSearchEvent();
}

/// Event to apply filters
class ApplyFiltersEvent extends TrailEvent {
  final TrailFilterParams filters;

  const ApplyFiltersEvent({required this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Event to clear filters
class ClearFiltersEvent extends TrailEvent {
  const ClearFiltersEvent();
}

/// Event to load popular trails
class LoadPopularTrailsEvent extends TrailEvent {
  final int limit;

  const LoadPopularTrailsEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Event to load featured trails
class LoadFeaturedTrailsEvent extends TrailEvent {
  final int limit;

  const LoadFeaturedTrailsEvent({this.limit = 5});

  @override
  List<Object?> get props => [limit];
}

/// Event to join a trail
class JoinTrailEvent extends TrailEvent {
  final String trailId;
  final DateTime startDate;

  const JoinTrailEvent({
    required this.trailId,
    required this.startDate,
  });

  @override
  List<Object?> get props => [trailId, startDate];
}

/// Event to complete a trail
class CompleteTrailEvent extends TrailEvent {
  final String joinedTrailId;

  const CompleteTrailEvent({required this.joinedTrailId});

  @override
  List<Object?> get props => [joinedTrailId];
}

/// Event to cancel a joined trail
class CancelJoinedTrailEvent extends TrailEvent {
  final String joinedTrailId;

  const CancelJoinedTrailEvent({required this.joinedTrailId});

  @override
  List<Object?> get props => [joinedTrailId];
}

/// Event to rate a trail
class RateTrailEvent extends TrailEvent {
  final String trailId;
  final int rating;
  final String? review;

  const RateTrailEvent({
    required this.trailId,
    required this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [trailId, rating, review];
}
