import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/models/product_variant_model.dart';
import 'package:new_expense/models/review_model.dart';
import 'package:new_expense/screens/home/cart_screen.dart';
import 'package:new_expense/services/auth_service.dart';
import 'package:new_expense/services/cart_service.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/services/review_service.dart';

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
  int selectedQuantity = 1;
  bool isItemInCart = false;
  bool isDescriptionExpanded = false;

  String? selectedColor;
  String? selectedSize;
  ProductVariant? selectedVariant;


  final ReviewService _reviewService = ReviewService();

  List<Review> reviews = [];
  bool isReviewsLoading = true;
  String? reviewsError;




  // add to cart method
  void _addToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }


  @override
  void initState() {
    super.initState();

    isWishlisted = WishlistData.contains(widget.product);
    _loadReviews();

  }

  Future<void> _loadReviews() async {
    final productId = widget.product.id;

    if (productId == null || productId.isEmpty) {
      setState(() {
        isReviewsLoading = false;
        reviewsError = 'Product ID is unavailable.';
      });
      return;
    }

    try {
      final fetchedReviews = await _reviewService.fetchReviews(
        productId,
      );

      if (!mounted) return;

      setState(() {
        reviews = fetchedReviews;
        isReviewsLoading = false;
        reviewsError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        reviews = [];
        isReviewsLoading = false;
        reviewsError = 'Unable to load reviews.';
      });

      debugPrint('Review loading error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // appbar
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.dark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.softBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: const TextStyle(
                color: AppColors.lightGrey,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.grey,
                size: 21,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: AppColors.dark,
            ),
            onPressed: () {
              // Cart navigation will be connected here.
            },
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductGallery(),
              _buildProductSummary(),
              _buildVariantSelection(),
              _buildDescription(),
              _buildSpecifications(),
              _buildShippingInformation(),
              _buildProductBenefits(),
              _buildRelatedProducts(),
              _buildReviews(),
              _buildFaq(),
              _buildQuantityAndActions(),


            ],
          ),
        ),
      ),
    );
  }






  // helper for Product Gallery + Thumbnail Navigation.

  Widget _buildProductGallery() {
    final product = widget.product;

    // Product-level images
    List<String> galleryImages = List<String>.from(product.images);

    // If product images are empty, use selected variant images.
    if (galleryImages.isEmpty &&
        selectedVariant != null &&
        selectedVariant!.images.isNotEmpty) {
      galleryImages = List<String>.from(selectedVariant!.images);
    }

    // Keep the image index valid if the available image list changes.
    if (currentImageIndex >= galleryImages.length) {
      currentImageIndex = 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 420,
              width: double.infinity,
              color: AppColors.softBackground,
              child: galleryImages.isEmpty
                  ? const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 60,
                  color: AppColors.lightGrey,
                ),
              )
                  : Image.network(
                galleryImages[currentImageIndex],
                width: double.infinity,
                height: 420,
                fit: BoxFit.contain,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 60,
                      color: AppColors.lightGrey,
                    ),
                  );
                },
                loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                    ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                },
              ),
            ),

            // Wishlist button
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark.withValues(
                        alpha: 0.08,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isWishlisted = !isWishlisted;
                    });
                  },
                  icon: Icon(
                    isWishlisted
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: isWishlisted
                        ? AppColors.primary
                        : AppColors.dark,
                  ),
                ),
              ),
            ),
          ],
        ),

        // Thumbnails
        if (galleryImages.length > 1) ...[
          const SizedBox(height: 12),

          SizedBox(
            height: 76,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: galleryImages.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                final isSelected =
                    currentImageIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentImageIndex = index;
                    });
                  },
                  child: Container(
                    width: 68,
                    height: 68,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.lightGrey,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }


