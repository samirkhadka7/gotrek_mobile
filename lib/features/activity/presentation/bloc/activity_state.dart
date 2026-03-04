import 'package:equatable/equatable.dart';
import '../../domain/entities/activity_entity.dart';

/// Base class for all activity states
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ActivityInitial extends ActivityState {
  const ActivityInitial();
}

/// Loading state
class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

/// Activities loaded successfully
class ActivityLoaded extends ActivityState {
  final List<ActivityEntity> activities;

  const ActivityLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

/// Error state
class ActivityError extends ActivityState {
  final String message;

  const ActivityError(this.message);

  @override
  List<Object?> get props => [message];
}
