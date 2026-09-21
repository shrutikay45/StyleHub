import 'dart:async';
import 'package:flutter/material.dart';
import 'package:new_expense/services/product_service.dart';
import 'package:new_expense/screens/fashsaleviewscreen/sale_products_viewall_screen.dart';
import 'package:new_expense/screens/home/CategoryProductsPage/product_detail_screen.dart';
import 'package:new_expense/widgets/shimmer_loading.dart';

class FlashSale extends StatefulWidget {
  const FlashSale({super.key});

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void _initTimer() {
    // Calculates remaining time until next scheduled sale mark (e.g. 6-hour cycle)
    final now = DateTime.now();
    final nextCycleHour = ((now.hour ~/ 6) + 1) * 6;
    final endOfCycle = DateTime(now.year, now.month, now.day, nextCycleHour % 24);
    final target = nextCycleHour >= 24
        ? endOfCycle.add(const Duration(days: 1))
        : endOfCycle;
    _remainingTime = target.difference(now);
    if (_remainingTime.isNegative || _remainingTime.inSeconds == 0) {
      _remainingTime = const Duration(hours: 5, minutes: 45, seconds: 20);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _remainingTime = const Duration(hours: 6);
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // helper for flash sale time box
  Widget _saleTimeBox(String time) {
    return Container(
      width: 32,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD81B60),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ProductService();
    final flashProducts = service.getFlashSaleProducts();
    final isLoading = service.isLoading && flashProducts.isEmpty;

    final hours = _remainingTime.inHours.toString().padLeft(2, '0');
    final minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFFCE4EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------------------
          // HEADER
          // ---------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    '🔥',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD81B60),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlashSaleProductsScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD81B60),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ---------------------------
          // LIVE TICKING TIMER
          // ---------------------------
          Row(
            children: [
              const Text(
                'Ends in',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
              ),
              const SizedBox(width: 8),
              _saleTimeBox(hours),
              const SizedBox(width: 4),
              const Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD81B60))),
              const SizedBox(width: 4),
              _saleTimeBox(minutes),
              const SizedBox(width: 4),
              const Text(':', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD81B60))),
              const SizedBox(width: 4),
              _saleTimeBox(seconds),
            ],
          ),

          const SizedBox(height: 18),

          // ---------------------------
          // PRODUCTS OR SHIMMER SKELETON
          // ---------------------------
          SizedBox(
            height: 205,
            child: isLoading
                ? ShimmerEffect(
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, __) => const FlashSaleCardSkeleton(),
                    ),
                  )
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: flashProducts.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 12);
                    },
                    itemBuilder: (context, index) {
                      final product = flashProducts[index];

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
                          width: 125,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // PRODUCT IMAGE
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Container(
                                      width: 125,
                                      height: 135,
                                      color: Colors.white,
                                      child: product.image.startsWith('http')
                                          ? Image.network(
                                              product.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: const Color(0xFFFCE4EC),
                                                child: const Icon(Icons.image_outlined, color: Colors.grey),
                                              ),
                                            )
                                          : Image.asset(
                                              product.image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                color: const Color(0xFFFCE4EC),
                                                child: const Icon(Icons.image_outlined, color: Colors.grey),
                                              ),
                                            ),
                                    ),
                                  ),
                                  // DISCOUNT BADGE
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD81B60),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'SALE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // PRODUCT NAME
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF222222),
                                ),
                              ),
                              const SizedBox(height: 3),
                              // PRICE
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF222222),
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
}



