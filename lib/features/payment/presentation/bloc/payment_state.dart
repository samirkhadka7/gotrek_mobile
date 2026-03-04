part of 'payment_bloc.dart';

/// Base class for payment states
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Loading state
class PaymentLoading extends PaymentState {
  final String? message;

  const PaymentLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// Payment initialized (ready to redirect to eSewa)
class PaymentInitialized extends PaymentState {
  final ESewaPaymentData paymentData;

  const PaymentInitialized({required this.paymentData});

  @override
  List<Object?> get props => [paymentData];
}

/// Payment successful (eSewa callback confirmed success)
class PaymentSuccess extends PaymentState {
  final String message;

  const PaymentSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Payment error
class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Payment history loaded
class PaymentHistoryLoaded extends PaymentState {
  final List<PaymentEntity> payments;

  const PaymentHistoryLoaded({required this.payments});

  @override
  List<Object?> get props => [payments];
}

/// Subscription plans loaded
class SubscriptionPlansLoaded extends PaymentState {
  final List<SubscriptionPlan> plans;

  const SubscriptionPlansLoaded({required this.plans});

  @override
  List<Object?> get props => [plans];
}

/// Subscription cancelled
class SubscriptionCancelled extends PaymentState {
  const SubscriptionCancelled();
}
