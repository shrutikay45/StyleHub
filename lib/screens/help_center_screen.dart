import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/widgets/address_dialog.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<_HelpCategoryData> _categories = [
    _HelpCategoryData(
      icon: Icons.local_shipping_outlined,
      color: const Color(0xFF7E22CE),
      bgColor: const Color(0xFFF3E8FF),
      title: 'Orders & Delivery',
      subtitle: 'Tracking, shipping duration & delivery queries',
      faqs: [
        _FAQ(
          question: 'How do I track my order?',
          answer:
              'Go to "My Account" > "My Orders" and select your active order. You can view the live progress from Confirmed -> Packed -> Shipped -> Out for Delivery -> Delivered.',
        ),
        _FAQ(
          question: 'What is the estimated delivery time?',
          answer:
              'Standard delivery takes 3 to 5 business days across all major Indian cities and pincodes. Express delivery orders are dispatched within 24 hours.',
        ),
        _FAQ(
          question: 'Can I change my delivery address after ordering?',
          answer:
              'You can modify your delivery address from the Orders screen as long as the status is "Processing" or "Confirmed". Once shipped, addresses cannot be altered.',
        ),
        _FAQ(
          question: 'How do I cancel an order?',
          answer:
              'Open your active order from "My Orders" and tap "Cancel Order". If paid online, the refund is initiated immediately to your source account.',
        ),
      ],
    ),
    _HelpCategoryData(
      icon: Icons.account_balance_wallet_outlined,
      color: const Color(0xFF0284C7),
      bgColor: const Color(0xFFE0F2FE),
      title: 'Payments & Refunds',
      subtitle: 'UPI, Cards, COD & refund timelines',
      faqs: [
        _FAQ(
          question: 'What payment modes are accepted?',
          answer:
              'We accept all major payment methods including UPI (Google Pay, PhonePe, Paytm), Credit & Debit Cards (Visa, Mastercard, RuPay), NetBanking, and Cash on Delivery (COD).',
        ),
        _FAQ(
          question: 'When will I receive my refund?',
          answer:
              'Refunds for online orders are processed within 24 to 48 hours of cancellation or return pickup. Bank account / card reflection takes 3 to 5 business days.',
        ),
        _FAQ(
          question: 'Amount was deducted but order was not placed?',
          answer:
              'Do not worry! If the bank deducted the payment during a network interruption, the amount is automatically reversed by the payment gateway within 24 hours.',
        ),
      ],
    ),
    _HelpCategoryData(
      icon: Icons.assignment_return_outlined,
      color: const Color(0xFFEA580C),
      bgColor: const Color(0xFFFFEDD5),
      title: 'Returns & Exchanges',
      subtitle: '7-day doorstep replacement & pickup',
      faqs: [
        _FAQ(
          question: 'What is StyleHub\'s return policy?',
          answer:
              'We offer a 7-day hassle-free return and exchange policy from the date of delivery. Items must be unused, unwashed, and with original brand tags attached.',
        ),
        _FAQ(
          question: 'How do I request a size exchange?',
          answer:
              'Go to "My Orders", tap on the delivered item, click "Return / Exchange", select your preferred replacement size, and our courier executive will swap it at your doorstep.',
        ),
        _FAQ(
          question: 'Is return pickup free?',
          answer:
              'Yes! Doorstep pickup for all returns and exchanges is 100% free with no extra fees.',
        ),
      ],
    ),
    _HelpCategoryData(
      icon: Icons.local_offer_outlined,
      color: const Color(0xFF16A34A),
      bgColor: const Color(0xFFDCFCE7),
      title: 'Coupons & Discounts',
      subtitle: 'Applying promo codes & festive discounts',
      faqs: [
        _FAQ(
          question: 'How do I apply a coupon code?',
          answer:
              'On the Checkout / Cart screen, enter the coupon code (e.g. WELCOME50, FLAT100, FESTIVE20) in the "Apply Coupon" field and click "Apply". The discount reflects instantly on the bill summary.',
        ),
        _FAQ(
          question: 'Why is my coupon not working?',
          answer:
              'Ensure that your cart total meets the minimum order requirement (e.g., ₹999 for WELCOME50 or ₹499 for FLAT100) and that the coupon has not expired or reached its usage limit.',
        ),
      ],
    ),
    _HelpCategoryData(
      icon: Icons.person_outline_rounded,
      color: const Color(0xFFE11D48),
      bgColor: const Color(0xFFFFE4E6),
      title: 'Account & Addresses',
      subtitle: 'Profile settings, PIN codes & shipping info',
      faqs: [
        _FAQ(
          question: 'How do I add or update delivery addresses?',
          answer:
              'Tap "Saved Addresses" in My Account or on the Checkout screen. You can add new addresses with exact 6-digit PIN code, 10-digit mobile number, and select your Indian State from the dropdown.',
        ),
        _FAQ(
          question: 'How do I change my password or email?',
          answer:
              'Navigate to My Account > Profile to update your registered name, email, and password settings securely.',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCategorySheet(_HelpCategoryData cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cat.bgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark,
                          ),
                        ),
                        Text(
                          '${cat.faqs.length} Frequently Asked Questions',
                          style: const TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.dark),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // FAQ List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cat.faqs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final faq = cat.faqs[idx];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      leading: Icon(Icons.help_outline, color: cat.color, size: 20),
                      title: Text(
                        faq.question,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                      children: [
                        Text(
                          faq.answer,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF475569),
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactModal(String type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        if (type == 'chat') {
          return _buildChatSupportSheet(ctx);
        } else if (type == 'call') {
          return _buildCallSupportSheet(ctx);
        } else {
          return _buildEmailSupportSheet(ctx);
        }
      },
    );
  }

  Widget _buildChatSupportSheet(BuildContext ctx) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF0284C7), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'StyleHub Instant Support',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                      Text(
                        'Online • Typical reply under 2 mins',
                        style: TextStyle(fontSize: 12, color: Color(0xFF16A34A), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'How can we help you today?',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.dark),
            ),
            const SizedBox(height: 12),
            _buildQuickChatButton(
              ctx,
              icon: Icons.inventory_2_outlined,
              label: 'Where is my order?',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()));
              },
            ),
            const SizedBox(height: 8),
            _buildQuickChatButton(
              ctx,
              icon: Icons.location_on_outlined,
              label: 'Change delivery address',
              onTap: () async {
                Navigator.pop(ctx);
                await showAddressDialog(context);
              },
            ),
            const SizedBox(height: 8),
            _buildQuickChatButton(
              ctx,
              icon: Icons.assignment_return_outlined,
              label: 'Return or refund inquiry',
              onTap: () {
                Navigator.pop(ctx);
                _openCategorySheet(_categories[2]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallSupportSheet(BuildContext ctx) {
    const phoneNo = '1800-123-7895';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.phone_in_talk_outlined, color: Color(0xFF16A34A), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Care Helpline',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                      Text(
                        'Toll-Free • 9:00 AM - 9:00 PM IST',
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.headset_mic_outlined, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phoneNo,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.dark),
                        ),
                        Text(
                          'Toll-Free All India Support',
                          style: TextStyle(fontSize: 11, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: phoneNo));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Helpline number copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF0F8A5F),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 14, color: Colors.white),
                    label: const Text('COPY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailSupportSheet(BuildContext ctx) {
    const email = 'support@stylehub.com';
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4E6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.email_outlined, color: Color(0xFFE11D48), size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Customer Support',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                      Text(
                        'Guaranteed response in 2-4 hours',
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mail_outline, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.dark),
                        ),
                        Text(
                          'Official Fashion Support Desk',
                          style: TextStyle(fontSize: 11, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: email));
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support email copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF0F8A5F),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 14, color: Colors.white),
                    label: const Text('COPY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChatButton(BuildContext ctx, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter categories/faqs based on search query
    final query = _searchQuery.toLowerCase().trim();
    final matchingFaqs = <_FAQ>[];
    if (query.isNotEmpty) {
      for (final cat in _categories) {
        for (final faq in cat.faqs) {
          if (faq.question.toLowerCase().contains(query) || faq.answer.toLowerCase().contains(query)) {
            matchingFaqs.add(faq);
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help Center & Support',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search queries, refund, delivery, size...',
                    hintStyle: const TextStyle(color: AppColors.lightGrey, fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppColors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Search Results (if query is active)
              if (_searchQuery.isNotEmpty) ...[
                Text(
                  'Search Results (${matchingFaqs.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.dark),
                ),
                const SizedBox(height: 12),
                if (matchingFaqs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text(
                          'No answers found',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.dark),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try searching with different keywords or contact support below.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                      ],
                    ),
                  )
                else
                  ...matchingFaqs.map((faq) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: ExpansionTile(
                          shape: const Border(),
                          initiallyExpanded: true,
                          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          leading: const Icon(Icons.help_outline, color: AppColors.primary, size: 20),
                          title: Text(
                            faq.question,
                            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.dark),
                          ),
                          children: [
                            Text(
                              faq.answer,
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                            ),
                          ],
                        ),
                      )),
                const SizedBox(height: 24),
              ],

              // Popular Help Topics
              const Text(
                'Help Topics',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              ..._categories.map((cat) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _openCategorySheet(cat),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: cat.bgColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(cat.icon, color: cat.color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cat.title,
                                    style: const TextStyle(
                                      color: AppColors.dark,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    cat.subtitle,
                                    style: const TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.lightGrey,
                              size: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),

              const SizedBox(height: 24),

              // Contact Support Section
              const Text(
                'Contact Customer Support',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),

              _buildContactTile(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: const Color(0xFF0284C7),
                bgColor: const Color(0xFFE0F2FE),
                title: 'Chat with Us',
                subtitle: 'Fastest support for order & delivery issues',
                onTap: () => _showContactModal('chat'),
              ),
              const SizedBox(height: 10),

              _buildContactTile(
                icon: Icons.phone_in_talk_outlined,
                iconColor: const Color(0xFF16A34A),
                bgColor: const Color(0xFFDCFCE7),
                title: 'Call Support Helpline',
                subtitle: '1800-123-7895 • 9 AM - 9 PM IST',
                onTap: () => _showContactModal('call'),
              ),
              const SizedBox(height: 10),

              _buildContactTile(
                icon: Icons.email_outlined,
                iconColor: const Color(0xFFE11D48),
                bgColor: const Color(0xFFFFE4E6),
                title: 'Email Us',
                subtitle: 'support@stylehub.com • 24x7 ticket assistance',
                onTap: () => _showContactModal('email'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
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
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.lightGrey,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HelpCategoryData {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final String title;
  final String subtitle;
  final List<_FAQ> faqs;

  const _HelpCategoryData({
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.faqs,
  });
}

class _FAQ {
  final String question;
  final String answer;

  const _FAQ({
    required this.question,
    required this.answer,
  });
}