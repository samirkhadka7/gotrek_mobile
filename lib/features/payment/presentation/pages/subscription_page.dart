import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:get_it/get_it.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/payment_entity.dart';
import '../bloc/payment_bloc.dart';

/// Subscription plans page
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentBloc>().add(const LoadSubscriptionPlansEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Premium Plans',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show actual plans if loaded
          if (state is SubscriptionPlansLoaded) {
            return _buildContent(state.plans);
          }

          // Show mock plans for all other states (including errors)
          return _buildContent(_getMockPlans());
        },
      ),
    );
  }

  Widget _buildContent(List<SubscriptionPlan> plans) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Go Premium',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unlock all features and exclusive content',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Plans
          ...plans.map((plan) => _PlanCard(
                plan: plan,
                onSubscribe: () => _handleSubscribe(plan),
              )),

          const SizedBox(height: 24),

          // Features comparison
          _buildFeaturesSection(),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {'feature': 'Access to all trails', 'free': true, 'premium': true},
      {'feature': 'Join trekking groups', 'free': true, 'premium': true},
      {'feature': 'Basic step tracking', 'free': true, 'premium': true},
      {'feature': 'AI Trail Assistant', 'free': false, 'premium': true},
      {'feature': 'Offline maps', 'free': false, 'premium': true},
      {'feature': 'Advanced analytics', 'free': false, 'premium': true},
      {'feature': 'Priority support', 'free': false, 'premium': true},
      {'feature': 'Ad-free experience', 'free': false, 'premium': true},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Feature Comparison',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          // Header row
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Feature',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Free',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Premium',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Feature rows
          ...features.map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        f['feature'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          f['free'] as bool
                              ? Icons.check_circle
                              : Icons.remove_circle_outline,
                          color: f['free'] as bool
                              ? AppColors.success
                              : Colors.grey.shade300,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Icon(
                          f['premium'] as bool
                              ? Icons.check_circle
                              : Icons.remove_circle_outline,
                          color: f['premium'] as bool
                              ? AppColors.success
                              : Colors.grey.shade300,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PaymentBloc>().add(const LoadSubscriptionPlansEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe(SubscriptionPlan plan) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              plan.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              plan.formattedPrice,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              '/${plan.durationText}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);

                  // Biometric verification before payment
                  final biometric = GetIt.I<BiometricService>();
                  final authenticated = await biometric.authenticate(
                    reason: 'Verify to proceed with payment',
                  );

                  if (!authenticated) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Authentication failed. Payment cancelled.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return;
                  }

                  if (!mounted) return;

                  // Navigate to payment page using GoRouter
                  context.push(
                    AppRoutes.payment,
                    extra: {
                      'plan': plan.id, // 'Pro' or 'Premium'
                      'amount': plan.price,
                      'planName': plan.name,
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pay with eSewa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Cancel anytime. Terms apply.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<SubscriptionPlan> _getMockPlans() {
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
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback onSubscribe;

  const _PlanCard({
    required this.plan,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: plan.isPopular
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: plan.isPopular
                ? AppColors.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (plan.isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'NPR ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                plan.price.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: plan.isPopular ? AppColors.primary : Colors.black87,
                ),
              ),
              Text(
                ' /${plan.durationText.toLowerCase()}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Features
          ...plan.features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 18,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),

          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubscribe,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    plan.isPopular ? AppColors.primary : Colors.grey.shade100,
                foregroundColor:
                    plan.isPopular ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Choose ${plan.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
