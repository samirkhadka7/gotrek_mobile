import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/steps/domain/entities/steps_entity.dart';
import 'barometer_service.dart';

/// Service that handles foreground GPS tracking + pedometer step counting
/// + barometer elevation tracking during a trek session.
class GpsTrackingService {
  final BarometerService _barometerService;

  GpsTrackingService({required BarometerService barometerService})
      : _barometerService = barometerService;
  // ── GPS ────────────────────────────────────────────────────────────
  StreamSubscription<Position>? _positionSub;
  Position? _lastPosition;
  double _totalDistanceMeters = 0.0;
  final List<LocationPoint> _route = [];
  bool _isTracking = false;

  // ── Pedometer ──────────────────────────────────────────────────────
  StreamSubscription<StepCount>? _stepSub;
  int _stepsAtStart = 0;
  int _latestStepCount = 0;
  bool _hasInitialReading = false;

  // ── Public getters ─────────────────────────────────────────────────
  bool get isTracking => _isTracking;
  double get distanceMeters => _totalDistanceMeters;
  LocationPoint? get currentLocation =>
      _route.isNotEmpty ? _route.last : null;

  /// Real steps counted by device sensor since tracking started.
  /// Falls back to GPS-estimated steps if sensor unavailable.
  int get stepsSinceStart {
    if (_hasInitialReading) {
      return _latestStepCount - _stepsAtStart;
    }
    // Fallback: estimate from GPS distance (~1250 steps/km average)
    return (_totalDistanceMeters / 1000 * 1250).round();
  }

  /// Whether pedometer sensor is providing data
  bool get hasPedometerData => _hasInitialReading;

  // ── Barometer / Elevation ─────────────────────────────────────────
  double get elevationGain => _barometerService.elevationGain;
  double get elevationLoss => _barometerService.elevationLoss;
  bool get hasBarometerData => _barometerService.sensorAvailable;

  /// Request location + activity recognition permissions.
  /// Returns true only if location permission granted AND location service ON.
  Future<bool> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    final locationStatus = await Permission.location.request();
    if (!locationStatus.isGranted) return false;

    // Request activity recognition for pedometer (Android 10+)
    // Don't block on this — pedometer will fallback gracefully
    await Permission.activityRecognition.request();

    return true;
  }

  /// Start continuous GPS tracking + pedometer step counting.
  Future<void> startTracking() async {
    if (_isTracking) return;

    _isTracking = true;
    _lastPosition = null;
    _totalDistanceMeters = 0.0;
    _route.clear();
    _stepsAtStart = 0;
    _latestStepCount = 0;
    _hasInitialReading = false;

    // ── Start barometer stream ──────────────────────────────────────
    _barometerService.startTracking();

    // ── Start GPS stream ─────────────────────────────────────────────
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Only trigger update after 10m movement
    );

    _positionSub = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position pos) {
        // ── Filter bad GPS readings ──────────────────────────────────
        // Ignore readings with poor accuracy (>25m means indoor/weak signal)
        if (pos.accuracy > 25.0) return;

        if (_lastPosition != null) {
          final delta = Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            pos.latitude,
            pos.longitude,
          );

          // Ignore tiny GPS drift (noise less than accuracy threshold)
          if (delta < pos.accuracy) return;

          // Ignore teleport jumps (>50m in one update = GPS glitch)
          if (delta > 50.0) return;

          _totalDistanceMeters += delta;
        }
        _lastPosition = pos;
        _route.add(LocationPoint(
          latitude: pos.latitude,
          longitude: pos.longitude,
          altitude: pos.altitude,
          timestamp: pos.timestamp,
        ));
      },
      onError: (_) {
        _isTracking = false;
        _positionSub?.cancel();
        _positionSub = null;
      },
      cancelOnError: true,
    );

    // ── Start pedometer stream ───────────────────────────────────────
    try {
      _stepSub = Pedometer.stepCountStream.listen(
        (StepCount event) {
          if (!_hasInitialReading) {
            _stepsAtStart = event.steps;
            _hasInitialReading = true;
          }
          _latestStepCount = event.steps;
        },
        onError: (_) {
          // Pedometer not available — will use GPS fallback
          _stepSub?.cancel();
          _stepSub = null;
        },
        cancelOnError: false,
      );
    } catch (_) {
      // Device doesn't support step counter sensor
    }
  }

  /// Stop tracking and return the collected route.
  Future<List<LocationPoint>> stopTracking() async {
    await _positionSub?.cancel();
    _positionSub = null;
    await _stepSub?.cancel();
    _stepSub = null;
    await _barometerService.stopTracking();
    _isTracking = false;

    final result = List<LocationPoint>.from(_route);
    _route.clear();
    _lastPosition = null;
    _totalDistanceMeters = 0.0;
    _stepsAtStart = 0;
    _latestStepCount = 0;
    _hasInitialReading = false;
    return result;
  }
}
