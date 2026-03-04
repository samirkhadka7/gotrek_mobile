import '../../domain/entities/payment_entity.dart';

/// Model for payment from API
class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.userId,
    super.orderId,
    super.trailId,
    super.groupId,
    required super.amount,
    super.currency,
    required super.method,
    required super.status,
    super.transactionId,
    super.referenceId,
    super.description,
    super.metadata,
    required super.createdAt,
    super.completedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      orderId: json['orderId'] as String?,
      trailId: json['trailId'] as String?,
      groupId: json['groupId'] as String?,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'NPR',
      method: PaymentMethod.fromString(json['method'] as String? ?? 'esewa'),
      status: PaymentStatus.fromString(json['status'] as String? ?? 'pending'),
      transactionId: json['transactionId'] as String? ??
          json['transaction_uuid'] as String?,
      referenceId: json['referenceId'] as String?,
      description: json['description'] as String? ?? json['plan'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'trailId': trailId,
      'groupId': groupId,
      'amount': amount,
      'currency': currency,
      'method': method.name,
      'status': status.name,
      'transactionId': transactionId,
      'referenceId': referenceId,
      'description': description,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}

/// Model for eSewa payment form data from backend
class ESewaPaymentDataModel extends ESewaPaymentData {
  const ESewaPaymentDataModel({
    required super.totalAmount,
    required super.transactionUuid,
    required super.productCode,
    required super.signature,
    required super.signedFieldNames,
    required super.amount,
    required super.failureUrl,
    required super.successUrl,
    super.productDeliveryCharge,
    super.productServiceCharge,
    super.taxAmount,
  });

  factory ESewaPaymentDataModel.fromJson(Map<String, dynamic> json) {
    return ESewaPaymentDataModel(
      totalAmount: json['total_amount']?.toString() ?? '0',
      transactionUuid: json['transaction_uuid']?.toString() ?? '',
      productCode: json['product_code']?.toString() ?? 'EPAYTEST',
      signature: json['signature']?.toString() ?? '',
      signedFieldNames:
          json['signed_field_names']?.toString() ?? 'total_amount,transaction_uuid,product_code',
      amount: json['amount']?.toString() ?? '0',
      failureUrl: json['failure_url']?.toString() ?? '',
      successUrl: json['success_url']?.toString() ?? '',
      productDeliveryCharge:
          json['product_delivery_charge']?.toString() ?? '0',
      productServiceCharge:
          json['product_service_charge']?.toString() ?? '0',
      taxAmount: json['tax_amount']?.toString() ?? '0',
    );
  }
}
