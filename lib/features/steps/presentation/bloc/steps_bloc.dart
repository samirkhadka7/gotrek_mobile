import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/gps_tracking_service.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/steps_local_datasource.dart';
import '../../data/models/steps_model.dart';
import '../../domain/entities/steps_entity.dart';
import '../../domain/usecases/get_steps_stats.dart';
import '../../domain/usecases/get_today_steps.dart';
import '../../domain/usecases/log_steps.dart';

part 'steps_event.dart';
part 'steps_state.dart';

/// BLoC for steps tracking
class StepsBloc extends Bloc<StepsEvent, StepsState> {
  final GetTodayStepsUseCase getTodayStepsUseCase;
  final LogStepsUseCase logStepsUseCase;
  final GetWeeklyStatsUseCase getWeeklyStatsUseCase;
  final GetMonthlyStatsUseCase getMonthlyStatsUseCase;
  final GpsTrackingService gpsTrackingService;
  final StepsLocalDataSource localDataSource;

  Timer? _liveUpdateTimer;
  DateTime? _trekStartTime;

  StepsBloc({
    required this.getTodayStepsUseCase,
    required this.logStepsUseCase,
    required this.getWeeklyStatsUseCase,
    required this.getMonthlyStatsUseCase,
    required this.gpsTrackingService,
    required this.localDataSource,
  }) : super(const StepsInitial()) {
    on<LoadTodayStepsEvent>(_onLoadTodaySteps);
    on<LogStepsEvent>(_onLogSteps);
    on<LoadWeeklyStatsEvent>(_onLoadWeeklyStats);
    on<LoadMonthlyStatsEvent>(_onLoadMonthlyStats);
    on<SyncFromDeviceEvent>(_onSyncFromDevice);
    on<UpdateLocalStepsEvent>(_onUpdateLocalSteps);
    on<StartTrekSessionEvent>(_onStartTrekSession);
    on<StopTrekSessionEvent>(_onStopTrekSession);
    on<_TrekDistanceUpdatedEvent>(_onTrekDistanceUpdated);
  }

  @override
  Future<void> close() {
    _liveUpdateTimer?.cancel();
    return super.close();
  }

  Future<void> _onLoadTodaySteps(
    LoadTodayStepsEvent event,
    Emitter<StepsState> emit,
  ) async {
    emit(const StepsLoading());

    final result = await getTodayStepsUseCase(const NoParams());

    result.fold(
      (failure) => emit(StepsError(failure.message)),
      (record) => emit(StepsLoaded(
        todayRecord: record,
        weeklyStats: state is StepsLoaded
            ? (state as StepsLoaded).weeklyStats
            : null,
      )),
    );
  }

  Future<void> _onLogSteps(
    LogStepsEvent event,
    Emitter<StepsState> emit,
  ) async {
    final currentState = state;

    emit(const StepsSaving());

    final result = await logStepsUseCase(LogStepsParams(
      steps: event.steps,
      distance: event.distance,
      calories: event.calories,
    ));

    result.fold(
      (failure) => emit(StepsError(failure.message)),
      (record) => emit(StepsLoaded(
        todayRecord: record,
        weeklyStats: currentState is StepsLoaded
            ? currentState.weeklyStats
            : null,
      )),
    );
  }

  Future<void> _onLoadWeeklyStats(
    LoadWeeklyStatsEvent event,
    Emitter<StepsState> emit,
  ) async {
    final currentState = state;

    final result = await getWeeklyStatsUseCase(const NoParams());

    result.fold(
      (failure) {
        // Keep current state but show error
        if (currentState is StepsLoaded) {
          emit(currentState);
        }
      },
      (stats) {
        if (currentState is StepsLoaded) {
          emit(StepsLoaded(
            todayRecord: currentState.todayRecord,
            weeklyStats: stats,
          ));
        } else {
          emit(StepsStatsLoaded(weeklyStats: stats));
        }
      },
    );
  }

  Future<void> _onLoadMonthlyStats(
    LoadMonthlyStatsEvent event,
    Emitter<StepsState> emit,
  ) async {
    final result = await getMonthlyStatsUseCase(const NoParams());

    result.fold(
      (failure) => emit(StepsError(failure.message)),
      (stats) => emit(StepsStatsLoaded(monthlyStats: stats)),
    );
  }

