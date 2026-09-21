import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/user_data.dart';
import '../../services/auth_service.dart';
import '../../widgets/address_dialog.dart';
import '../auth/login_screen.dart';
import '../order_screen.dart';
import '../wishlist/wishlist_screen.dart';

class BottomAccountScreen extends StatelessWidget {
  const BottomAccountScreen({super.key});

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        content: const Text(
          'Are you sure you want to log out of StyleHub?',
          style: TextStyle(fontSize: 14, color: AppColors.dark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
            // HEADER PROFILE SECTION (Dynamic User Data)
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
                    height: 68,
                    width: 68,
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
                        ValueListenableBuilder<String>(
                          valueListenable: UserData.nameNotifier,
                          builder: (context, name, _) {
                            return Text(
                              name.isNotEmpty ? name : 'User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<String>(
                          valueListenable: UserData.emailNotifier,
                          builder: (context, email, _) {
                            if (email.isEmpty) return const SizedBox.shrink();
                            return Text(
                              email,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 2),
                        ValueListenableBuilder<String>(
                          valueListenable: UserData.phoneNotifier,
                          builder: (context, phone, _) {
                            if (phone.isEmpty) return const SizedBox.shrink();
                            return Text(
                              phone,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            );
                          },
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OrderScreen()),
                    );
                  },
                ),
                const Divider(height: 1, indent: 60),
                _ProfileMenuListItem(
                  icon: Icons.favorite_border,
                  title: 'My Wishlist',
                  subtitle: 'Your most loved styles',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WishlistScreen()),
                    );
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
                      subtitle: 'Change your delivery details',
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
                        showAddressDialog(context);
                      },
                    ),
                  ],
                );
              },
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
                      const SnackBar(content: Text('Help Center is currently online.')),
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
                      const SnackBar(content: Text('Terms & Privacy Policy v1.0')),
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
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, size: 18, color: Colors.red),
                  onPressed: () => _handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red.shade700,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade200, width: 1),
                    ),
                  ),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.red.shade700,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
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