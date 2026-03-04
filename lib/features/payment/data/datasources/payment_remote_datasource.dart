import '../../../../core/network/api_client.dart';
import '../models/payment_model.dart';
import '../../domain/entities/payment_entity.dart';

/// Remote data source for payment operations
abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> initializeESewaPayment({
    required String plan,
    required double amount,
  });

  Future<List<PaymentModel>> getPaymentHistory({
    int page = 1,
    int limit = 10,
  });

  Future<List<SubscriptionPlan>> getSubscriptionPlans();

  Future<void> cancelSubscription();
}

/// Implementation of PaymentRemoteDataSource
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiClient _apiClient;

  PaymentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> initializeESewaPayment({
    required String plan,
    required double amount,
  }) async {
    final response = await _apiClient.post(
      '/payment/initiate',
      data: {
        'plan': plan,
        'amount': amount,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<PaymentModel>> getPaymentHistory({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _apiClient.get(
      '/payment/history',
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
      },
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    // Plans are hardcoded - backend only supports Pro and Premium
    return const [
      SubscriptionPlan(
        id: 'Pro',
        name: 'Pro',
        description: 'Perfect for regular trekkers',
        price: 299,
        durationDays: 30,
        features: [
          'Unlimited trail access',
          'AI Trail Assistant',
          'Offline maps',
          'No ads',
        ],
      ),
      SubscriptionPlan(
        id: 'Premium',
        name: 'Premium',
        description: 'Best value for trekking enthusiasts',
        price: 999,
        durationDays: 30,
        features: [
          'Everything in Pro',
          'Priority support',
          'Advanced analytics',
          'Exclusive badges',
          'Group leader features',
        ],
        isPopular: true,
      ),
    ];
  }

  @override
  Future<void> cancelSubscription() async {
    await _apiClient.put('/subscription/cancel');
  }
}