  Future<void> _onSyncFromDevice(
    SyncFromDeviceEvent event,
    Emitter<StepsState> emit,
  ) async {
    // In a real app, this would sync with pedometer/health data
    // For now, just update with the provided steps
    add(LogStepsEvent(steps: event.deviceSteps));
  }

  void _onUpdateLocalSteps(
    UpdateLocalStepsEvent event,
    Emitter<StepsState> emit,
  ) {
    final currentState = state;
    if (currentState is StepsLoaded) {
      // Create updated record with new steps
      final updatedRecord = StepRecord(
        id: currentState.todayRecord.id,
        steps: event.steps,
        distance: event.distance ?? currentState.todayRecord.distance,
        calories: event.calories ?? currentState.todayRecord.calories,
        date: currentState.todayRecord.date,
        activeMinutes: currentState.todayRecord.activeMinutes,
        goal: currentState.todayRecord.goal,
      );

      emit(StepsLoaded(
        todayRecord: updatedRecord,
        weeklyStats: currentState.weeklyStats,
      ));
    }
  }

  /// Start GPS trek session
  Future<void> _onStartTrekSession(
    StartTrekSessionEvent event,
    Emitter<StepsState> emit,
  ) async {
    final granted = await gpsTrackingService.requestPermission();
    if (!granted) {
      // Don't show error screen — just reload steps page with a message via state
      add(const LoadTodayStepsEvent());
      return;
    }

    await gpsTrackingService.startTracking();
    _trekStartTime = DateTime.now();
    emit(const TrekSessionActive(sessionId: 'local_session'));

    // Use add() so emit is called inside its own event handler (not this one)
    _liveUpdateTimer?.cancel();
    _liveUpdateTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (state is TrekSessionActive) {
        add(_TrekDistanceUpdatedEvent(
          gpsTrackingService.distanceMeters,
          gpsTrackingService.stepsSinceStart,
          gpsTrackingService.elevationGain,
          gpsTrackingService.elevationLoss,
        ));
      }
    });
  }

  /// Internal: update live distance + steps display
  void _onTrekDistanceUpdated(
    _TrekDistanceUpdatedEvent event,
    Emitter<StepsState> emit,
  ) {
    if (state is TrekSessionActive) {
      final current = state as TrekSessionActive;
      emit(TrekSessionActive(
        sessionId: current.sessionId,
        liveDistanceMeters: event.distanceMeters,
        liveSteps: event.liveSteps,
        locationCount: current.locationCount,
        liveElevationGain: event.elevationGain,
        liveElevationLoss: event.elevationLoss,
      ));
    }
  }

  /// Stop GPS trek session and log distance + real sensor steps
  Future<void> _onStopTrekSession(
    StopTrekSessionEvent event,
    Emitter<StepsState> emit,
  ) async {
    _liveUpdateTimer?.cancel();
    _liveUpdateTimer = null;

    // Read values BEFORE stopTracking() resets them to 0
    final totalDistanceMeters = gpsTrackingService.distanceMeters;
    final realSteps = gpsTrackingService.stepsSinceStart;
    await gpsTrackingService.stopTracking();

    final distanceKm = totalDistanceMeters / 1000;
    final calories = (realSteps * 0.04).round();
    final activeMinutes = _trekStartTime != null
        ? DateTime.now().difference(_trekStartTime!).inMinutes
        : 0;
    _trekStartTime = null;

    final record = StepRecordModel(
      modelId: 'trek_${DateTime.now().millisecondsSinceEpoch}',
      modelSteps: realSteps,
      modelDistance: distanceKm,
      modelCalories: calories,
      modelDate: DateTime.now(),
      modelActiveMinutes: activeMinutes,
      modelGoal: 10000,
    );

    // Persist to local cache (Hive) so it survives navigation/restart
    await localDataSource.cacheTodaySteps(record);

    // Show result immediately (don't wait for backend)
    emit(StepsLoaded(
      todayRecord: record,
      weeklyStats: null,
    ));

    // Sync to backend in background (fire-and-forget)
    logStepsUseCase(LogStepsParams(
      steps: realSteps,
      distance: distanceKm,
      calories: calories,
    ));
  }
}
