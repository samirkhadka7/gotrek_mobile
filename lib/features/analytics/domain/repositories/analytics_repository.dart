import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/analytics_entity.dart';

/// Repository interface for analytics operations
abstract class AnalyticsRepository {
  /// Get analytics data
  Future<Either<Failure, AnalyticsEntity>> getAnalytics();
}
