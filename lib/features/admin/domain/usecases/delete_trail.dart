import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_trail_repository.dart';

/// Use case for deleting trail
class DeleteTrailUseCase implements UseCase<void, String> {
  final AdminTrailRepository repository;

  DeleteTrailUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String trailId) {
    return repository.deleteTrail(trailId);
  }
}
