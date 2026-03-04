import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/payment_repository.dart';

/// Use case for cancelling subscription
class CancelSubscriptionUseCase implements UseCase<void, NoParams> {
  final PaymentRepository repository;

  CancelSubscriptionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.cancelSubscription();
  }
}
