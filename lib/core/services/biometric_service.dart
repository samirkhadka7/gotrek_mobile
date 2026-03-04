import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Service for biometric authentication (fingerprint / face ID).
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if device supports biometric authentication.
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck && isSupported;
    } on PlatformException catch (e) {
      debugPrint('[Biometric] Availability check failed: $e');
      return false;
    }
  }

  /// Trigger biometric prompt. Returns true if authenticated.
  Future<bool> authenticate({String reason = 'Please authenticate to continue'}) async {
    try {
      final available = await isAvailable();
      if (!available) return true; // No biometric → skip, allow through

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/pattern fallback
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('[Biometric] Auth failed: $e');
      return false;
    }
  }
}
