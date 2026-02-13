import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Emulator ko lagi 10.0.2.2 use garne
  // Real device ko lagi apno IP use garne (192.168.x.x)
  // Production ko lagi actual domain use garne

  static const String _androidEmulatorBase = 'http://10.0.2.2:5001/api';
  static const String _localhostBase = 'http://localhost:5001/api';

  // Allows override from --dart-define=API_BASE_URL=http://<ip>:5001/api (useful for physical devices)
  static String get baseUrl {
    final override = const String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) return override;

    if (kIsWeb) return _localhostBase;
    if (Platform.isAndroid) return _androidEmulatorBase;
    return _localhostBase; // iOS simulator by default
  }

  // Auth endpoints
  static String get signup => '$baseUrl/auth/signup';
  static String get login => '$baseUrl/auth/login';
  static String get getMe => '$baseUrl/auth/me';
  static String get uploadProfileImage => '$baseUrl/auth/upload-profile-image';
}