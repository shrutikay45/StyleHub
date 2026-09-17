import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/cart_data.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/models/cart_item.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';
// import 'package:new_expense/screens/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Wishlist is empty for now.
  // Later, products will be added here when the favourite icon is pressed.
  // final List<Product> wishlistProducts = [];
  List<Product> get wishlistProducts => WishlistData.items;

  bool isProductInCart(Product product) {
    return CartData.items.any(
          (item) => item.product.name == product.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // --------------------------------------------------
      // APP BAR
      // --------------------------------------------------
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,

        // Back arrow
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 21,
          ),
          color: AppColors.dark,
        ),

        // Cart icon
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomCartScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              size: 25,
            ),
            color: AppColors.dark,
          ),

          const SizedBox(width: 8),
        ],
      ),

      // --------------------------------------------------
      // BODY
      // --------------------------------------------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Wishlist heading
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              16,
            ),
            child: Row(
              children: [
                const Text(
                  'Wishlist',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '(${wishlistProducts.length})',
                  style: TextStyle(
                    color: AppColors.dark.withOpacity(0.5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // EMPTY WISHLIST
          // --------------------------------------------------
          if (wishlistProducts.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 45,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Your wishlist is empty',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Tap the heart icon on products\nyou love to save them here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.dark.withOpacity(0.55),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // --------------------------------------------------
          // WISHLIST PRODUCTS
          // --------------------------------------------------
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  24,
                ),
                physics: const BouncingScrollPhysics(),

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.56,
                ),

                itemCount: wishlistProducts.length,

                itemBuilder: (context, index) {
                  final product = wishlistProducts[index];

                  return _buildWishlistCard(product);
                },
              ),
            ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // WISHLIST PRODUCT CARD
  // --------------------------------------------------
  Widget _buildWishlistCard(Product product) {
    final int discount = product.oldPrice > product.price
        ? ((product.oldPrice - product.price) /
        product.oldPrice *
        100)
        .round()
        : 0;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
              isFromWishlist: true,
            ),
          ),
        );

        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // IMAGE
            // --------------------------------------------------
            Expanded(
              // flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryLight.withOpacity(0.3),
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                  // Discount
                  if (discount > 0)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$discount% OFF',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --------------------------------------------------
            // PRODUCT DETAILS
            // --------------------------------------------------
            Expanded(
              // flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  10,
                  8,
                  10,
                  8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // Rating
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.star,
                            color: Colors.green.shade700,
                            size: 11,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Price
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 6),

                        if (product.oldPrice > product.price)
                          Flexible(
                            child: Text(
                              '₹${product.oldPrice.toStringAsFixed(0)}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11,
                                decoration:
                                TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    // Add to Bag
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {
                          final alreadyInCart = isProductInCart(product);

                          if (!alreadyInCart) {
                            const selectedSize = 'M';

                            final existingIndex = CartData.items.indexWhere(
                                  (item) =>
                              item.product.name == product.name &&
                                  item.size == selectedSize,
                            );

                            if (existingIndex != -1) {
                              CartData.items[existingIndex].quantity++;
                            } else {
                              CartData.items.add(
                                CartItem(
                                  product: product,
                                  size: selectedSize,
                                ),
                              );
                            }

                            setState(() {});

                           }

                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isProductInCart(product)
                                ? Colors.grey
                                : AppColors.primary,
                          ),
                          foregroundColor: isProductInCart(product)
                              ? Colors.grey
                              : AppColors.primary,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: isProductInCart(product)
                            ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              size: 16,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'ITEM IN CART',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                            : const Text(
                          'ADD TO CART',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}