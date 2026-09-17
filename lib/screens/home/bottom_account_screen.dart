import 'package:flutter/material.dart';
import 'package:new_expense/widgets/address_dialog.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';

class BottomAccountScreen extends StatelessWidget {
  const BottomAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -----------------------------------------------------------
            // HEADER PROFILE SECTION (Flipkart Style)
            // -----------------------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserData.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          UserData.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          UserData.phone,
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

            const SizedBox(height: 16),

            // -----------------------------------------------------------
            // SHOPPING & ORDERS CARD
            // -----------------------------------------------------------
            _buildMenuGroup(
              context,
              title: 'Shopping',
              children: [
                _ProfileMenuListItem(
                  icon: Icons.inventory_2_outlined,
                  title: 'My Orders',
                  subtitle: 'Track, return, or buy things again',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen(),));
                  },
                ),
                const Divider(height: 1, indent: 60),
                _ProfileMenuListItem(
                  icon: Icons.favorite_border,
                  title: 'My Wishlist',
                  subtitle: 'Your most loved styles',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const WishlistScreen(),));
                  },
                ),
              ],
            ),

            // -----------------------------------------------------------
            // ACCOUNT SETTINGS CARD
            // -----------------------------------------------------------
            ValueListenableBuilder<String>(
              valueListenable: UserData.locationNotifier,
              builder: (context, loc, _) {
                return _buildMenuGroup(
                  context,
                  title: 'Account Settings',
                  children: [
                    _ProfileMenuListItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Change your name, phone, etc.',
                      onTap: () {
                        showAddressDialog(context);
                      },
                    ),
                    const Divider(height: 1, indent: 60),
                    _ProfileMenuListItem(
                      icon: Icons.location_on_outlined,
                      title: 'Saved Addresses',
                      subtitle: loc,
                      onTap: () {
                        // Show dialog to change location
                        showAddressDialog(context);
                      },
                    ),
                  ],
                );
              }
            ),

            // -----------------------------------------------------------
            // SUPPORT CARD
            // -----------------------------------------------------------
            _buildMenuGroup(
              context,
              title: 'Feedback & Information',
              children: [
                _ProfileMenuListItem(
                  icon: Icons.support_agent_outlined,
                  title: 'Help Center',
                  subtitle: 'Help regarding your recent purchases',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help Center is currently unavailable.')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 60),
                _ProfileMenuListItem(
                  icon: Icons.article_outlined,
                  title: 'Policies',
                  subtitle: 'Terms of Use, Privacy Policy',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Policies documentation will be available soon.')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // -----------------------------------------------------------
            // LOGOUT BUTTON
            // -----------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout action (dummy for now)
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper method to build grouped cards
  Widget _buildMenuGroup(BuildContext context, {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================================
// PROFILE LIST ITEM
// =======================================================================
class _ProfileMenuListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuListItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 22,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}