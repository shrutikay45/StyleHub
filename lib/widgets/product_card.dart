import 'package:flutter/material.dart';
import 'package:new_expense/models/product_model.dart';
// import '../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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

                  child: Image.asset(
                    product.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // WISHLIST BUTTON
              Positioned(
                top: 8,
                right: 8,

                child: Container(
                  height: 32,
                  width: 32,

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // PRODUCT NAME
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 5),

        // PRICE
        Row(
          children: [

            Text(
              '₹${product.price.toStringAsFixed(0)}',

              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 6),

            Text(
              '₹${product.oldPrice.toStringAsFixed(0)}',

              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        // RATING
        Row(
          children: [

            const Icon(
              Icons.star,
              size: 14,
              color: Colors.amber,
            ),

            const SizedBox(width: 3),

            Text(
              product.rating.toString(),

              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}