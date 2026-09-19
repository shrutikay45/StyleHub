import 'package:flutter/material.dart';
import 'package:new_expense/data/mock_products.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';

class RecommendedProductsSection extends StatelessWidget {
  const RecommendedProductsSection({super.key});

  // Mock product data
  // static const List<Map<String, dynamic>> products = [
  //   {
  //     'name': 'Floral Summer Dress',
  //     'price': '1,299',
  //     'image': 'assets/images/dress1.webp',
  //   },
  //   {
  //     'name': 'Elegant Casual Top',
  //     'price': '899',
  //     'image': 'assets/images/top1.webp',
  //   },
  //   {
  //     'name': 'Women Denim Jeans',
  //     'price': '1,499',
  //     'image': 'assets/images/jeans1.webp',
  //   },
  //   {
  //     'name': 'Classic Handbag',
  //     'price': '1,199',
  //     'image': 'assets/images/pink_bag.webp',
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recommended product section
        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text(
                'Recommended for you',
                style: TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF555555),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Product list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final product = mockProducts[index];

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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product image + wishlist button
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              product.image,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return Container(
                                  height: 180,
                                  width: double.infinity,
                                  color: const Color(0xFFF5F5F5),
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 40,
                                    color: Color(0xFFAAAAAA),
                                  ),
                                );
                              },
                            ),
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
                            color: Color(0xFF222222),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Product price
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Text(
                          '₹${product.price}',
                          style: const TextStyle(
                            color: Color(0xFFE91E63),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}