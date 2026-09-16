import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalAmount;

  const PaymentMethodScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  late Razorpay _razorpay;

  String? selectedPaymentMethod;

  // Replace this with your Razorpay TEST Key ID.
  // Example: rzp_test_xxxxxxxxxxxxxx
  static const String razorpayTestKey = 'rzp_test_ziXbFEU3WEZ4Xe';

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handlePaymentSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handlePaymentError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ------------------------------------------------------------
  // SELECT PAYMENT METHOD
  // ------------------------------------------------------------

  void _selectPaymentMethod(String method) {
    setState(() {
      selectedPaymentMethod = method;
    });
  }

  // ------------------------------------------------------------
  // PLACE / PAY ORDER
  // ------------------------------------------------------------

  void _continuePayment() {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (selectedPaymentMethod == 'UPI') {
      _openRazorpay();
      return;
    }

    if (selectedPaymentMethod == 'COD') {
      _showCodConfirmation();
      return;
    }
  }

  // ------------------------------------------------------------
  // OPEN RAZORPAY
  // ------------------------------------------------------------

  void _openRazorpay() {
    if (razorpayTestKey == 'YOUR_RAZORPAY_TEST_KEY') {
      _showRazorpaySetupMessage();
      return;
    }

    final options = {
      'key': razorpayTestKey,
      'amount': (widget.totalAmount * 100).round(),
      'name': 'Women Fashion',
      'description': 'Order Payment',
      'currency': 'INR',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'theme': {
        'color': '#D81B60',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open payment gateway.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ------------------------------------------------------------
  // RAZORPAY SUCCESS
  // ------------------------------------------------------------

  void _handlePaymentSuccess(
      PaymentSuccessResponse response,
      ) {
    _showOrderSuccess(
      title: 'Payment Successful',
      message: 'Your order has been placed successfully.',
    );
  }

  // ------------------------------------------------------------
  // RAZORPAY FAILURE
  // ------------------------------------------------------------

  void _handlePaymentError(
      PaymentFailureResponse response,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment failed. Please try again.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------------------------
  // EXTERNAL WALLET
  // ------------------------------------------------------------

  void _handleExternalWallet(
      ExternalWalletResponse response,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'External wallet selected: '
              '${response.walletName ?? 'Wallet'}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ------------------------------------------------------------
  // COD CONFIRMATION
  // ------------------------------------------------------------

  void _showCodConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Place order?',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'You have selected Cash on Delivery. '
                'You can pay when your order is delivered.',
            style: TextStyle(
              color: AppColors.grey,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.grey,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                _showOrderSuccess(
                  title: 'Order Placed',
                  message:
                  'Your order has been placed with Cash on Delivery.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // RAZORPAY SETUP MESSAGE
  // ------------------------------------------------------------

  void _showRazorpaySetupMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Razorpay setup',
            style: TextStyle(
              color: AppColors.dark,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            'The payment screen is ready. '
                'Add your Razorpay test key to start testing online payments.',
            style: TextStyle(
              color: AppColors.grey,
              height: 1.5,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // ORDER SUCCESS
  // ------------------------------------------------------------

  void _showOrderSuccess({
    required String title,
    required String message,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderSuccessScreen(
          title: title,
          message: message,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bool isUpiSelected =
        selectedPaymentMethod == 'UPI';

    final bool isCodSelected =
        selectedPaymentMethod == 'COD';

    final bool canContinue =
        selectedPaymentMethod != null;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.dark,
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose payment method',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ------------------------------------------------
                  // UPI
                  // ------------------------------------------------

                  _buildPaymentOption(
                    title: 'UPI',
                    subtitle: 'Pay securely online',
                    icon: Icons.account_balance_wallet_outlined,
                    isSelected: isUpiSelected,
                    onTap: () {
                      _selectPaymentMethod('UPI');
                    },
                  ),

                  const SizedBox(height: 12),

                  // ------------------------------------------------
                  // CASH ON DELIVERY
                  // ------------------------------------------------

                  _buildPaymentOption(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when your order arrives',
                    icon: Icons.local_shipping_outlined,
                    isSelected: isCodSelected,
                    onTap: () {
                      _selectPaymentMethod('COD');
                    },
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------------
          // BOTTOM BAR
          // --------------------------------------------------------

          _buildBottomBar(
            canContinue: canContinue,
            isUpiSelected: isUpiSelected,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PAYMENT OPTION
  // ------------------------------------------------------------

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
            width: isSelected ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight
                    : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.dark,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Radio
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.lightGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM BAR
  // ------------------------------------------------------------

  Widget _buildBottomBar({
    required bool canContinue,
    required bool isUpiSelected,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total
            Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '₹${widget.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Button
            Expanded(
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: canContinue
                      ? _continuePayment
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor:
                    const Color(0xFFE5E5E5),
                    foregroundColor: Colors.white,
                    disabledForegroundColor:
                    AppColors.lightGrey,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    !canContinue
                        ? 'Select Payment Method'
                        : isUpiSelected
                        ? 'Pay ₹${widget.totalAmount.toStringAsFixed(0)}'
                        : 'Place Order',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// ORDER SUCCESS SCREEN
// ==================================================================

class OrderSuccessScreen extends StatelessWidget {
  final String title;
  final String message;

  const OrderSuccessScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Container(
                  height: 86,
                  width: 86,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.rating,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                            (route) => route.isFirst,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}