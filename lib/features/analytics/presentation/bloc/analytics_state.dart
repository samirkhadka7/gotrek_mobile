import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics_entity.dart';

/// Base class for all analytics states
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AnalyticsInitial extends AnalyticsState{
  const AnalyticsInitial();
}

/// Loading state
class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

/// Analytics loaded successfully
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsEntity analytics;

  const AnalyticsLoaded(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

/// Error state
class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
