import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_entity.dart';
import '../../domain/usecases/initialize_payment.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

/// BLoC for payment operations
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitializeESewaPaymentUseCase initializePaymentUseCase;
  final PaymentRepository repository;

  PaymentBloc({
    required this.initializePaymentUseCase,
    required this.repository,
  }) : super(const PaymentInitial()) {
    on<InitializePaymentEvent>(_onInitializePayment);
    on<LoadPaymentHistoryEvent>(_onLoadPaymentHistory);
    on<LoadSubscriptionPlansEvent>(_onLoadSubscriptionPlans);
    on<CancelSubscriptionEvent>(_onCancelSubscription);
    on<ResetPaymentStateEvent>(_onResetState);
    on<PaymentCompletedEvent>(_onPaymentCompleted);
  }

  Future<void> _onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Initializing payment...'));

    final result = await initializePaymentUseCase(InitializePaymentParams(
      plan: event.plan,
      amount: event.amount,
    ));

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (paymentData) => emit(PaymentInitialized(paymentData: paymentData)),
    );
  }

  Future<void> _onLoadPaymentHistory(
    LoadPaymentHistoryEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Loading payment history...'));

    final result = await repository.getPaymentHistory(
      page: event.page,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (payments) => emit(PaymentHistoryLoaded(payments: payments)),
    );
  }

  Future<void> _onLoadSubscriptionPlans(
    LoadSubscriptionPlansEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Loading subscription plans...'));

    final result = await repository.getSubscriptionPlans();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (plans) => emit(SubscriptionPlansLoaded(plans: plans)),
    );
  }

  Future<void> _onCancelSubscription(
    CancelSubscriptionEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading(message: 'Cancelling subscription...'));

    final result = await repository.cancelSubscription();

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (_) => emit(const SubscriptionCancelled()),
    );
  }

  void _onPaymentCompleted(
    PaymentCompletedEvent event,
    Emitter<PaymentState> emit,
  ) {
    if (event.success) {
      emit(PaymentSuccess(
          message: event.message ?? 'Payment successful!'));
    } else {
      emit(PaymentError(event.message ?? 'Payment failed'));
    }
  }

  void _onResetState(
    ResetPaymentStateEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}
