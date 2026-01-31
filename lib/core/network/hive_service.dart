import 'package:hive_flutter/hive_flutter.dart';

class HiveBoxes {
  static const String authBox = 'auth_box';
}

class HiveKeys {
  static const String token = 'auth_token';
  static const String userData = 'user_data';
}

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(HiveBoxes.authBox);
  }

  static Box get authBox => Hive.box(HiveBoxes.authBox);

  // Token save garne
  static Future<void> saveToken(String token) async {
    await authBox.put(HiveKeys.token, token);
  }

  // Token get garne
  static String? getToken() {
    return authBox.get(HiveKeys.token);
  }

  // User data save garne
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await authBox.put(HiveKeys.userData, userData);
  }

  // User data get garne
  static Map<dynamic, dynamic>? getUserData() {
    return authBox.get(HiveKeys.userData);
  }

  // Clear all (logout)
  static Future<void> clearAll() async {
    await authBox.clear();
  }

  // Check if logged in
  static bool isLoggedIn() {
    return getToken() != null;
  }
}