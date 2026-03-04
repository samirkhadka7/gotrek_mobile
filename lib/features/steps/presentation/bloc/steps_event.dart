part of 'steps_bloc.dart';

/// Base class for steps events
abstract class StepsEvent extends Equatable {
  const StepsEvent();

  @override
  List<Object?> get props => [];
}

/// Load today's step count
class LoadTodayStepsEvent extends StepsEvent {
  const LoadTodayStepsEvent();
}

/// Log steps manually
class LogStepsEvent extends StepsEvent {
  final int steps;
  final double? distance;
  final int? calories;

  const LogStepsEvent({
    required this.steps,
    this.distance,
    this.calories,
  });

  @override
  List<Object?> get props => [steps, distance, calories];
}

/// Load weekly statistics
class LoadWeeklyStatsEvent extends StepsEvent {
  const LoadWeeklyStatsEvent();
}

/// Load monthly statistics
class LoadMonthlyStatsEvent extends StepsEvent {
  const LoadMonthlyStatsEvent();
}

/// Sync steps from device pedometer
class SyncFromDeviceEvent extends StepsEvent {
  final int deviceSteps;

  const SyncFromDeviceEvent({required this.deviceSteps});

  @override
  List<Object?> get props => [deviceSteps];
}

/// Start a GPS trek session
class StartTrekSessionEvent extends StepsEvent {
  final String? trailId;
  final String? trailName;

  const StartTrekSessionEvent({this.trailId, this.trailName});

  @override
  List<Object?> get props => [trailId, trailName];
}

/// Stop the active GPS trek session
class StopTrekSessionEvent extends StepsEvent {
  const StopTrekSessionEvent();
}

/// Internal: update live distance + steps from GPS/pedometer timer
class _TrekDistanceUpdatedEvent extends StepsEvent {
  final double distanceMeters;
  final int liveSteps;
  final double elevationGain;
  final double elevationLoss;
  const _TrekDistanceUpdatedEvent(
    this.distanceMeters,
    this.liveSteps,
    this.elevationGain,
    this.elevationLoss,
  );

  @override
  List<Object?> get props => [distanceMeters, liveSteps, elevationGain, elevationLoss];
}

/// Update steps locally (for live tracking)
class UpdateLocalStepsEvent extends StepsEvent {
  final int steps;
  final double? distance;
  final int? calories;

  const UpdateLocalStepsEvent({
    required this.steps,
    this.distance,
    this.calories,
  });

  @override
  List<Object?> get props => [steps, distance, calories];
}
