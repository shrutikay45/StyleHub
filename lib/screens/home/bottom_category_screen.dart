import 'package:flutter/material.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/widgets/product_card.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';
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
    final service = ProductService();
    final filteredProducts = service.getByCategory(selectedCategory);
    final isLoading = service.isLoading && filteredProducts.isEmpty;

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

          // RIGHT SIDE OR SKELETON
          Expanded(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: ProductGridSkeleton(itemCount: 6),
                  )
                : filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found in this category',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        itemCount: filteredProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.65,
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
