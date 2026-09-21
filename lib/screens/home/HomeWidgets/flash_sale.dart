import 'package:flutter/material.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/fashsaleviewscreen/sale_products_viewall_screen.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';

class FlashSale extends StatelessWidget {
  const FlashSale({super.key});

  // helper for flash sale
  Widget _saleTimeBox(String time) {
    return Container(
      width: 32,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD81B60),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashProducts = ProductService().getFlashSaleProducts();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFCE4EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---------------------------
          // HEADER
          // ---------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD81B60),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                  // Later we will navigate to the full sale page
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const FlashSaleProductsScreen(),
                      ),
                    );
                  },
                child: const Text(
                  'View All →',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD81B60),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ---------------------------
          // SALE SUBTITLE
          // ---------------------------
          const Text(
            'Up to 50% OFF',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF222222),
            ),
          ),

          const SizedBox(height: 3),

          const Text(
            'Limited time only',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF777070),
            ),
          ),

          const SizedBox(height: 14),

          // ---------------------------
          // COUNTDOWN
          // ---------------------------
          Row(
            children: [

              const Text(
                'Ends in',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),

              const SizedBox(width: 8),

              _saleTimeBox('02'),
              const SizedBox(width: 4),
              const Text(':'),
              const SizedBox(width: 4),
              _saleTimeBox('14'),
              const SizedBox(width: 4),
              const Text(':'),
              const SizedBox(width: 4),
              _saleTimeBox('36'),
            ],
          ),

          const SizedBox(height: 18),

          // ---------------------------
          // PRODUCTS
          // ---------------------------
          SizedBox(
            height: 205,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: flashProducts.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {

                final product = flashProducts[index];

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
                  child: SizedBox(
                    width: 125,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // PRODUCT IMAGE
                        Stack(
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Container(
                                width: 125,
                                height: 135,
                                color: Colors.white,
                                child: product.image.startsWith('http')
                                    ? Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFFCE4EC),
                                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                                        ),
                                      )
                                    : Image.asset(
                                        product.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: const Color(0xFFFCE4EC),
                                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                                        ),
                                      ),
                              ),
                            ),

                            // DISCOUNT BADGE
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD81B60),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'SALE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // PRODUCT NAME
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF222222),
                          ),
                        ),

                        const SizedBox(height: 3),

                        // PRICE
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF222222),
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
      ),
    );

  }
}



