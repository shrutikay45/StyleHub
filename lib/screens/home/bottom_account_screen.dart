import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/order_data.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/screens/auth/login_screen.dart';
import 'package:new_expense/screens/help_center_screen.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';
import 'package:new_expense/services/auth_service.dart';
import 'package:new_expense/widgets/address_dialog.dart';

class BottomAccountScreen extends StatefulWidget {
  const BottomAccountScreen({super.key});

  @override
  State<BottomAccountScreen> createState() => _BottomAccountScreenState();
}

class _BottomAccountScreenState extends State<BottomAccountScreen> {
  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.dark),
        ),
        content: const Text('Are you sure you want to log out of your StyleHub account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('LOG OUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showPolicySheet(String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF555555)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthService.isLoggedIn;
    final userName = isLoggedIn && UserData.name.isNotEmpty && UserData.name != 'Guest User'
        ? UserData.name
        : 'StyleHub Member';
    final userEmail = isLoggedIn && UserData.email.isNotEmpty
        ? UserData.email
        : (UserData.phone.isNotEmpty ? UserData.phone : 'member@stylehub.com');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.dark,
          ),
        ),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.primary, size: 20),
              tooltip: 'Log Out',
              onPressed: _logout,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 1. USER PROFILE CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, Color(0xFFF06292)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'S',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.dark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              userEmail,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (!isLoggedIn)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            elevation: 0,
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => showAddressDialog(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Delivery: ${UserData.location}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.edit_outlined, color: AppColors.primary, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. QUICK SHORTCUTS (ORDERS & WISHLIST)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _QuickCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'My Orders',
                      countText: '${OrderData.orders.length} Placed',
                      color: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF7E22CE),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OrderScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickCard(
                      icon: Icons.favorite_outline,
                      title: 'Wishlist',
                      countText: '${WishlistData.items.length} Saved',
                      color: const Color(0xFFFFE4E6),
                      iconColor: const Color(0xFFE11D48),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WishlistScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. ACCOUNT SETTINGS MENU
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.location_on_outlined,
                    title: 'Saved Delivery Addresses',
                    subtitle: 'Manage your shipping addresses',
                    onTap: () => showAddressDialog(context),
                  ),
                  const Divider(height: 1, indent: 60),
                  _MenuTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Help Center & Support',
                    subtitle: '24x7 Customer Care & FAQ',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 4. POLICIES & APP INFO
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.policy_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _showPolicySheet(
                      'Privacy Policy',
                      'StyleHub respects your privacy and is committed to protecting your personal information. We only collect necessary data for order fulfillment, payments, and providing personalized fashion recommendations.',
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  _MenuTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Use',
                    onTap: () => _showPolicySheet(
                      'Terms of Use',
                      'By using StyleHub, you agree to comply with our terms of service, payment processing policies, and standard returns guidelines.',
                    ),
                  ),
                  const Divider(height: 1, indent: 60),
                  _MenuTile(
                    icon: Icons.info_outline,
                    title: 'About StyleHub',
                    subtitle: 'Version 2.4.0 (Live Backend Edition)',
                    onTap: () => _showPolicySheet(
                      'About StyleHub',
                      'StyleHub is your premier online fashion destination featuring over 84+ curated outfits across 13 collections with instant delivery and secure checkout.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. LOGOUT BUTTON
            if (isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout, color: Color(0xFFE11D48)),
                    label: const Text(
                      'LOG OUT OF STYLEHUB',
                      style: TextStyle(
                        color: Color(0xFFE11D48),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFCDD2), width: 1.5),
                      backgroundColor: const Color(0xFFFFF5F5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Helper Widgets
class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String countText;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.title,
    required this.countText,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    countText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.dark.withValues(alpha: 0.6),
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
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.softBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.dark, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: AppColors.grey),
            )
          : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grey),
      onTap: onTap,
    );
  }
}