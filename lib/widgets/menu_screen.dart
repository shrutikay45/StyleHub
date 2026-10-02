import 'package:flutter/material.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';
import 'package:new_expense/screens/home/bottom_category_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';
import 'package:new_expense/screens/order_screen.dart';
import 'package:new_expense/screens/help_center_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primaryLight,
                      child: const Icon(
                        Icons.person_outline,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
          
                    const SizedBox(width: 14),
          
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${UserData.name.split(' ')[0]}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          'View Profile',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          
              const Divider(),
          
              // Menu items

              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: const Text('Categories'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomCategoryScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Wishlist'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistScreen(),
                    ),
                  );
                },
              ),
          
              ListTile(
                leading: const Icon(Icons.shopping_bag_outlined),
                title: const Text('My Orders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderScreen()));
                },
              ),
          
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined),
                title: const Text('Cart'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BottomCartScreen(),));
                },
              ),
          
              const Divider(),
          
              ListTile(
                leading: const Icon(Icons.local_offer_outlined),
                title: const Text('Offers & Deals'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text('Coupons'),
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => SafeArea(
                      child: Padding(
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
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.local_offer, color: AppColors.primary),
                              ),
                              title: const Text('3102026 (30% OFF)', style: TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: const Text('Special 30% OFF festive discount on all orders'),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Coupon code 3102026 copied to clipboard!')),
                                  );
                                },
                                child: const Text('COPY', style: TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpCenterScreen(),
                    ),
                  );
                },
              ),
          
              // const Spacer(),
          
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppColors.primary,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
          
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}