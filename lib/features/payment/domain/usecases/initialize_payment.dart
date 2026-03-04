import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/payment_entity.dart';
import '../repositories/payment_repository.dart';

/// Use case for initializing eSewa payment
class InitializeESewaPaymentUseCase
    implements UseCase<ESewaPaymentData, InitializePaymentParams> {
  final PaymentRepository repository;

  InitializeESewaPaymentUseCase(this.repository);

  @override
  Future<Either<Failure, ESewaPaymentData>> call(
    InitializePaymentParams params,
  ) {
    return repository.initializeESewaPayment(
      plan: params.plan,
      amount: params.amount,
    );
  }
}

/// Parameters for initializing payment
class InitializePaymentParams extends Equatable {
  final String plan;
  final double amount;

  const InitializePaymentParams({
    required this.plan,
    required this.amount,
  });

  @override
  List<Object?> get props => [plan, amount];
}
