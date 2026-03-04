import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/theme_repository.dart';
import '../bloc/theme_event.dart';
import '../bloc/theme_state.dart';

/// BLoC to manage theme state
///
/// Auto mode: uses ambient light sensor via platform channel (Android).
/// Threshold: < 20 lux → dark mode, ≥ 20 lux → light mode.
/// iOS fallback: time-based (7 PM–6 AM → dark).
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository _themeRepository;

  static const EventChannel _lightSensorChannel =
      EventChannel('com.samir.gotrek/light_sensor');

  StreamSubscription<dynamic>? _lightSub;

  /// Lux below this value = dark environment → dark mode
  static const int _darkLuxThreshold = 20;

  ThemeBloc({required ThemeRepository themeRepository})
      : _themeRepository = themeRepository,
        super(const ThemeInitial(themeMode: ThemeMode.system)) {
    on<LoadThemePreferenceEvent>(_onLoadThemePreference);
    on<SetLightThemeEvent>(_onSetLightTheme);
    on<SetDarkThemeEvent>(_onSetDarkTheme);
    on<SetSystemThemeEvent>(_onSetSystemTheme);
    on<SetAutoThemeEvent>(_onSetAutoTheme);
    on<LightSensorUpdateEvent>(_onLightSensorUpdate);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// iOS fallback: dark between 7 PM and 6 AM
  ThemeMode _timeBasedMode() {
    final hour = DateTime.now().hour;
    return (hour >= 19 || hour < 6) ? ThemeMode.dark : ThemeMode.light;
  }

  void _cancelLightSensor() {
    _lightSub?.cancel();
    _lightSub = null;
  }

  /// Start listening to ambient light sensor via platform channel (Android only).
  /// iOS falls back to time-based mode.
  void _startLightSensor() {
    _cancelLightSensor();
    if (!Platform.isAndroid) return;

    try {
      _lightSub = _lightSensorChannel.receiveBroadcastStream().listen(
        (dynamic value) {
          if (!isClosed && value is int) {
            add(LightSensorUpdateEvent(value));
          }
        },
        onError: (_) {
          // Sensor not available on this device — no-op
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Channel not available — no-op
    }
  }

  // ── Event handlers ────────────────────────────────────────────────────────

  Future<void> _onLoadThemePreference(
    LoadThemePreferenceEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final savedMode = await _themeRepository.getThemeMode();

      switch (savedMode) {
        case 'light':
          _cancelLightSensor();
          emit(const LightThemeState());
          break;
        case 'dark':
          _cancelLightSensor();
          emit(const DarkThemeState());
          break;
        case 'auto':
          // Android: wait for first sensor reading (start with system)
          // iOS: use time-based fallback immediately
          final initialMode =
              Platform.isAndroid ? ThemeMode.system : _timeBasedMode();
          emit(AutoThemeState(themeMode: initialMode));
          _startLightSensor();
          break;
        case 'system':
        default:
          _cancelLightSensor();
          emit(const SystemThemeState());
          break;
      }
    } catch (e) {
      emit(ThemeError(message: 'Failed to load theme: $e'));
    }
  }

  Future<void> _onSetLightTheme(
    SetLightThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    _cancelLightSensor();
    try {
      await _themeRepository.saveThemeMode('light');
      emit(const LightThemeState());
    } catch (e) {
      emit(ThemeError(message: 'Failed to set light theme: $e'));
    }
  }

  Future<void> _onSetDarkTheme(
    SetDarkThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    _cancelLightSensor();
    try {
      await _themeRepository.saveThemeMode('dark');
      emit(const DarkThemeState());
    } catch (e) {
      emit(ThemeError(message: 'Failed to set dark theme: $e'));
    }
  }

  Future<void> _onSetSystemTheme(
    SetSystemThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    _cancelLightSensor();
    try {
      await _themeRepository.saveThemeMode('system');
      emit(const SystemThemeState());
    } catch (e) {
      emit(ThemeError(message: 'Failed to set system theme: $e'));
    }
  }

  Future<void> _onSetAutoTheme(
    SetAutoThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await _themeRepository.saveThemeMode('auto');
      final initialMode =
          Platform.isAndroid ? ThemeMode.system : _timeBasedMode();
      emit(AutoThemeState(themeMode: initialMode));
      _startLightSensor();
    } catch (e) {
      emit(ThemeError(message: 'Failed to set auto theme: $e'));
    }
  }

  /// Called each time the ambient light sensor emits a new lux value.
  /// Emits only when the target mode actually changes — prevents redundant rebuilds.
  Future<void> _onLightSensorUpdate(
    LightSensorUpdateEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is! AutoThemeState) return;

    final targetMode =
        event.lux < _darkLuxThreshold ? ThemeMode.dark : ThemeMode.light;

    // Skip emit if already in the desired mode
    if ((state as AutoThemeState).themeMode == targetMode) return;

    emit(AutoThemeState(themeMode: targetMode));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    _cancelLightSensor();
    try {
      if (state is LightThemeState) {
        await _themeRepository.saveThemeMode('dark');
        emit(const DarkThemeState());
      } else {
        await _themeRepository.saveThemeMode('light');
        emit(const LightThemeState());
      }
    } catch (e) {
      emit(ThemeError(message: 'Failed to toggle theme: $e'));
    }
  }

  @override
  Future<void> close() {
    _cancelLightSensor();
    return super.close();
  }
}
