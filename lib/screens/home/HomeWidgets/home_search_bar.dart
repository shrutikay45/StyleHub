import 'package:flutter/material.dart';
import 'package:new_expense/widgets/product_search_delegate.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          showSearch(
            context: context,
            delegate: ProductSearchDelegate(),
          );
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 14),
              Icon(
                Icons.search,
                color: Color(0xFF9B9B9B),
                size: 22,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Search dresses, jeans, shoes, bags...',
                  style: TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }
}