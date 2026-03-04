import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/payment_entity.dart';
import '../bloc/payment_bloc.dart';

/// Payment page with eSewa WebView
class PaymentPage extends StatefulWidget {
  final String plan;
  final double amount;
  final String planName;

  const PaymentPage({
    super.key,
    required this.plan,
    required this.amount,
    required this.planName,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Request payment initialization from backend
    context.read<PaymentBloc>().add(InitializePaymentEvent(
          plan: widget.plan,
          amount: widget.amount,
        ));
  }

  void _initWebView(ESewaPaymentData paymentData) {
    // Build an HTML form that auto-submits to eSewa's payment endpoint
    final html = _buildESewaFormHtml(paymentData);

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            // Backend verify endpoint redirects to success/failure URLs
            if (url.contains('/payment/success') &&
                url.contains('status=success')) {
              _handlePaymentSuccess();
              return NavigationDecision.prevent;
            }
            if (url.contains('/payment/failure') ||
                url.contains('status=failure')) {
              final uri = Uri.parse(url);
              final message = uri.queryParameters['message'] ??
                  'Payment failed';
              _handlePaymentFailure(message);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            _showError('Failed to load payment page: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(html);

    if (mounted) setState(() {});
  }

  /// Build an HTML page with a form that auto-submits to eSewa
  String _buildESewaFormHtml(ESewaPaymentData data) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, sans-serif;
      background: #f5f5f5;
    }
    .loading { text-align: center; color: #666; }
    .loading p { margin-top: 16px; font-size: 16px; }
  </style>
</head>
<body>
  <div class="loading">
    <p>Redirecting to eSewa...</p>
  </div>
  <form id="esewaForm" action="${data.paymentFormUrl}" method="POST">
    <input type="hidden" name="amount" value="${data.amount}" />
    <input type="hidden" name="tax_amount" value="${data.taxAmount}" />
    <input type="hidden" name="total_amount" value="${data.totalAmount}" />
    <input type="hidden" name="transaction_uuid" value="${data.transactionUuid}" />
    <input type="hidden" name="product_code" value="${data.productCode}" />
    <input type="hidden" name="product_service_charge" value="${data.productServiceCharge}" />
    <input type="hidden" name="product_delivery_charge" value="${data.productDeliveryCharge}" />
    <input type="hidden" name="success_url" value="${data.successUrl}" />
    <input type="hidden" name="failure_url" value="${data.failureUrl}" />
    <input type="hidden" name="signed_field_names" value="${data.signedFieldNames}" />
    <input type="hidden" name="signature" value="${data.signature}" />
  </form>
  <script>document.getElementById("esewaForm").submit();</script>
</body>
</html>
''';
  }

  void _handlePaymentSuccess() {
    context.read<PaymentBloc>().add(const PaymentCompletedEvent(
          success: true,
          message: 'Payment successful! Your subscription is now active.',
        ));
  }

  void _handlePaymentFailure(String message) {
    context.read<PaymentBloc>().add(PaymentCompletedEvent(
          success: false,
          message: message,
        ));
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pay for ${widget.planName}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: _showCancelConfirmation,
          icon: const Icon(Icons.close),
        ),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentInitialized) {
            _initWebView(state.paymentData);
          } else if (state is PaymentSuccess) {
            // Show success and go back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, {'success': true});
          } else if (state is PaymentError) {
            // Show error but stay on page
            _showError(state.message);
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading || state is PaymentInitial) {
            return _buildLoadingView(state is PaymentLoading
                ? state.message ?? 'Processing...'
                : 'Initializing payment...');
          }

          if (state is PaymentError) {
            return _buildErrorView(state.message);
          }

          if ((state is PaymentInitialized || state is PaymentSuccess) &&
              _webViewController != null) {
            return Stack(
              children: [
                WebViewWidget(controller: _webViewController!),
                if (_isLoading)
                  Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF60BB46),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading eSewa...',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }

          return _buildLoadingView('Processing...');
        },
      ),
    );
  }

  Widget _buildLoadingView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF60BB46).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payment,
              size: 48,
              color: Color(0xFF60BB46),
            ),
          ),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: Color(0xFF60BB46)),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'NPR ${widget.amount.toStringAsFixed(0)} - ${widget.planName}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Payment Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PaymentBloc>().add(InitializePaymentEvent(
                          plan: widget.plan,
                          amount: widget.amount,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Payment?'),
        content: const Text(
          'Are you sure you want to cancel this payment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context, {'success': false}); // close payment page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
