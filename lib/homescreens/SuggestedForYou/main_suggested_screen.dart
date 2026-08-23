import 'package:flutter/material.dart';
import 'package:new_expense/homescreens/SuggestedForYou/sug_product_desc_screen.dart';

class SuggestedForYouSection extends StatelessWidget {
  const SuggestedForYouSection({super.key});

  // ============================================================
  // PRODUCT IMAGES
  // ============================================================

  final List<String> productImages = const [
    'assets/images/suggested1.webp',
    'assets/images/suggested2.webp',
    'assets/images/suggested3.webp',
    'assets/images/suggested4.webp',
    'assets/images/suggested5.webp',
    'assets/images/suggested6.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ======================================================
        // SUGGESTED FOR YOU HEADING
        // ======================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              'Suggested For You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),

            // Arrow button
            GestureDetector(
              onTap: () {
                // Full Suggested Products screen
                // will be opened here later.
              },
              child: Container(
                width: 42,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFF172B4D),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 13),

        // ======================================================
        // PRODUCT GRID
        // ======================================================

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: productImages.length,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
            childAspectRatio: 0.55,
          ),

          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsScreen(
                      image: productImages[index],
                      name: 'Women Loose Fit Pants',
                      oldPrice: '₹999',
                      price: '₹322',
                    ),
                  ),
                );
              },

              child: _ProductCard(
                image: productImages[index],
                name: 'Women Loose Fit Pants',
                oldPrice: '₹999',
                price: '₹322',
              ),
            );
          },
        ),
      ],
    );
  }
}


// ===============================================================
// PRODUCT CARD
// ===============================================================

class _ProductCard extends StatelessWidget {

  final String image;
  final String name;
  final String oldPrice;
  final String price;

  const _ProductCard({
    required this.image,
    required this.name,
    required this.oldPrice,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ======================================================
        // PRODUCT IMAGE
        // ======================================================

        ClipRRect(
          borderRadius: BorderRadius.circular(12),

          child: Image.asset(
            image,
            width: double.infinity,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(height: 6),

        // ======================================================
        // PRODUCT NAME
        // ======================================================

        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172B4D),
          ),
        ),

        const SizedBox(height: 4),

        // ======================================================
        // PRICE
        // ======================================================

        Row(
          children: [

            // Old price
            Text(
              oldPrice,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),

            const SizedBox(width: 5),

            // Current price
            Text(
              price,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
              ),
            ),
          ],
        ),
      ],
    );
  }
}