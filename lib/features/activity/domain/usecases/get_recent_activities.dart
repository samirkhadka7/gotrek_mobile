import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/activity_entity.dart';
import '../repositories/activity_repository.dart';

/// Use case for getting recent activities
class GetRecentActivitiesUseCase implements UseCase<List<ActivityEntity>, NoParams> {
  final ActivityRepository repository;

  GetRecentActivitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ActivityEntity>>> call(NoParams params) {
    return repository.getRecentActivities();
  }
}
