import 'package:equatable/equatable.dart';

/// Base class for all activity events
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load recent activities
class LoadRecentActivitiesEvent extends ActivityEvent {
  const LoadRecentActivitiesEvent();
}

/// Event to refresh activities
class RefreshActivitiesEvent extends ActivityEvent {
  const RefreshActivitiesEvent();
}
