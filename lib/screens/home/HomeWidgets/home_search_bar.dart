import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),

            const Icon(
              Icons.search,
              color: Color(0xFF9B9B9B),
              size: 22,
            ),

            const SizedBox(width: 10),

            const Expanded(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Color(0xFF9B9B9B),
                  fontSize: 14,
                ),
              ),
            ),

            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.visibility_outlined,
                color: Color(0xFF9B9B9B),
                size: 21,
              ),
            ),
          ],
        ),
      ),
    );

  }
}