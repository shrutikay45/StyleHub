import 'package:flutter/material.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';

class FlashSaleProductsScreen extends StatelessWidget {
  const FlashSaleProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ProductService();
    final saleProducts = service.getFlashSaleProducts();
    final isLoading = service.isLoading && saleProducts.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF222222),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Flash Sale',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // --------------------------------------------------
          // SALE HEADER
          // --------------------------------------------------
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8EF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Text(
                  '🔥',
                  style: TextStyle(
                    fontSize: 28,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Up to 50% OFF',
                        style: TextStyle(
                          color: Color(0xFFD81B60),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        '${saleProducts.length} products on sale',
                        style: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // PRODUCT COUNT
          // --------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              '${saleProducts.length} Products',
              style: const TextStyle(
                color: Color(0xFF222222),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // --------------------------------------------------
          // PRODUCT GRID OR SKELETON
          // --------------------------------------------------
          Expanded(
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ProductGridSkeleton(itemCount: 6),
                  )
                : saleProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No sale products available',
                          style: TextStyle(
                            color: Color(0xFF777777),
                            fontSize: 15,
                          ),
                        ),
                      )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24,
              ),
              itemCount: saleProducts.length,

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.68,
              ),

              itemBuilder: (context, index) {
                final product = saleProducts[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(
                              product: product,
                            ),
                      ),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                      
                          // PRODUCT IMAGE
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: product.image.startsWith('http')
                                    ? Image.network(
                                        product.image,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 180,
                                          width: double.infinity,
                                          color: const Color(0xFFF5F5F5),
                                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                                        ),
                                      )
                                    : Image.asset(
                                        product.image,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 180,
                                          width: double.infinity,
                                          color: const Color(0xFFF5F5F5),
                                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                                        ),
                                      ),
                              ),
                      
                              // SALE BADGE
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD81B60),
                                    borderRadius:
                                    BorderRadius.circular(7),
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
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
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
                      
                          const SizedBox(height: 5),
                      
                          // PRICE
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFF222222),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                      
                                const SizedBox(width: 6),
                      
                                Text(
                                  '₹${product.oldPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    decoration:
                                    TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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