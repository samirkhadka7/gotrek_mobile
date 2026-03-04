import 'package:equatable/equatable.dart';

import '../../domain/entities/trail_entity.dart';

/// Base class for all trail states
abstract class TrailState extends Equatable {
  const TrailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TrailInitial extends TrailState {
  const TrailInitial();
}

/// Loading state for trails list
class TrailsLoading extends TrailState {
  final String? message;

  const TrailsLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Trails loaded successfully
class TrailsLoaded extends TrailState {
  final List<TrailEntity> trails;
  final TrailFilterParams? activeFilters;
  final bool isFromCache;

  const TrailsLoaded({
    required this.trails,
    this.activeFilters,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [trails, activeFilters, isFromCache];
}

/// Trail details loading
class TrailDetailsLoading extends TrailState {
  const TrailDetailsLoading();
}

/// Trail details loaded successfully
class TrailDetailsLoaded extends TrailState {
  final TrailEntity trail;

  const TrailDetailsLoaded({required this.trail});

  @override
  List<Object?> get props => [trail];
}

/// Search results state
class TrailSearchResults extends TrailState {
  final List<TrailEntity> results;
  final String query;

  const TrailSearchResults({
    required this.results,
    required this.query,
  });

  @override
  List<Object?> get props => [results, query];
}

/// Popular trails loaded
class PopularTrailsLoaded extends TrailState {
  final List<TrailEntity> trails;

  const PopularTrailsLoaded({required this.trails});

  @override
  List<Object?> get props => [trails];
}

/// Featured trails loaded
class FeaturedTrailsLoaded extends TrailState {
  final List<TrailEntity> trails;

  const FeaturedTrailsLoaded({required this.trails});

  @override
  List<Object?> get props => [trails];
}

/// Trail operation in progress (join, complete, cancel, rate)
class TrailOperationInProgress extends TrailState {
  final String operation;
  final String trailId;

  const TrailOperationInProgress({
    required this.operation,
    required this.trailId,
  });

  @override
  List<Object?> get props => [operation, trailId];
}

/// Trail operation successful
class TrailOperationSuccess extends TrailState {
  final String operation;
  final String message;

  const TrailOperationSuccess({
    required this.operation,
    required this.message,
  });

  @override
  List<Object?> get props => [operation, message];
}

/// Trail error state
class TrailError extends TrailState {
  final String message;
  final TrailErrorType type;

  const TrailError({
    required this.message,
    this.type = TrailErrorType.unknown,
  });

  @override
  List<Object?> get props => [message, type];
}

/// Types of trail errors
enum TrailErrorType {
  unknown,
  network,
  server,
  notFound,
  unauthorized,
  noCache,
}

/// Extension to map error messages to types
extension TrailErrorTypeExtension on TrailErrorType {
  static TrailErrorType fromMessage(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('network') || lowerMessage.contains('connection')) {
      return TrailErrorType.network;
    }
    if (lowerMessage.contains('not found') || lowerMessage.contains('404')) {
      return TrailErrorType.notFound;
    }
    if (lowerMessage.contains('unauthorized') || lowerMessage.contains('401')) {
      return TrailErrorType.unauthorized;
    }
    if (lowerMessage.contains('cache') || lowerMessage.contains('no data')) {
      return TrailErrorType.noCache;
    }
    if (lowerMessage.contains('server') || lowerMessage.contains('500')) {
      return TrailErrorType.server;
    }

    return TrailErrorType.unknown;
  }
}
