import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/wishlist_data.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final isWishlisted = WishlistData.contains(widget.product);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: widget.product,
            ),
          ),
        ).then((_) {
          if (mounted) setState(() {});
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.product.image.startsWith('http')
                          ? Image.network(
                              widget.product.image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFFFF0F5),
                                child: const Icon(Icons.image_outlined, color: Colors.grey),
                              ),
                            )
                          : Image.asset(
                              widget.product.image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFFFF0F5),
                                child: const Icon(Icons.image_outlined, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),

                  // WISHLIST BUTTON
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (WishlistData.contains(widget.product)) {
                            WishlistData.remove(widget.product);
                          } else {
                            WishlistData.add(widget.product);
                          }
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 18,
                          color: isWishlisted ? AppColors.primary : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // PRODUCT NAME
            Text(
              widget.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.dark,
              ),
            ),

            const SizedBox(height: 4),

            // PRICE & DISCOUNT
            Row(
              children: [
                Text(
                  '₹${widget.product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                if (widget.product.oldPrice > widget.product.price) ...[
                  const SizedBox(width: 5),
                  Text(
                    '₹${widget.product.oldPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${(((widget.product.oldPrice - widget.product.price) / widget.product.oldPrice) * 100).round()}% off',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F8A5F),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 4),

            // RATING
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 13,
                  color: Color(0xFF0F8A5F),
                ),
                const SizedBox(width: 3),
                Text(
                  widget.product.rating.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F8A5F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}