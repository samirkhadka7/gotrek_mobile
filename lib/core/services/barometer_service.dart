import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service that reads barometer (pressure) sensor via platform channel
/// and calculates elevation gain/loss during a trek session.
class BarometerService {
  static const _channel = EventChannel('com.samir.gotrek/barometer');

  StreamSubscription<dynamic>? _pressureSub;
  double? _baseAltitude;
  double? _lastAltitude;
  double _elevationGain = 0.0;
  double _elevationLoss = 0.0;
  bool _isTracking = false;
  bool _sensorAvailable = true;

  // ── Public getters ─────────────────────────────────────────────────
  bool get isTracking => _isTracking;
  bool get sensorAvailable => _sensorAvailable;
  double get elevationGain => _elevationGain;
  double get elevationLoss => _elevationLoss;
  double get netElevation => _elevationGain - _elevationLoss;
  double? get currentAltitude => _lastAltitude;

  /// Convert pressure (hPa) to altitude (meters) using barometric formula.
  /// Standard sea-level pressure = 1013.25 hPa.
  static double pressureToAltitude(double pressureHPa) {
    return 44330.0 * (1.0 - pow(pressureHPa / 1013.25, 0.1903));
  }

  /// Start listening to barometer sensor.
  void startTracking() {
    if (_isTracking) return;

    _isTracking = true;
    _baseAltitude = null;
    _lastAltitude = null;
    _elevationGain = 0.0;
    _elevationLoss = 0.0;
    _sensorAvailable = true;

    try {
      _pressureSub = _channel.receiveBroadcastStream().listen(
        (dynamic event) {
          final pressureHPa = (event as num).toDouble();
          final altitude = pressureToAltitude(pressureHPa);

          if (_baseAltitude == null) {
            _baseAltitude = altitude;
            _lastAltitude = altitude;
            debugPrint('[Barometer] Sensor OK — base altitude: ${altitude.toStringAsFixed(1)}m, pressure: ${pressureHPa.toStringAsFixed(1)} hPa');
            return;
          }

          final delta = altitude - _lastAltitude!;

          // Filter noise: only count changes > 1 meter
          if (delta.abs() < 1.0) return;

          if (delta > 0) {
            _elevationGain += delta;
          } else {
            _elevationLoss += delta.abs();
          }

          _lastAltitude = altitude;
          debugPrint('[Barometer] ↑${_elevationGain.toStringAsFixed(1)}m ↓${_elevationLoss.toStringAsFixed(1)}m (alt: ${altitude.toStringAsFixed(1)}m)');
        },
        onError: (e) {
          debugPrint('[Barometer] Sensor error: $e');
          _sensorAvailable = false;
          _pressureSub?.cancel();
          _pressureSub = null;
        },
        cancelOnError: false,
      );
    } catch (_) {
      _sensorAvailable = false;
    }
  }

  /// Stop listening and reset state.
  Future<void> stopTracking() async {
    await _pressureSub?.cancel();
    _pressureSub = null;
    _isTracking = false;
    _baseAltitude = null;
    _lastAltitude = null;
    _elevationGain = 0.0;
    _elevationLoss = 0.0;
  }
}
