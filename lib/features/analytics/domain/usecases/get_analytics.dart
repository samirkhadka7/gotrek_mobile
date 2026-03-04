import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/analytics_entity.dart';
import '../repositories/analytics_repository.dart';

/// Use case for getting analytics
class GetAnalyticsUseCase implements UseCase<AnalyticsEntity, NoParams> {
  final AnalyticsRepository repository;

  GetAnalyticsUseCase(this.repository);

  @override
  Future<Either<Failure, AnalyticsEntity>> call(NoParams params) {
    return repository.getAnalytics();
  }
}
