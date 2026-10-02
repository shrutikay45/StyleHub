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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No coupons available at the moment.')),
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