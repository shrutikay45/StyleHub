import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';
// import 'package:new_expense/constants/app_colors.dart';
// import 'package:new_expense/screens/wishlist_screen.dart';

class BottomAccountScreen extends StatelessWidget {
  const BottomAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------------------------------------------
            // TOP APP BAR
            // -----------------------------------------------------------
            Container(
              height: 40,
              // padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColors.background,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.dark,
                    ),
                  ),
                ],
              ),
            ),

            // -----------------------------------------------------------
            // CONTENT
            // -----------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ---------------------------------------------------
                    // DARK PROFILE BANNER
                    // ---------------------------------------------------
                    Container(
                      height: 130,
                      width: double.infinity,
                      color: AppColors.dark.withOpacity(0.85),
                    ),

                    // ---------------------------------------------------
                    // PROFILE IMAGE + LOGIN BUTTON
                    // ---------------------------------------------------
                    SizedBox(
                      height: 115,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Profile placeholder
                          Positioned(
                            left: 20,
                            top: -60,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.dark.withOpacity(0.10),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.dark.withOpacity(0.06),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 115,
                                color: AppColors.dark.withOpacity(0.75),
                              ),
                            ),
                          ),

                          // Login / Sign Up button
                          Positioned(
                            left: 160,
                            right: 20,
                            top: 22,
                            child: SizedBox(
                              height: 47,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Login / Sign Up screen
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.background,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                child: const Text(
                                  'LOG IN/SIGN UP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ---------------------------------------------------
                    // SECTION DIVIDER
                    // ---------------------------------------------------
                    Container(
                      height: 20,
                      color: AppColors.dark.withOpacity(0.05),
                    ),

                    // ---------------------------------------------------
                    // ORDERS
                    // ---------------------------------------------------
                    _ProfileMenuItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Orders',
                      subtitle: 'Check your order status',
                      onTap: () {
                        // Orders screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(),));
                      },
                    ),

                    // ---------------------------------------------------
                    // HELP CENTER
                    // ---------------------------------------------------
                    _ProfileMenuItem(
                      icon: Icons.support_agent_outlined,
                      title: 'Help Center',
                      subtitle: 'Help regarding your recent purchases',
                      onTap: () {
                        // Help Center screen
                      },
                    ),

                    // ---------------------------------------------------
                    // WISHLIST
                    // ---------------------------------------------------
                    _ProfileMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Wishlist',
                      subtitle: 'Your most loved styles',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WishlistScreen(),
                          ),
                        );
                      },
                    ),

                    // ---------------------------------------------------
                    // SECTION DIVIDER
                    // ---------------------------------------------------
                    Container(
                      height: 20,
                      color: AppColors.dark.withOpacity(0.05),
                    ),

                    // ---------------------------------------------------
                    // INFORMATION LINKS
                    // ---------------------------------------------------
                    _ProfileSimpleItem(
                      title: 'FAQs',
                      onTap: () {},
                    ),

                    _ProfileSimpleItem(
                      title: 'ABOUT US',
                      onTap: () {},
                    ),

                    _ProfileSimpleItem(
                      title: 'TERMS OF USE',
                      onTap: () {},
                    ),

                    _ProfileSimpleItem(
                      title: 'PRIVACY POLICY',
                      onTap: () {},
                    ),

                    _ProfileSimpleItem(
                      title: 'GRIEVANCE REDRESSAL',
                      onTap: () {},
                    ),


                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================================
// PROFILE MENU ITEM
// =======================================================================

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.dark.withOpacity(0.10),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Icon
              SizedBox(
                width: 30,
                child: Icon(
                  icon,
                  size: 30,
                  color: AppColors.dark.withOpacity(0.45),
                ),
              ),

              const SizedBox(width: 20),

              // Text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.dark.withOpacity(0.50),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                size: 27,
                color: AppColors.dark.withOpacity(0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =======================================================================
// SIMPLE INFORMATION ITEM
// =======================================================================

class _ProfileSimpleItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ProfileSimpleItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.only(
            left: 80,
            right: 30,
          ),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.dark.withOpacity(0.65),
            ),
          ),
        ),
      ),
    );
  }
}