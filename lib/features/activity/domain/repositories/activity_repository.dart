import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/activity_entity.dart';

/// Repository interface for activity operations
abstract class ActivityRepository {
  /// Get recent activities
  Future<Either<Failure, List<ActivityEntity>>> getRecentActivities();
}
