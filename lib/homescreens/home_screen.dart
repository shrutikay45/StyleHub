import 'package:flutter/material.dart';
import '../category_pages/category_section.dart';
import '../theme/app_theme.dart';
import 'SuggestedForYou/main_suggested_screen.dart';
import 'hero_banner/hero_banner.dart';
import 'lookingforsec/main_looking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        // Menu icon
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: AppTheme.primary,
          ),
        ),
        // App name
        title: const Text(
          'STYLE-HUB',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: AppTheme.primary,
          ),
        ),centerTitle: true,
        actions: [
          // Wishlist
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              color: AppTheme.primary,
            ),
          ),

          // Cart
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
      // now making body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products',
                  hintStyle: const TextStyle(
                    color: AppTheme.secondaryText,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.secondaryText,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppTheme.primary,
                      width: 1,
                    ),
                  ),
        
                ),
              ),
              const SizedBox(height: 20),

              const CategoriesSection(),
              const SizedBox(height: 20),
              const HeroBanner(),
              const SizedBox(height: 20),
        
              const LookingForSection(),

              const SizedBox(height: 24),

              const SuggestedForYouSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// to reuse the category code
