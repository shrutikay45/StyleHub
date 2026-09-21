import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';

class RecentlyViewedProducts extends StatelessWidget {
  const RecentlyViewedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ProductService();
    final products = service.getRecentlyViewedProducts();
    final isLoading = service.isLoading && products.isEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recently Viewed',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.dark,
                ),
              ),

              Container(
                height: 34,
                width: 34,
                decoration: const BoxDecoration(
                  color: AppColors.dark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_outlined,
                  color: AppColors.background,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isLoading
              ? const ProductGridSkeleton(itemCount: 3)
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.take(6).length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.58,
                  ),
            itemBuilder: (context, index) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                        product: product,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                    // --------------------------------
                    // PRODUCT IMAGE
                    // --------------------------------
                
                    Expanded(
                      child: Stack(
                        children: [
                
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Container(
                              width: double.infinity,
                              color: AppColors.background,
                              child: product.image.startsWith('http')
                                  ? Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: AppColors.blush,
                                        child: const Icon(Icons.image_outlined, color: AppColors.lightGrey),
                                      ),
                                    )
                                  : Image.asset(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: AppColors.blush,
                                        child: const Icon(Icons.image_outlined, color: AppColors.lightGrey),
                                      ),
                                    ),
                            ),
                          ),
                
                          // --------------------------------
                          // RATING BADGE
                          // --------------------------------
                
                          Positioned(
                            left: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                
                                  Text(
                                    product.rating.toString(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF222222),
                                    ),
                                  ),
                
                                  const SizedBox(width: 3),
                
                                  const Icon(
                                    Icons.star,
                                    size: 11,
                                    color: Color(0xFF0F8A5F),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    const SizedBox(height: 7),
                
                    // --------------------------------
                    // PRODUCT NAME
                    // --------------------------------
                
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:AppColors.dark,
                      ),
                    ),
                
                    const SizedBox(height: 4),
                
                    // --------------------------------
                    // PRICE
                    // --------------------------------
                
                    Row(
                      children: [
                
                        Text(
                          '₹${product.oldPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9B9B9B),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                
                        const SizedBox(width: 6),
                
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),

      ],

    );




  }
}



