import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/category_products_screen.dart';
// import '../screens/category_products_screen.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  static const List<Map<String, String>> categories = [
    {
      'name': 'Dresses',
      'image': 'assets/images/dress1.webp',
    },
    {
      'name': 'Tops',
      'image': 'assets/images/top.webp',
    },
    {
      'name': 'T-Shirts',
      'image': 'assets/images/tshirt.webp',
    },
    {
      'name': 'Footwear',
      'image': 'assets/images/footwear.webp',
    },
    {
      'name': 'Bags',
      'image': 'assets/images/pink_bag.webp',
    },
    {
      'name': 'Accessories',
      'image': 'assets/images/accessories.webp',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 105,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsScreen(
                          categoryName: category['name']!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          category['image']!,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        category['name']!,
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}