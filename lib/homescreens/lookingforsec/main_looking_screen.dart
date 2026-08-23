import 'package:flutter/material.dart';

import 'book_screen.dart';
import 'iron_screen.dart';

class LookingForSection extends StatefulWidget {
  const LookingForSection({super.key});

  @override
  State<LookingForSection> createState() => _LookingForSectionState();
}

class _LookingForSectionState extends State<LookingForSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 15),

      decoration: BoxDecoration(
        color: const Color(0xFFFFB36B),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // =====================================================
          // SECTION TITLE
          // =====================================================

          const Text(
            'Shrutika, still looking for these?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172B4D),
            ),
          ),

          const SizedBox(height: 16),

          // =====================================================
          // HORIZONTAL PRODUCT/CATEGORY CARDS
          // =====================================================

          SizedBox(
            height: 135,

            child: ListView(
              scrollDirection: Axis.horizontal,

              children: [

                // Card 1
                _LookingForCard(
                  image: 'assets/images/looking2.webp',
                  title: "Irons",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const IronScreen(),
                      ),
                    );
                  },
                ),

                // Card 2
                _LookingForCard(
                  image: 'assets/images/looking8.webp',
                  title: 'Bags',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),

                // Card 3
                _LookingForCard(
                  image: 'assets/images/looking7.webp',
                  title: 'Pendants',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 4
                _LookingForCard(
                  image: 'assets/images/looking5.webp',
                  title: 'Bags',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 5
                _LookingForCard(
                  image: 'assets/images/looking6.webp',
                  title: 'Toner',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 6
                _LookingForCard(
                  image: 'assets/images/looking7.webp',
                  title: 'Pendant',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 7
                _LookingForCard(
                  image: 'assets/images/looking8.webp',
                  title: 'Bag',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 8
                _LookingForCard(
                  image: 'assets/images/looking4.webp',
                  title: 'Books',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),
                // Card 9
                _LookingForCard(
                  image: 'assets/images/looking9.webp',
                  title: 'Tshirt',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BookScreen(),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}


// =============================================================
// LOOKING FOR CARD
// =============================================================

class _LookingForCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const _LookingForCard({
    required this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95,

        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),

              child: Image.asset(
                image,
                height: 90,
                width: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 3),

            // Title
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),

            // const SizedBox(height: 1),

            // View Store
            const Text(
              'View Store',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Color(0xFF172B4D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}