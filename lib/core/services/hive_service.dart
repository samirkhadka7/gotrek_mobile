import 'package:hive_flutter/hive_flutter.dart';
import 'package:gotrek/core/constants/hive_constants.dart';
import 'package:gotrek/features/auth/data/models/user_hive_model.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(UserHiveModelAdapter());

    // Open boxes
    await Hive.openBox<UserHiveModel>(HiveConstants.userBox);
  }

  static Future<void> close() async {
    await Hive.close();
  }
}