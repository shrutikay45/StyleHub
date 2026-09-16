import 'package:flutter/material.dart';
import 'package:new_expense/data/mock_products.dart';
import 'package:new_expense/widgets/product_card.dart';

import '../../core/constants/app_colors.dart';

class BottomCategoryScreen extends StatefulWidget {
  const BottomCategoryScreen({super.key});

  @override
  State<BottomCategoryScreen> createState() => _BottomCategoryScreenState();

}

class _BottomCategoryScreenState extends State<BottomCategoryScreen> {
  String selectedCategory = 'Dresses';
  final List<String> categories = [
    'Dresses',
    'Tops',
    'Jeans',
    'T-Shirts',
    'Kurtis',
    'Sarees',
    'Ethnic Wear',
    'Shoes',
    'Bags',
    'Jewellery',
    'Skirts',
    'Co-ords',
    'Western Wear',
  ];

  @override

  Widget build(BuildContext context) {
    final filteredProducts = mockProducts
        .where(
          (product) => product.category == selectedCategory,
    )
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: AppColors.dark,
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          // LEFT CATEGORY SECTION
          Container(
            width: 105,
            color: AppColors.background,

            child: ListView.builder(
              itemCount: categories.length,

              itemBuilder: (context, index) {
                final category = categories[index];

                return _CategoryItem(
                  title: category,

                  isSelected: selectedCategory == category,

                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              },
            ),
          ),

          // RIGHT SIDE
          Expanded(
            child: GridView.builder(
              itemCount: filteredProducts.length,

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),

              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}





// helper for left side category
class _CategoryItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;


  const _CategoryItem({
    required this.title,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.background
              : AppColors.softBackground,

          border: isSelected
              ? const Border(
            left: BorderSide(
              color: AppColors.primary,
              width: 3,
            ),
          )
              : null,
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),

            child: Text(
              title,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 13,

                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w400,

                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
