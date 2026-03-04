import 'package:equatable/equatable.dart';

/// Payment status enum
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled;

  String get displayName {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.cancelled:
        return 'Cancelled';
    }
  }

  static PaymentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'cancelled':
        return PaymentStatus.cancelled;
      default:
        return PaymentStatus.pending;
    }
  }

  int get colorValue {
    switch (this) {
      case PaymentStatus.pending:
        return 0xFFFF9800; // Orange
      case PaymentStatus.processing:
        return 0xFF2196F3; // Blue
      case PaymentStatus.completed:
        return 0xFF4CAF50; // Green
      case PaymentStatus.failed:
        return 0xFFF44336; // Red
      case PaymentStatus.refunded:
        return 0xFF9C27B0; // Purple
      case PaymentStatus.cancelled:
        return 0xFF9E9E9E; // Grey
    }
  }
}

/// Payment method enum
enum PaymentMethod {
  esewa,
  khalti,
  bankTransfer,
  cash;

  String get displayName {
    switch (this) {
      case PaymentMethod.esewa:
        return 'eSewa';
      case PaymentMethod.khalti:
        return 'Khalti';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.cash:
        return 'Cash';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.esewa:
        return '💚';
      case PaymentMethod.khalti:
        return '💜';
      case PaymentMethod.bankTransfer:
        return '🏦';
      case PaymentMethod.cash:
        return '💵';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'esewa':
        return PaymentMethod.esewa;
      case 'khalti':
        return PaymentMethod.khalti;
      case 'bank_transfer':
      case 'banktransfer':
        return PaymentMethod.bankTransfer;
      case 'cash':
        return PaymentMethod.cash;
      default:
        return PaymentMethod.esewa;
    }
  }
}

/// Payment entity
class PaymentEntity extends Equatable {
  final String id;
  final String userId;
  final String? orderId;
  final String? trailId;
  final String? groupId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final String? referenceId;
  final String? description;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime? completedAt;

  const PaymentEntity({
    required this.id,
    required this.userId,
    this.orderId,
    this.trailId,
    this.groupId,
    required this.amount,
    this.currency = 'NPR',
    required this.method,
    required this.status,
    this.transactionId,
    this.referenceId,
    this.description,
    this.metadata,
    required this.createdAt,
    this.completedAt,
  });

  /// Formatted amount with currency
  String get formattedAmount => '$currency ${amount.toStringAsFixed(2)}';

  /// Check if payment is successful
  bool get isCompleted => status == PaymentStatus.completed;

  /// Check if payment is pending
  bool get isPending =>
      status == PaymentStatus.pending || status == PaymentStatus.processing;

  @override
  List<Object?> get props => [
        id,
        userId,
        orderId,
        trailId,
        groupId,
        amount,
        currency,
        method,
        status,
        transactionId,
        referenceId,
        description,
        metadata,
        createdAt,
        completedAt,
      ];
}

/// eSewa payment form data returned by backend
class ESewaPaymentData extends Equatable {
  final String totalAmount;
  final String transactionUuid;
  final String productCode;
  final String signature;
  final String signedFieldNames;
  final String amount;
  final String failureUrl;
  final String successUrl;
  final String productDeliveryCharge;
  final String productServiceCharge;
  final String taxAmount;

  const ESewaPaymentData({
    required this.totalAmount,
    required this.transactionUuid,
    required this.productCode,
    required this.signature,
    required this.signedFieldNames,
    required this.amount,
    required this.failureUrl,
    required this.successUrl,
    this.productDeliveryCharge = '0',
    this.productServiceCharge = '0',
    this.taxAmount = '0',
  });

  /// eSewa payment form URL (test environment)
  String get paymentFormUrl =>
      'https://rc-epay.esewa.com.np/api/epay/main/v2/form';

  @override
  List<Object?> get props => [
        totalAmount,
        transactionUuid,
        productCode,
        signature,
        signedFieldNames,
        amount,
        failureUrl,
        successUrl,
        productDeliveryCharge,
        productServiceCharge,
        taxAmount,
      ];
}

/// Subscription plan entity
class SubscriptionPlan extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int durationDays;
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'NPR',
    required this.durationDays,
    required this.features,
    this.isPopular = false,
  });

  String get formattedPrice => '$currency ${price.toStringAsFixed(0)}';

  String get durationText {
    if (durationDays == 30) return 'Monthly';
    if (durationDays == 90) return 'Quarterly';
    if (durationDays == 365) return 'Yearly';
    return '$durationDays days';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        currency,
        durationDays,
        features,
        isPopular,
      ];
}
