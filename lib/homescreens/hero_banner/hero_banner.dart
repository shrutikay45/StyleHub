import 'dart:async';

import 'package:flutter/material.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {

  // ============================================================
  // BANNER IMAGES
  // ============================================================

  final List<String> bannerImages = [
    'assets/images/hero.webp',
    'assets/images/hero2.webp',
    'assets/images/hero3.webp',
    'assets/images/hero4.webp',
    'assets/images/hero5.webp',
    'assets/images/hero6.webp',
    'assets/images/hero7.webp',
  ];

  // ============================================================
  // PAGE CONTROLLER
  // ============================================================

  final PageController _pageController = PageController();

  // Current banner
  int _currentPage = 0;

  // Timer for automatic sliding
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Automatically change banner every 4 seconds
    _timer = Timer.periodic(
      const Duration(seconds: 4),
          (timer) {
        if (_currentPage < bannerImages.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    // Stop timer
    _timer?.cancel();

    // Dispose controller
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // ========================================================
        // HERO BANNER
        // ========================================================

        SizedBox(
          height: 180,
          width: double.infinity,

          child: PageView.builder(
            controller: _pageController,

            itemCount: bannerImages.length,

            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },

            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(18),

                child: Image.asset(
                  bannerImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ========================================================
        // PAGE INDICATORS
        // ========================================================

        Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: List.generate(
            bannerImages.length,
                (index) {

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                margin: const EdgeInsets.symmetric(
                  horizontal: 3,
                ),

                width: _currentPage == index ? 20 : 6,
                height: 6,

                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.black
                      : Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}