import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // Get products for category from ProductService
    final List<Product> categoryProducts = (categoryName == 'Special Offers' || categoryName == 'All' || categoryName == 'Recently Viewed')
        ? ProductService().allProducts
        : (categoryName == 'Recommended for you'
            ? ProductService().getRecommendedProducts()
            : ProductService().getByCategory(categoryName));

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.dark,
            size: 20,
          ),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
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
      body: Column(
        children: [
          // Product count and filter buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              12,
            ),
            child: Row(
              children: [
                Text(
                  '${categoryProducts.length} Products',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                // Sort button
                OutlinedButton.icon(
                  onPressed: () {
                    // Sort functionality will be added later.
                  },
                  icon: const Icon(
                    Icons.sort,
                    size: 17,
                  ),
                  label: const Text('Sort'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Filter button
                OutlinedButton.icon(
                  onPressed: () {
                    // Filter functionality will be added later.
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    size: 17,
                  ),
                  label: const Text('Filter'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.dark,
                    side: const BorderSide(
                      color: AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Products or Skeleton
          Expanded(
            child: (ProductService().isLoading && categoryProducts.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ProductGridSkeleton(itemCount: 6),
                  )
                : categoryProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found in this category',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                24,
              ),
              itemCount: categoryProducts.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                // mainAxisExtent: 285,

                // Slightly more vertical space for
                // image + name + rating + price.
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final Product product = categoryProducts[index];

                return _ProductCard(
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




class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Product Details navigation will be added here later.
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product),));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Stack(
              children: [
                product.image.startsWith('http')
                    ? Image.network(
                        product.image,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: double.infinity,
                          height: 170,
                          color: AppColors.blush,
                          child: const Icon(Icons.image_outlined, size: 40, color: AppColors.lightGrey),
                        ),
                      )
                    : Image.asset(
                        product.image,
                        width: double.infinity,
                        height: 170,
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return Container(
                            width: double.infinity,
                            height: 170,
                            color: AppColors.blush,
                            child: const Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: AppColors.lightGrey,
                            ),
                          );
                        },
                      ),

              ],
            ),

            const SizedBox(height: 8),

            // Product name
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Rating
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    size: 15,
                    color: AppColors.rating,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    product.rating.toString(),
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 5),

            // Price
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Row(
                children: [
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      color: AppColors.sale,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (product.oldPrice != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      '₹${product.oldPrice}',
                      style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}