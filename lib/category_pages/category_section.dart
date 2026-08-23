import 'package:flutter/material.dart';

// import '../models/category.dart';
import '../services/api_service.dart';
// import '../screens/category_products_screen.dart';
import '../theme/app_theme.dart';
import 'category.dart';
import 'category_product_screen.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();

    categoriesFuture = ApiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {

        // API is loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // API error
        if (snapshot.hasError) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            ),
          );
        }

        // API data
        final categories = snapshot.data ?? [];

        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {

              final category = categories[index];

              return _CategoryItem(
                icon: Icons.checkroom,
                name: category.name,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryProductsScreen(
                            categoryName: category.name,
                          ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
              AppTheme.primary.withOpacity(0.08),
              child: Icon(
                icon,
                color: AppTheme.primary,
                size: 24,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}