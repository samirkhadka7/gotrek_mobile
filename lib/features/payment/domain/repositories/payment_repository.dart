import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/payment_entity.dart';

/// Repository for payment operations
abstract class PaymentRepository {
  /// Initialize eSewa payment — backend returns form data
  Future<Either<Failure, ESewaPaymentData>> initializeESewaPayment({
    required String plan,
    required double amount,
  });

  /// Get payment history
  Future<Either<Failure, List<PaymentEntity>>> getPaymentHistory({
    int page = 1,
    int limit = 10,
  });

  /// Get subscription plans (hardcoded)
  Future<Either<Failure, List<SubscriptionPlan>>> getSubscriptionPlans();

  /// Cancel subscription
  Future<Either<Failure, void>> cancelSubscription();
}
