part of 'steps_bloc.dart';

/// Base class for steps states
abstract class StepsState extends Equatable {
  const StepsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class StepsInitial extends StepsState {
  const StepsInitial();
}

/// Loading state
class StepsLoading extends StepsState {
  const StepsLoading();
}

/// Saving state (when logging steps)
class StepsSaving extends StepsState {
  const StepsSaving();
}

/// Loaded state with today's record
class StepsLoaded extends StepsState {
  final StepRecord todayRecord;
  final StepsStats? weeklyStats;

  const StepsLoaded({
    required this.todayRecord,
    this.weeklyStats,
  });

  @override
  List<Object?> get props => [todayRecord, weeklyStats];
}

/// Stats loaded state
class StepsStatsLoaded extends StepsState {
  final StepsStats? weeklyStats;
  final StepsStats? monthlyStats;

  const StepsStatsLoaded({
    this.weeklyStats,
    this.monthlyStats,
  });

  @override
  List<Object?> get props => [weeklyStats, monthlyStats];
}

/// Active GPS trek session state
class TrekSessionActive extends StepsState {
  final String sessionId;
  final double liveDistanceMeters;
  final int liveSteps;
  final int locationCount;
  final double liveElevationGain;
  final double liveElevationLoss;

  const TrekSessionActive({
    required this.sessionId,
    this.liveDistanceMeters = 0.0,
    this.liveSteps = 0,
    this.locationCount = 0,
    this.liveElevationGain = 0.0,
    this.liveElevationLoss = 0.0,
  });

  @override
  List<Object?> get props => [
        sessionId,
        liveDistanceMeters,
        liveSteps,
        locationCount,
        liveElevationGain,
        liveElevationLoss,
      ];
}

/// Error state
class StepsError extends StepsState {
  final String message;

  const StepsError(this.message);

  @override
  List<Object?> get props => [message];
}
