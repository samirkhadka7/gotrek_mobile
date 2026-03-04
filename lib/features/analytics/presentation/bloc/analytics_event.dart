import 'package:equatable/equatable.dart';

/// Base class for all analytics events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load analytics
class LoadAnalyticsEvent extends AnalyticsEvent {
  const LoadAnalyticsEvent();
}

/// Event to refresh analytics
class RefreshAnalyticsEvent extends AnalyticsEvent {
  const RefreshAnalyticsEvent();
}