// helper for Product Summary
  Widget _buildProductSummary() {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.brand != null && product.brand!.trim().isNotEmpty)
            Text(
              product.brand!,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 6),

          Text(
            product.name,
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.rating,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.background,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.star,
                      color: AppColors.background,
                      size: 13,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Text(
                '${product.reviewCount} Reviews',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₹${product.discountPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 10),

              if (product.price > product.discountPrice)
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.lightGrey,
                    fontSize: 15,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

              const SizedBox(width: 8),

              if (product.discountPercentage > 0)
                Text(
                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                  style: const TextStyle(
                    color: AppColors.sale,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          const Text(
            'Inclusive of all taxes',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

// helper for variant section
  Widget _buildVariantSelection() {
    final variants = widget.product.variants;

    if (variants.isEmpty) {
      return const SizedBox.shrink();
    }

    final colors = variants
        .map((variant) => variant.color?.trim())
        .whereType<String>()
        .where((color) => color.isNotEmpty)
        .toSet()
        .toList();

    final availableSizes = variants
        .where((variant) {
      if (selectedColor == null) {
        return true;
      }

      return variant.color?.trim().toLowerCase() ==
          selectedColor!.trim().toLowerCase();
    })
        .map((variant) => variant.size?.trim())
        .whereType<String>()
        .where((size) => size.isNotEmpty)
        .toSet()
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (colors.isNotEmpty) ...[
            const Text(
              'COLOUR',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Available Colours',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  final color = colors[index];

                  final variant = variants.firstWhere(
                        (item) =>
                    item.color?.trim().toLowerCase() ==
                        color.toLowerCase(),
                  );

                  final isSelected = selectedColor?.toLowerCase() ==
                      color.toLowerCase();

                  final hasImage = variant.images.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;

                        selectedSize = null;
                        selectedVariant = null;
                        selectedQuantity = 1;
                      });
                    },
                    child: Container(
                      width: 68,
                      height: 68,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: hasImage
                            ? Image.network(
                          variant.images.first,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                color,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        )
                            : Center(
                          child: Text(
                            color,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.dark,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],

          if (availableSizes.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SELECT SIZE',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Size chart will be connected later.
                  },
                  child: const Text(
                    'Size Chart →',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: availableSizes.map((size) {
                final isSelected = selectedSize?.toLowerCase() ==
                    size.toLowerCase();

                return GestureDetector(
                  onTap: () {
                    final matchingVariants = variants.where(
                          (variant) {
                        final colorMatches = selectedColor == null ||
                            variant.color?.trim().toLowerCase() ==
                                selectedColor!.trim().toLowerCase();

                        final sizeMatches =
                            variant.size?.trim().toLowerCase() ==
                                size.toLowerCase();

                        return colorMatches && sizeMatches;
                      },
                    );

                    if (matchingVariants.isEmpty) {
                      return;
                    }

                    final variant = matchingVariants.first;

                    setState(() {
                      selectedSize = size;
                      selectedVariant = variant;
                      selectedQuantity = 1;
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryLight
                          : AppColors.background,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      size,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 12),

            if (selectedVariant != null)
              Text(
                selectedVariant!.stock > 0
                    ? '${selectedVariant!.stock} items available'
                    : 'Out of stock',
                style: TextStyle(
                  color: selectedVariant!.stock > 0
                      ? AppColors.grey
                      : AppColors.sale,
                  fontSize: 12,
                  fontWeight: selectedVariant!.stock > 0
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),

            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }


  // helper for description
  Widget _buildDescription() {
    final description = widget.product.description?.trim();

    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DESCRIPTION',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              description,
              maxLines: isDescriptionExpanded ? null : 3,
              overflow: isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                height: 1.6,
              ),
            ),

            if (description.length > 150) ...[
              const SizedBox(height: 6),

              GestureDetector(
                onTap: () {
                  setState(() {
                    isDescriptionExpanded = !isDescriptionExpanded;
                  });
                },
                child: Text(
                  isDescriptionExpanded
                      ? 'Show Less'
                      : 'Read More →',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // helper for specification
  Widget _buildSpecifications() {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'PRODUCT SPECIFICATIONS',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            _buildSpecificationRow(
              'Brand',
              product.brand?.trim().isNotEmpty == true
                  ? product.brand!
                  : 'Not available',
            ),

            _buildSpecificationRow(
              'Category',
              product.category,
            ),

            _buildSpecificationRow(
              'Stock',
              product.stock > 0
                  ? '${product.stock} items'
                  : 'Out of stock',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecificationRow(
      String label,
      String value, {
        bool isLast = false,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
          top: BorderSide(
            color: AppColors.border,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // helper for shipping
  Widget _buildShippingInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SHIPPING INFORMATION',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery in 3–5 business days',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Delivery availability will be confirmed for your location.',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(
                  Icons.verified_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Secure packaging',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(
                  Icons.assignment_return_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Easy returns',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // helper for  cart n buy now
  Widget _buildQuantityAndActions() {
    final product = widget.product;
    final bool isOutOfStock = product.stock <= 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUANTITY',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: selectedQuantity > 1
                          ? () {
                        setState(() {
                          selectedQuantity--;
                        });
                      }
                          : null,
                      icon: const Icon(
                        Icons.remove,
                        size: 18,
                      ),
                      color: AppColors.dark,
                    ),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$selectedQuantity',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: selectedQuantity < product.stock
                          ? () {
                        setState(() {
                          selectedQuantity++;
                        });
                      }
                          : null,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                      ),
                      color: AppColors.dark,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isOutOfStock
                    ? 'Out of stock'
                    : '${product.stock} items available',
                style: TextStyle(
                  color: isOutOfStock
                      ? AppColors.sale
                      : AppColors.grey,
                  fontSize: 12,
                  fontWeight: isOutOfStock
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: isOutOfStock
                        ? null
                        :  _addToCart,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(
                        color: isOutOfStock
                            ? AppColors.border
                            : AppColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ADD TO CART',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isOutOfStock
                        ? null
                        : () {
                      // Buy Now flow will be connected later.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'BUY NOW',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // helper for benefits
  Widget _buildProductBenefits() {
    final benefits = [
      {
        'icon': Icons.assignment_return_outlined,
        'title': 'Easy Returns',
        'subtitle': 'Hassle-free returns',
      },
      {
        'icon': Icons.local_shipping_outlined,
        'title': 'Fast Delivery',
        'subtitle': 'Delivered in 3–5 days',
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Secure Packaging',
        'subtitle': 'Safe & protected',
      },
      {
        'icon': Icons.payments_outlined,
        'title': 'Cash on Delivery',
        'subtitle': 'Pay when delivered',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRODUCT BENEFITS',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: benefits.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemBuilder: (context, index) {
                final benefit = benefits[index];

                return GestureDetector(
                  onTap: () {
                    _showBenefitDetails(
                      benefit['title'] as String,
                      benefit['subtitle'] as String,
                      benefit['icon'] as IconData,
                    );
                  },
                  child: Container(
                    width: 145,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      border: Border.all(
                        color: AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          benefit['icon'] as IconData,
                          color: AppColors.primary,
                          size: 24,
                        ),

                        const SizedBox(height: 10),

                        Text(
                          benefit['title'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          benefit['subtitle'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 11,
                            height: 1.3,
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

  void _showBenefitDetails(
      String title,
      String subtitle,
      IconData icon,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 36,
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'GOT IT',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  // related product section
  Widget _buildRelatedProducts() {
    final productService = ProductService();

    final currentProductId = widget.product.id;

    final sameCategoryProducts = productService.allProducts
        .where(
          (product) =>
      product.id != currentProductId &&
          product.category.toLowerCase() ==
              widget.product.category.toLowerCase(),
    )
        .toList();

    final otherProducts = productService.allProducts
        .where(
          (product) =>
      product.id != currentProductId &&
          product.category.toLowerCase() !=
              widget.product.category.toLowerCase(),
    )
        .toList();

    final relatedProducts = [
      ...sameCategoryProducts,
      ...otherProducts,
    ].take(8).toList();

    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SIMILAR PRODUCTS',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // See All will be connected later.
                  },
                  child: const Text(
                    'See All →',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 285,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: relatedProducts.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 12);
              },
              itemBuilder: (context, index) {
                final product = relatedProducts[index];

                return _buildRelatedProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRelatedProductCard(Product product) {
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
        width: 165,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 205,
              width: 165,
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: product.images.isNotEmpty
                    ? Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 40,
                        color: AppColors.lightGrey,
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: AppColors.lightGrey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 5),

            Row(
              children: [
                Text(
                  '₹${product.discountPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (product.price > product.discountPrice) ...[
                  const SizedBox(width: 6),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.lightGrey,
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.rating,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  // review
  Widget _buildReviews() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RATINGS & REVIEWS',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildReviewSummary(),
            const SizedBox(height: 20),
            const Divider(
              color: AppColors.border,
              height: 1,
            ),
            const SizedBox(height: 16),
            _buildReviewContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewContent() {
    if (isReviewsLoading) {
      return const SizedBox.shrink();
    }

    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${reviews.length} ${reviews.length == 1 ? 'Customer Review' : 'Customer Reviews'}',
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...reviews.map(_buildReviewCard),
      ],
    );
  }


  // rating
  Widget _buildReviewSummary() {
    if (isReviewsLoading) {
      return const SizedBox(
        height: 70,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    if (reviews.isEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_border,
            color: AppColors.rating,
            size: 42,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No ratings yet',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reviewsError ?? 'Be the first to review this product.',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final double averageRating = reviews.fold<double>(
      0,
          (sum, review) => sum + review.rating,
    ) /
        reviews.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                color: AppColors.dark,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            _buildStars(averageRating),
            const SizedBox(height: 4),
            Text(
              '${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'}',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildRatingDistribution(),
        ),
      ],
    );
  }

  //star
  Widget _buildStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        return Icon(
          starValue <= rating
              ? Icons.star
              : Icons.star_border,
          color: AppColors.rating,
          size: 16,
        );
      }),
    );
  }

  //rating distribution
  Widget _buildRatingDistribution() {
    final totalReviews = reviews.length;

    return Column(
      children: List.generate(5, (index) {
        final rating = 5 - index;

        final count = reviews
            .where((review) => review.rating == rating)
            .length;

        final percentage = totalReviews == 0
            ? 0.0
            : count / totalReviews;

        return Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              SizedBox(
                width: 12,
                child: Text(
                  '$rating',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.star,
                color: AppColors.rating,
                size: 12,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage,
                    minHeight: 6,
                    backgroundColor: AppColors.primaryLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 18,
                child: Text(
                  '$count',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  //individual review card
  Widget _buildReviewCard(Review review) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.softBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        _buildStars(review.rating.toDouble()),
                        const SizedBox(width: 6),
                        if (review.createdAt != null)
                          Text(
                            _formatReviewDate(review.createdAt!),
                            style: const TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.comment != null &&
              review.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              review.comment!,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  _markReviewHelpful(review);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(
                  Icons.thumb_up_outlined,
                  size: 15,
                  color: AppColors.grey,
                ),
                label: Text(
                  'Helpful (${review.helpfulCount})',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatReviewDate(DateTime date) {
    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  Future<void> _markReviewHelpful(Review review) async {
    final reviewId = review.id;

    if (reviewId == null || reviewId.isEmpty) {
      return;
    }

    try {
      await _reviewService.markHelpful(
        reviewId: reviewId,
      );

      await _loadReviews();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Marked as helpful'),
        ),
      );
    } catch (e) {
      debugPrint('Mark helpful error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to mark review as helpful'),
        ),
      );
    }
  }


  // FAQ
  Widget _buildFaq() {
    final faqs = [
      {
        'question': 'What is the return policy?',
        'answer':
        'Products can be returned within 7 days of delivery, subject to the return conditions.',
      },
      {
        'question': 'How long does delivery take?',
        'answer':
        'Orders are generally delivered within 3–5 business days.',
      },
      {
        'question': 'Is Cash on Delivery available?',
        'answer':
        'Cash on Delivery is available for eligible locations.',
      },
      {
        'question': 'How can I track my order?',
        'answer':
        'You can track your order from the Orders section after your order has been shipped.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'FAQ',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...faqs.map(
                  (faq) {
                return ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    16,
                  ),
                  shape: const Border(
                    top: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  collapsedShape: const Border(
                    top: BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  title: Text(
                    faq['question']!,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.grey,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq['answer']!,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }



}