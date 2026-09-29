import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/models/product_model.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/home/bottom_cart_screen.dart';
import 'package:new_expense/widgets/product_card.dart';
import 'package:new_expense/widgets/product_search_delegate.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String _selectedSort = 'Popular';
  String _selectedPriceFilter = 'All';
  bool _onlyDiscounted = false;

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final sortOptions = [
          'Popular',
          'Price: Low to High',
          'Price: High to Low',
          'Customer Rating',
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'SORT BY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
                const Divider(),
                ...sortOptions.map((opt) {
                  final isSelected = _selectedSort == opt;
                  return ListTile(
                    title: Text(
                      opt,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.primary : AppColors.dark,
                        fontSize: 15,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedSort = opt;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filterOptions = [
              'All',
              'Under ₹1000',
              '₹1000 - ₹1500',
              '₹1500 - ₹2000',
              'Above ₹2000',
            ];

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FILTER PRODUCTS',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.grey,
                              letterSpacing: 1.1,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                _selectedPriceFilter = 'All';
                                _onlyDiscounted = false;
                              });
                              setState(() {});
                            },
                            child: const Text('Reset', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      child: Text(
                        'Price Range',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.dark),
                      ),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: filterOptions.map((opt) {
                        final isSelected = _selectedPriceFilter == opt;
                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ChoiceChip(
                            label: Text(opt),
                            selected: isSelected,
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.dark,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 12,
                            ),
                            onSelected: (selected) {
                              setModalState(() {
                                _selectedPriceFilter = opt;
                              });
                              setState(() {});
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Discounted Deals Only', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      value: _onlyDiscounted,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        setModalState(() {
                          _onlyDiscounted = val;
                        });
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawProducts = (widget.categoryName == 'Special Offers' || widget.categoryName == 'All' || widget.categoryName == 'Recently Viewed')
        ? ProductService().allProducts
        : (widget.categoryName == 'Recommended for you'
            ? ProductService().getRecommendedProducts()
            : ProductService().getByCategory(widget.categoryName));

    // Apply Price and Discount Filters
    List<Product> filtered = List.from(rawProducts);
    if (_onlyDiscounted) {
      filtered = filtered.where((p) => p.oldPrice > p.price).toList();
    }
    if (_selectedPriceFilter == 'Under ₹1000') {
      filtered = filtered.where((p) => p.price < 1000).toList();
    } else if (_selectedPriceFilter == '₹1000 - ₹1500') {
      filtered = filtered.where((p) => p.price >= 1000 && p.price <= 1500).toList();
    } else if (_selectedPriceFilter == '₹1500 - ₹2000') {
      filtered = filtered.where((p) => p.price >= 1500 && p.price <= 2000).toList();
    } else if (_selectedPriceFilter == 'Above ₹2000') {
      filtered = filtered.where((p) => p.price > 2000).toList();
    }

    // Apply Sorting
    if (_selectedSort == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedSort == 'Customer Rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.dark, size: 20),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: AppColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search, color: AppColors.dark),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BottomCartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.dark),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with count, sort, filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text(
                  '${filtered.length} Products',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                // Sort button
                OutlinedButton.icon(
                  onPressed: _showSortBottomSheet,
                  icon: const Icon(Icons.sort, size: 16),
                  label: Text(_selectedSort == 'Popular' ? 'Sort' : _selectedSort, style: const TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _selectedSort != 'Popular' ? AppColors.primary : AppColors.dark,
                    side: BorderSide(color: _selectedSort != 'Popular' ? AppColors.primary : AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button
                OutlinedButton.icon(
                  onPressed: _showFilterBottomSheet,
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: Text(
                    _selectedPriceFilter != 'All' || _onlyDiscounted ? 'Filtered' : 'Filter',
                    style: const TextStyle(fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: (_selectedPriceFilter != 'All' || _onlyDiscounted) ? AppColors.primary : AppColors.dark,
                    side: BorderSide(color: (_selectedPriceFilter != 'All' || _onlyDiscounted) ? AppColors.primary : AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Product Grid (Tight aspect ratio with zero dead whitespace)
          Expanded(
            child: (ProductService().isLoading && filtered.isEmpty)
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: ProductGridSkeleton(itemCount: 6),
                  )
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_alt_off_outlined, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'No products match your filters',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.dark),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPriceFilter = 'All';
                                  _onlyDiscounted = false;
                                  _selectedSort = 'Popular';
                                });
                              },
                              child: const Text('Reset Filters', style: TextStyle(color: AppColors.primary)),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        itemCount: filtered.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.64,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: filtered[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}