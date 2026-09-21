import 'package:flutter/material.dart';
import 'package:new_expense/widgets/address_dialog.dart';
import 'package:new_expense/data/user_data.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/data/mock_products.dart';
import 'package:new_expense/screens/home/HomeWidgets/featured_products.dart';
import 'package:new_expense/screens/home/HomeWidgets/flash_sale.dart';
import 'package:new_expense/screens/home/HomeWidgets/home_banner.dart';
import 'package:new_expense/screens/home/HomeWidgets/home_categories.dart';
import 'package:new_expense/screens/home/HomeWidgets/home_search_bar.dart';
import 'package:new_expense/screens/home/HomeWidgets/recently_viewed_products.dart';
import 'package:new_expense/screens/home/HomeWidgets/recommendes_products.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';
import 'package:new_expense/screens/home/cart_screen.dart';
import 'package:new_expense/screens/home/notification_screen.dart';
import 'package:new_expense/screens/wishlist/wishlist_screen.dart';
import 'package:new_expense/widgets/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ProductService().addListener(_onProductsUpdated);
  }

  @override
  void dispose() {
    ProductService().removeListener(_onProductsUpdated);
    super.dispose();
  }

  void _onProductsUpdated() {
    if (mounted) setState(() {});
  }

  Future<void> _refresh() async {
    await ProductService().fetchAllProducts(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: AppColors.dark,
                ),
              );
            }
          ),

           title: const Text(
            'StyleHub',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

        actions: [

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.dark,
            ),
          ),

          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomCartScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.dark,
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WishlistScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        ],


      ),
      body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Location section
                  ValueListenableBuilder<String>(
                    valueListenable: UserData.locationNotifier,
                    builder: (context, loc, _) {
                      return InkWell(
                        onTap: () {
                          showAddressDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                              const SizedBox(width: 4),
                              const Text('Deliver to: ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              Expanded(
                                child: Text(
                                  loc, 
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.dark),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Icon(Icons.edit, size: 14, color: AppColors.grey),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                  // search bar section
                  const HomeSearchBar(),
                  // categories header section
                  const SizedBox(height: 24),
                  const HomeCategories(),
                  const SizedBox(height: 24),
                  const HomeBanner(),

                  const SizedBox(height: 20),

                  // featured products
                  const FeaturedProducts(),

                  // recommended product section
                  const RecommendedProductsSection(),

                  // flash sale
                  const SizedBox(height: 20),
                  const FlashSale(),
                  const SizedBox(height: 24),


                  // recently viewed products
                  const SizedBox(height: 24),

                  const RecentlyViewedProducts()

                ],
              ),
            ),
          )
      ),
      // bottom navigation

    );
  }
}
