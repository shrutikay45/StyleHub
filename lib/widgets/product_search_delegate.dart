import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/widgets/product_card.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  ProductSearchDelegate()
      : super(
          searchFieldLabel: 'Search for products, brands and more...',
          searchFieldStyle: const TextStyle(
            color: AppColors.dark,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        );

  String _activeFilter = 'All';

  static const List<String> _popularTags = [
    'Jeans',
    'Dresses',
    'Oversized T-Shirt',
    'Sneakers',
    'Handbags',
    'Kurtis',
    'Sarees',
    'Tops',
  ];

  static const Map<String, String> _aliases = {
    'genes': 'jeans',
    'jens': 'jeans',
    'jean': 'jeans',
    'gen': 'jeans',
    'denim': 'jeans',
    'pants': 'jeans',
    'tshirt': 't-shirt',
    't shirt': 't-shirt',
    'tee': 't-shirt',
    'shrt': 't-shirt',
    'shue': 'shoes',
    'shues': 'shoes',
    'shoos': 'shoes',
    'sneaker': 'sneakers',
    'sneakers': 'shoes',
    'sandals': 'shoes',
    'heels': 'shoes',
    'sari': 'saree',
    'saari': 'saree',
    'sadi': 'saree',
    'kurta': 'kurti',
    'kurtis': 'kurti',
    'dres': 'dress',
    'dresses': 'dress',
    'frock': 'dress',
    'gown': 'dress',
    'onepiece': 'dress',
    'bag': 'bags',
    'purse': 'bag',
    'handbag': 'bag',
    'tote': 'bag',
    'topz': 'top',
    'tops': 'top',
    'jewel': 'jewellery',
    'jewelry': 'jewellery',
    'jewelery': 'jewellery',
    'jwellery': 'jewellery',
    'earring': 'jewellery',
    'necklace': 'jewellery',
  };

  int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost].reduce((a, b) => a < b ? a : b);
      }
      for (int j = 0; j <= t.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }

  bool _isFuzzyMatch(String queryTerm, String targetText) {
    final q = queryTerm.toLowerCase().trim();
    final t = targetText.toLowerCase().trim();

    if (t.contains(q)) return true;

    final words = t.split(RegExp(r'[\s\-_,]+'));
    for (final word in words) {
      if (word.isEmpty || word.length < 3) continue;
      if (word.contains(q)) return true;

      // Only allow 1 edit distance for 4-6 char words, 2 for >= 7 chars
      final maxAllowedDist = q.length <= 3 ? 0 : (q.length <= 6 ? 1 : 2);
      if (maxAllowedDist > 0 && (q.length - word.length).abs() <= maxAllowedDist) {
        if (_levenshtein(q, word) <= maxAllowedDist) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Color(0x1A000000),
        iconTheme: IconThemeData(color: AppColors.dark),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
          icon: const Icon(Icons.clear, color: AppColors.dark),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.dark),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildRichSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.trim().isEmpty) {
      return _buildTrendingAndRecentView(context);
    }
    return _buildRichSearchResults(context);
  }

  // TRENDING & POPULAR DISCOVERY VIEW (Flipkart Style)
  Widget _buildTrendingAndRecentView(BuildContext context) {
    final allProducts = ProductService().allProducts;
    final popularProducts = allProducts.take(8).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popular Searches Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.trending_up, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  'Popular Searches',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popularTags.map((tag) {
                return InkWell(
                  onTap: () {
                    query = tag;
                    showResults(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search, size: 14, color: Color(0xFF6B7280)),
                        const SizedBox(width: 6),
                        Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),
          const Divider(thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 12),

          // Trending Recommendations Grid
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Trending on StyleHub',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: popularProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: popularProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // RICH FLIPKART STYLE PRODUCT GRID & RELATED ITEMS
  Widget _buildRichSearchResults(BuildContext context) {
    final allProducts = ProductService().allProducts;
    final rawQuery = query.trim().toLowerCase();

    if (rawQuery.isEmpty) {
      return _buildTrendingAndRecentView(context);
    }

    // Typo normalization
    String normalizedQuery = rawQuery;
    for (final entry in _aliases.entries) {
      if (rawQuery == entry.key || rawQuery.contains(entry.key)) {
        normalizedQuery = entry.value;
        break;
      }
    }

    // 1. Direct & Root Keyword Match (High Precision)
    List<Product> directMatches = allProducts.where((p) {
      final name = p.name.toLowerCase();
      final cat = p.category.toLowerCase();
      final brand = (p.brand ?? '').toLowerCase();
      final combined = '$name $cat $brand';

      if (combined.contains(rawQuery) || combined.contains(normalizedQuery)) {
        return true;
      }

      // Root singular/plural check (e.g. "sarees" -> "saree", "dresses" -> "dress", "jeans" -> "jean")
      String singular = rawQuery;
      if (singular.endsWith('es') && singular.length > 4) {
        singular = singular.substring(0, singular.length - 2);
      } else if (singular.endsWith('s') && singular.length > 3) {
        singular = singular.substring(0, singular.length - 1);
      }

      if (singular.isNotEmpty && (cat.contains(singular) || name.contains(singular))) {
        return true;
      }

      final queryTokens = rawQuery.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      if (queryTokens.length > 1) {
        return queryTokens.every((token) => combined.contains(token));
      }

      return false;
    }).toList();

    List<Product> matchedProducts = directMatches;

    // 2. Fuzzy Typo Match (Fallback ONLY when no direct matches found)
    if (matchedProducts.isEmpty) {
      final queryTokens = rawQuery.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
      matchedProducts = allProducts.where((p) {
        final name = p.name.toLowerCase();
        final cat = p.category.toLowerCase();
        final brand = (p.brand ?? '').toLowerCase();
        final combined = '$name $cat $brand';

        return queryTokens.every((token) => _isFuzzyMatch(token, combined));
      }).toList();
    }

    // Related / Cross-sell products (items not in results but relevant)
    final relatedProducts = allProducts.where((p) {
      return !matchedProducts.contains(p);
    }).take(6).toList();

    final hasTypoCorrection = normalizedQuery != rawQuery && matchedProducts.isNotEmpty;

    if (matchedProducts.isEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 60, color: Color(0xFF9E9E9E)),
            const SizedBox(height: 12),
            Text(
              'No exact matches for "$query"',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Explore these popular styles instead:',
              style: TextStyle(fontSize: 13, color: Color(0xFF757575)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allProducts.take(6).length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: allProducts[index]);
                },
              ),
            ),
          ],
        ),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        // Apply in-search quick filters
        List<Product> displayedProducts = List.from(matchedProducts);
        if (_activeFilter == 'Under ₹1500') {
          displayedProducts = displayedProducts.where((p) => p.price <= 1500).toList();
        } else if (_activeFilter == 'Under ₹2000') {
          displayedProducts = displayedProducts.where((p) => p.price <= 2000).toList();
        } else if (_activeFilter == '4★ & Above') {
          displayedProducts = displayedProducts.where((p) => p.rating >= 4.0).toList();
        } else if (_activeFilter == 'Deals Only') {
          displayedProducts = displayedProducts.where((p) => p.oldPrice > p.price).toList();
        } else if (_activeFilter == 'Price: Low to High') {
          displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        } else if (_activeFilter == 'Price: High to Low') {
          displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Typo banner if auto-corrected
              if (hasTypoCorrection)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_fix_high, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Showing results for "$normalizedQuery"',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Filter Bar (Flipkart Style Horizontal Scroll)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${displayedProducts.length} items',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'All',
                            'Price: Low to High',
                            'Price: High to Low',
                            'Under ₹1500',
                            'Under ₹2000',
                            '4★ & Above',
                            'Deals Only',
                          ].map((filter) {
                            final isSelected = _activeFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _activeFilter = filter;
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.primary : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Text(
                                    filter,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? Colors.white : AppColors.dark,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),

              // Matched Products 2-Column Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.64,
                  ),
                  itemBuilder: (context, index) {
                    return ProductCard(product: displayedProducts[index]);
                  },
                ),
              ),

              // "You May Also Like" Related Products Section
              if (relatedProducts.isNotEmpty) ...[
                const SizedBox(height: 28),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'You May Also Like',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.dark,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: relatedProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: relatedProducts[index]);
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
