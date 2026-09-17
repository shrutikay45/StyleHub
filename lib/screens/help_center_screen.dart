import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.dark,
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // SEARCH
              // --------------------------------------------------

              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for help',
                    hintStyle: TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.grey,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // POPULAR TOPICS
              // --------------------------------------------------

              const Text(
                'Popular Topics',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              _buildHelpOption(
                context: context,
                icon: Icons.local_shipping_outlined,
                title: 'Orders & Delivery',
                subtitle: 'Track orders and delivery',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Orders & Delivery',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildHelpOption(
                context: context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Payments & Refunds',
                subtitle: 'Payment and refund related help',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Payments & Refunds',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildHelpOption(
                context: context,
                icon: Icons.assignment_return_outlined,
                title: 'Returns & Exchanges',
                subtitle: 'Learn about returns and exchanges',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Returns & Exchanges',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildHelpOption(
                context: context,
                icon: Icons.favorite_border_rounded,
                title: 'Wishlist & Cart',
                subtitle: 'Manage your wishlist and cart',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Wishlist & Cart',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildHelpOption(
                context: context,
                icon: Icons.person_outline_rounded,
                title: 'Account & Profile',
                subtitle: 'Manage your account and profile',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Account & Profile',
                  );
                },
              ),

              const SizedBox(height: 30),

              // --------------------------------------------------
              // NEED MORE HELP
              // --------------------------------------------------

              const Text(
                'Need more help?',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 14),

              _buildContactOption(
                context: context,
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Chat with us',
                subtitle: 'Get help from our support team',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Chat Support',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildContactOption(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Contact Support',
                subtitle: 'Talk to our customer support',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Contact Support',
                  );
                },
              ),

              const SizedBox(height: 10),

              _buildContactOption(
                context: context,
                icon: Icons.email_outlined,
                title: 'Email us',
                subtitle: 'Send us your query by email',
                onTap: () {
                  _showComingSoon(
                    context,
                    'Email Support',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HELP OPTION
  // ------------------------------------------------------------

  Widget _buildHelpOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 21,
              ),
            ),

            const SizedBox(width: 14),

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
                      fontSize: 14,
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

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // CONTACT OPTION
  // ------------------------------------------------------------

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.dark,
              size: 22,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 14,
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

            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.lightGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TEMPORARY ACTION
  // ------------------------------------------------------------

  void _showComingSoon(
      BuildContext context,
      String feature,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature will be available soon.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}