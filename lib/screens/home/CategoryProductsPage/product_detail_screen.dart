import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/cart_data.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/models/cart_item.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/screens/checkout_screen.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';
import 'package:new_expense/screens/home/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool isFromWishlist;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.isFromWishlist = false,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final PageController _pageController = PageController();
  int currentImageIndex = 0;

  String selectedSize = 'S';
  bool isWishlisted = false;
  bool isAddedToCart = false;

  @override
  void initState() {
    super.initState();

    if (widget.isFromWishlist) {
      isWishlisted = WishlistData.contains(widget.product);
    }
  }

  final List<String> sizes = [
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    final int discountPercentage =
    product.oldPrice != null && product.oldPrice! > product.price
        ? (((product.oldPrice! - product.price) /
        product.oldPrice!) *
        100)
        .round()
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // --------------------------------------------------
          // Product Image
          // --------------------------------------------------
          SliverAppBar(
            expandedHeight: 440,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: _CircleIconButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              _CircleIconButton(
                icon: isWishlisted
                    ? Icons.favorite
                    : Icons.favorite_border,
                iconColor: isWishlisted
                    ? AppColors.primary
                    : AppColors.dark,
                onTap: () {
                  setState(() {
                    if (isWishlisted) {
                      WishlistData.remove(widget.product);
                      isWishlisted = false;
                    } else {
                      WishlistData.add(widget.product);
                      isWishlisted = true;
                    }
                  });
                },
              ),
              const SizedBox(width: 20),

            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Positioned.fill(
                   child: PageView.builder(
                     controller: _pageController,
                     itemCount: product.images.length,
                     onPageChanged: (index) {
                       setState(() {
                         currentImageIndex = index;
                       });
                     },
                     itemBuilder: (context, index) {
                       return Image.asset(
                         product.images[index],
                         fit: BoxFit.cover,
                         errorBuilder: (
                             context,
                             error,
                             stackTrace,
                             ) {
                           return Container(
                             color: AppColors.blush,
                             child: const Icon(
                               Icons.image_outlined,
                               size: 55,
                               color: AppColors.lightGrey,
                             ),
                           );
                         },
                       );
                     },
                   ),
                  ),

                  // Image indicators
                  if (product.images.length > 1)
                    Positioned(
                      bottom: 18,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.images.length,
                              (index) {
                            return _ImageIndicator(
                              isSelected: index == currentImageIndex,
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------
          // Product Content
          // --------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Rating + category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius:
                          BorderRadius.circular(7),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.rating,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toString(),
                              style: const TextStyle(
                                color: AppColors.dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        '4.5K+ ratings',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        product.category,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Price section
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${product.price}',
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          '₹${product.oldPrice}',
                          style: const TextStyle(
                            color: AppColors.lightGrey,
                            fontSize: 15,
                            decoration:
                            TextDecoration.lineThrough,
                          ),
                        ),
                      ],

                      if (discountPercentage > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius:
                            BorderRadius.circular(5),
                          ),
                          child: Text(
                            '$discountPercentage% OFF',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'Inclusive of all taxes',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Divider(
                    color: AppColors.border,
                    height: 1,
                  ),

                  const SizedBox(height: 22),

                  // --------------------------------------------------
                  // Size Selection
                  // --------------------------------------------------
                  Row(
                    children: [
                      const Text(
                        'Select Size',
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
                          'Size Guide',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: sizes.length,
                      separatorBuilder: (
                          context,
                          index,
                          ) {
                        return const SizedBox(width: 10);
                      },
                      itemBuilder: (context, index) {
                        final String size = sizes[index];

                        return _SizeButton(
                          size: size,
                          isSelected:
                          selectedSize == size,
                          onTap: () {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // Delivery
                  // --------------------------------------------------
                  const Text(
                    'Delivery & Services',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.softBackground,
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.border,
                      ),
                    ),
                    child: Column(
                      children: [
                        _ServiceRow(
                          icon:
                          Icons.local_shipping_outlined,
                          title: 'Free Delivery',
                          subtitle:
                          'Available on this product',
                        ),
                        const SizedBox(height: 16),
                        _ServiceRow(
                          icon:
                          Icons.assignment_return_outlined,
                          title: 'Easy Returns',
                          subtitle:
                          'Easy return within 7 days',
                        ),
                        const SizedBox(height: 16),
                        _ServiceRow(
                          icon:
                          Icons.verified_outlined,
                          title: '100% Genuine',
                          subtitle:
                          'Quality checked products',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // --------------------------------------------------
                  // Description
                  // --------------------------------------------------
                  const Text(
                    'About this product',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Elevate your wardrobe with this stylish '
                        '${product.name.toLowerCase()}. Designed '
                        'for comfort and everyday elegance, this '
                        'piece is perfect for creating effortless '
                        'fashionable looks.',
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Selected size information
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.blush,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Size $selectedSize selected',
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // --------------------------------------------------
      // Bottom Add To Cart
      // --------------------------------------------------
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            12,
          ),
          decoration: const BoxDecoration(
            color: AppColors.background,

          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isAddedToCart) {
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

                        setState(() {
                          isAddedToCart = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Item added to cart',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            duration: const Duration(seconds: 4),
                            action: SnackBarAction(
                              label: 'Go to Cart',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomCartScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BottomCartScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.background,
                      foregroundColor: AppColors.dark,
                      elevation: 0,
                      side: const BorderSide(
                        width: 1,
                        color: Colors.grey,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isAddedToCart ? 'Go to Cart' : 'Add to Cart',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            buyNowItem: CartItem(
                              product: product,
                              size: selectedSize,
                              quantity: 1,
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Circle Icon Button
// --------------------------------------------------

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor = AppColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        icon: Icon(
          icon,
          color: iconColor,
          size: 18,
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Image Indicator
// --------------------------------------------------

class _ImageIndicator extends StatelessWidget {
  final bool isSelected;

  const _ImageIndicator({
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isSelected ? 20 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary
            : AppColors.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// --------------------------------------------------
// Size Button
// --------------------------------------------------

class _SizeButton extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const _SizeButton({
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight
              : AppColors.background,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected
                ? AppColors.primary
                : AppColors.dark,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// Service Row
// --------------------------------------------------

class _ServiceRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ServiceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}