part of 'payment_bloc.dart';

/// Base class for payment events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize eSewa payment
class InitializePaymentEvent extends PaymentEvent {
  final String plan;
  final double amount;

  const InitializePaymentEvent({
    required this.plan,
    required this.amount,
  });

  @override
  List<Object?> get props => [plan, amount];
}

/// Load payment history
class LoadPaymentHistoryEvent extends PaymentEvent {
  final int page;
  final int limit;

  const LoadPaymentHistoryEvent({
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Load subscription plans
class LoadSubscriptionPlansEvent extends PaymentEvent {
  const LoadSubscriptionPlansEvent();
}

/// Cancel subscription
class CancelSubscriptionEvent extends PaymentEvent {
  const CancelSubscriptionEvent();
}

/// Reset payment state
class ResetPaymentStateEvent extends PaymentEvent {
  const ResetPaymentStateEvent();
}

/// Payment completed via eSewa redirect
class PaymentCompletedEvent extends PaymentEvent {
  final bool success;
  final String? message;

  const PaymentCompletedEvent({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];
}
