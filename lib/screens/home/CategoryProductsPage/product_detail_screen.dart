import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/cart_data.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/models/cart_item.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/screens/checkout_screen.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool isFromWishlist;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.isFromWishlist = false,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int currentImageIndex = 0;
  bool isWishlisted = false;
  late String selectedSize;
  late String selectedColor;
  int quantity = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    isWishlisted = WishlistData.contains(widget.product);
    selectedSize = widget.product.sizes.isNotEmpty ? widget.product.sizes.first : 'M';
    selectedColor = widget.product.colors.isNotEmpty ? widget.product.colors.first : '';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onColorSelected(String color) {
    if (selectedColor == color) return;
    setState(() {
      selectedColor = color;
      currentImageIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Color _getColorValue(String colorName) {
    final c = colorName.toLowerCase().trim();
    if (c.contains('black') || c.contains('charcoal')) return const Color(0xFF1E232A);
    if (c.contains('white') || c.contains('cream') || c.contains('ivory')) return const Color(0xFFF1F5F9);
    if (c.contains('light blue') || c.contains('ice')) return const Color(0xFF93C5FD);
    if (c.contains('dark blue') || c.contains('navy') || c.contains('indigo')) return const Color(0xFF1E3A8A);
    if (c.contains('blue') || c.contains('washed') || c.contains('vintage')) return const Color(0xFF3B82F6);
    if (c.contains('red') || c.contains('crimson') || c.contains('ruby')) return const Color(0xFFE11D48);
    if (c.contains('wine') || c.contains('maroon') || c.contains('burgundy')) return const Color(0xFF881337);
    if (c.contains('green') || c.contains('olive') || c.contains('sage') || c.contains('emerald') || c.contains('mint')) return const Color(0xFF059669);
    if (c.contains('pink') || c.contains('blush') || c.contains('coral') || c.contains('rose') || c.contains('peach')) return const Color(0xFFF43F5E);
    if (c.contains('yellow') || c.contains('mustard') || c.contains('gold') || c.contains('sunflower')) return const Color(0xFFF59E0B);
    if (c.contains('purple') || c.contains('lavender') || c.contains('lilac')) return const Color(0xFF8B5CF6);
    if (c.contains('brown') || c.contains('tan') || c.contains('caramel') || c.contains('mocha')) return const Color(0xFF92400E);
    if (c.contains('grey') || c.contains('silver') || c.contains('pewter')) return const Color(0xFF6B7280);
    if (c.contains('beige') || c.contains('nude') || c.contains('sand')) return const Color(0xFFD6C7B2);
    if (c.contains('teal') || c.contains('turquoise')) return const Color(0xFF0D9488);
    return AppColors.primary;
  }

  void _addToCart() {
    final existingIndex = CartData.items.indexWhere(
      (item) => item.product.name == widget.product.name && item.size == selectedSize,
    );

    if (existingIndex != -1) {
      CartData.items[existingIndex].quantity += quantity;
    } else {
      CartData.items.add(
        CartItem(
          product: widget.product,
          size: selectedSize,
          quantity: quantity,
        ),
      );
    }

    final variantParts = <String>[];
    if (selectedSize.isNotEmpty) variantParts.add(selectedSize);
    if (selectedColor.isNotEmpty) variantParts.add(selectedColor);
    final variantStr = variantParts.isNotEmpty ? ' (${variantParts.join(' • ')})' : '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Added "${widget.product.name}"$variantStr to bag!',
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VIEW BAG',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BottomCartScreen()),
            );
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _buyNow() {
    final item = CartItem(
      product: widget.product,
      size: selectedSize,
      quantity: quantity,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(buyNowItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.product.getImagesForColor(selectedColor);

    final discountPercent = (widget.product.oldPrice > widget.product.price && widget.product.oldPrice > 0)
        ? (((widget.product.oldPrice - widget.product.price) / widget.product.oldPrice) * 100).round()
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.dark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? AppColors.primary : AppColors.dark,
            ),
            onPressed: () {
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
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.dark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BottomCartScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGE CAROUSEL
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final imgPath = images[index];
                      return Container(
                        color: const Color(0xFFFBFBFC),
                        child: imgPath.startsWith('http')
                            ? Image.network(
                                imgPath,
                                width: double.infinity,
                                height: 380,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.blush,
                                  child: const Center(
                                    child: Icon(Icons.image_outlined, size: 64, color: AppColors.lightGrey),
                                  ),
                                ),
                              )
                            : Image.asset(
                                imgPath,
                                width: double.infinity,
                                height: 380,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.blush,
                                  child: const Center(
                                    child: Icon(Icons.image_outlined, size: 64, color: AppColors.lightGrey),
                                  ),
                                ),
                              ),
                      );
                    },
                  ),

                  // Brand/Category badge on photo
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.product.brand ?? 'StyleHub Exclusive',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  // Active Color pill indicator on top-right (only if variants exist)
                  if (widget.product.colors.length > 1 && selectedColor.isNotEmpty)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _getColorValue(selectedColor),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black26, width: 0.5),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedColor,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.dark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Dot Indicators
                  if (images.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            width: currentImageIndex == index ? 22 : 7,
                            height: 7,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: currentImageIndex == index
                                  ? AppColors.primary
                                  : Colors.grey.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // 2. PRODUCT DETAILS SECTION
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.dark,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F8A5F).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.product.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F8A5F),
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.star, size: 14, color: Color(0xFF0F8A5F)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Pricing & Discount
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${widget.product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      if (widget.product.oldPrice > widget.product.price) ...[
                        const SizedBox(width: 10),
                        Text(
                          '₹${widget.product.oldPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9E9E9E),
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      if (discountPercent > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFECEF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$discountPercent% OFF',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    'Inclusive of all taxes',
                    style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
                  ),

                  const Divider(height: 32, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 3. SIZE SELECTOR
                  const Text(
                    'Select Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: widget.product.sizes.map((size) {
                      final isSelected = selectedSize == size;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : const Color(0xFFDDDDDD),
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.25),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.dark,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // 4. COLOR SELECTOR (Only when item has multiple color variants)
                  if (widget.product.colors.length > 1) ...[
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Text(
                          'Select Color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.dark,
                          ),
                        ),
                        if (selectedColor.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            ': $selectedColor',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.product.colors.map((color) {
                        final isSelected = selectedColor == color;
                        final colorVal = _getColorValue(color);
                        return GestureDetector(
                          onTap: () => _onColorSelected(color),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : const Color(0xFFDDDDDD),
                                width: isSelected ? 2.0 : 1.2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: colorVal,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  color,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? AppColors.primary : AppColors.dark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const Divider(height: 32, thickness: 1, color: Color(0xFFEEEEEE)),

                  // 5. PRODUCT DESCRIPTION
                  const Text(
                    'Product Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description ??
                        'Elevate your daily fashion with this premium ${widget.product.name}. Crafted from high quality breathable fabrics tailored for optimal comfort, durability, and contemporary styling.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Trust Badges
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.softBackground,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTrustItem(Icons.local_shipping_outlined, 'Free Delivery'),
                        _buildTrustItem(Icons.sync_alt_outlined, '7 Days Return'),
                        _buildTrustItem(Icons.verified_user_outlined, '100% Genuine'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 90), // Spacing for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),

      // 6. BOTTOM ACTION BAR (Add to Bag & Buy Now)
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to Bag Button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _addToCart,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text(
                      'ADD TO BAG',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Buy Now Button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _buyNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text(
                      'BUY NOW',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
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

  Widget _buildTrustItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }
}