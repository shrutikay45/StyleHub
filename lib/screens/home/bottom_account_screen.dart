import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/order_data.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/screens/auth/login_screen.dart';
import 'package:new_expense/screens/help_center_screen.dart';
import 'package:new_expense/screens/home/notification_screen.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';
import 'package:new_expense/services/api_config.dart';
import 'package:new_expense/services/auth_service.dart';
import 'package:new_expense/data/address_data.dart';
import 'package:new_expense/models/address_model.dart';
import 'package:new_expense/widgets/address_dialog.dart';

class BottomAccountScreen extends StatefulWidget {
  const BottomAccountScreen({super.key});

  @override
  State<BottomAccountScreen> createState() => _BottomAccountScreenState();
}

class _BottomAccountScreenState extends State<BottomAccountScreen> {
  @override
  void initState() {
    super.initState();
    AddressData.init().then((_) {
      if (mounted) setState(() {});
    });
  }
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
      UserData.clear();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: UserData.name);
    final phoneCtrl = TextEditingController(text: UserData.phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Profile Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.dark),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      UserData.name = nameCtrl.text.trim();
                      if (phoneCtrl.text.trim().isNotEmpty) {
                        UserData.phone = phoneCtrl.text.trim();
                      }
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Color(0xFF0F8A5F),
                      ),
                    );
                  }
                },
                child: const Text('SAVE CHANGES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchLiveCoupons() async {
    try {
      final uri = Uri.parse(ApiConfig.coupons);
      final response = await http.get(uri, headers: ApiConfig.headers()).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        if (jsonBody['success'] == true && jsonBody['data'] is List && (jsonBody['data'] as List).isNotEmpty) {
          final liveList = List<Map<String, dynamic>>.from(jsonBody['data']);
          final activeList = liveList.where((c) => c['active'] == true).toList();
          if (activeList.isNotEmpty) return activeList;
        }
      }
    } catch (e) {
      debugPrint('Error fetching live coupons: $e');
    }
    return [
      {
        'code': '3102026',
        'description': 'Special 30% OFF festive discount on all fashion orders',
        'discountType': 'PERCENTAGE',
        'discountValue': 30,
        'minOrderValue': 0,
        'maxDiscountAmount': 3000,
        'active': true,
      },
    ];
  }

  void _showCouponsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Available Offers & Coupons',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.dark),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchLiveCoupons(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                        );
                      }

                      final coupons = snapshot.data ?? [];
                      if (coupons.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.local_offer_outlined, size: 40, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                const Text(
                                  'No Active Coupons Available',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.dark),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Check back soon for exclusive discounts and festive deals!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: coupons.map((c) {
                          final code = c['code']?.toString() ?? '3102026';
                          final desc = c['description']?.toString() ?? '';
                          final isPercent = (c['discountType']?.toString().toUpperCase() == 'PERCENTAGE');
                          final discountVal = c['discountValue']?.toString() ?? '30';
                          final discountTag = isPercent ? '$discountVal% OFF' : '₹$discountVal OFF';
                          final minOrder = c['minOrderValue'] != null && (c['minOrderValue'] as num) > 0
                              ? 'Min order ₹${c['minOrderValue']}'
                              : 'No minimum order value';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.primary),
                                  ),
                                  child: Text(
                                    code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      fontSize: 13,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        desc.isNotEmpty ? desc : discountTag,
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.dark),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        minOrder,
                                        style: const TextStyle(fontSize: 11, color: AppColors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                                  tooltip: 'Copy Code',
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: code));
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Coupon code $code copied!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final hasName = UserData.name.trim().isNotEmpty;
    final userName = hasName ? UserData.name.trim() : '';
    final userSubtitle = UserData.email.trim().isNotEmpty
        ? UserData.email.trim()
        : (UserData.phone.trim().isNotEmpty ? UserData.phone.trim() : '');

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

            // 1. USER PROFILE CARD (REAL DATA ONLY - NO DUMMY VALUES)
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
              child: isLoggedIn
                  ? Column(
                      children: [
                        Row(
                          children: [
                            // Gradient Initial Avatar
                            Container(
                              width: 56,
                              height: 56,
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
                                  hasName ? userName[0].toUpperCase() : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          hasName ? userName : 'Account User',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.dark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      GestureDetector(
                                        onTap: _showEditProfileDialog,
                                        child: const Icon(
                                          Icons.edit_note,
                                          size: 20,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (userSubtitle.isNotEmpty) ...[
                                    const SizedBox(height: 3),
                                    Text(
                                      userSubtitle,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.grey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<List<AddressItem>>(
                          valueListenable: AddressData.notifier,
                          builder: (context, addresses, _) {
                            final selected = AddressData.selectedAddress;
                            final hasAddress = selected != null;
                            final locText = hasAddress ? selected.fullDisplayText : '';

                            return InkWell(
                              onTap: () async {
                                await showAddressDialog(context);
                                if (mounted) setState(() {});
                              },
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
                                        hasAddress ? 'Delivery: $locText' : 'Add delivery address',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      hasAddress ? Icons.edit_outlined : Icons.add_circle_outline,
                                      color: AppColors.primary,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_outline, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Welcome to StyleHub',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.dark,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Sign in to access orders & wishlist',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            ).then((_) {
                              if (mounted) setState(() {});
                            });
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
            ),

            const SizedBox(height: 16),

            // 2. QUICK SHORTCUTS (2x2 GRID: REAL LIVE ACTIONS)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _QuickCard(
                          icon: Icons.inventory_2_outlined,
                          title: 'My Orders',
                          countText: '${OrderData.orders.length} ${OrderData.orders.length == 1 ? "Order" : "Orders"}',
                          color: const Color(0xFFF3E8FF),
                          iconColor: const Color(0xFF7E22CE),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const OrderScreen()),
                            ).then((_) {
                              if (mounted) setState(() {});
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickCard(
                          icon: Icons.favorite_outline,
                          title: 'Wishlist',
                          countText: '${WishlistData.items.length} ${WishlistData.items.length == 1 ? "Item" : "Items"}',
                          color: const Color(0xFFFFE4E6),
                          iconColor: const Color(0xFFE11D48),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const WishlistScreen()),
                            ).then((_) {
                              if (mounted) setState(() {});
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _QuickCard(
                          icon: Icons.notifications_none_outlined,
                          title: 'Notifications',
                          countText: 'Inbox & Alerts',
                          color: const Color(0xFFE0F2FE),
                          iconColor: const Color(0xFF0284C7),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickCard(
                          icon: Icons.local_offer_outlined,
                          title: 'Coupons',
                          countText: 'Live Offers',
                          color: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF16A34A),
                          onTap: _showCouponsSheet,
                        ),
                      ),
                    ],
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
                  ValueListenableBuilder<List<AddressItem>>(
                    valueListenable: AddressData.notifier,
                    builder: (context, addresses, _) {
                      final selected = AddressData.selectedAddress;
                      final subText = (selected != null)
                          ? selected.fullDisplayText
                          : 'Add and manage shipping addresses';

                      return _MenuTile(
                        icon: Icons.location_on_outlined,
                        title: 'Saved Delivery Addresses',
                        subtitle: subText,
                        onTap: () async {
                          await showAddressDialog(context);
                          if (mounted) setState(() {});
                        },
                      );
                    },
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
                    subtitle: 'Version 2.4.0',
                    onTap: () => _showPolicySheet(
                      'About StyleHub',
                      'StyleHub is your premier online fashion destination featuring curated outfits across multiple collections with instant delivery and secure checkout.',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. LOGOUT BUTTON (SHOWN ONLY WHEN LOGGED IN)
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.dark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    countText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: AppColors.dark.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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