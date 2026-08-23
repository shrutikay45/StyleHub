import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();

}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Discover Your Style',
      'description':
      'Explore the latest trends and discover styles that express who you are.',
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Find What You Love',
      'description':
      'Browse our collection and find pieces that perfectly match your style.',
    },
    {
      'image': 'assets/images/onboarding.jpg',
      'title': 'Shop With Ease',
      'description':
      'Enjoy a simple, smooth and effortless shopping experience.',
    },
  ];

  // for next button
  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }else{
      _goToHome();
    }
  }
  // from get started to home screen
  void _goToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }
  // for skkip button
  void _skipOnboarding() {
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  right: 20,
                ),

                child: TextButton(
                  onPressed: _skipOnboarding,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.secondaryText,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });

                  },
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              item['image']!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 30),

                          Text(
                            item['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 15),

                          Text(
                            item['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppTheme.secondaryText,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),

                    );
                  },
              ),
            ),
            // indicator row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingData.length,
                    (index) {
                  final bool isActive = _currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.primary
                          : AppTheme.secondaryText,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                // child: ElevatedButton(
                //   onPressed: _nextPage,
                //   // child: const Text('Next'),
                //   // this will check if we are on page 3 then change text from "next" to "get started"
                //   child: Text(
                //     _currentPage == onboardingData.length - 1
                //         ? 'Get Started'
                //         : 'Next',
                //   ),
                // ),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage == onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),const SizedBox(height: 25),
          ],
        ),
      ),


    );
  }
}





















// import 'package:flutter/material.dart';
// import 'package:new_expense/homescreens/home_screen.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//
//   int _currentPage = 0;
//
//   final List<Map<String, String>> onboardingData = [
//     {
//       'image': 'assets/images/onboarding1.jpg',
//       'title': 'Discover Your Style',
//       'description':
//       'Explore the latest trends and discover styles that express who you are.',
//     },
//     {
//       'image': 'assets/images/onboarding2.jpg',
//       'title': 'Find What You Love',
//       'description':
//       'Browse our carefully selected collection and find pieces you truly love.',
//     },
//     {
//       'image': 'assets/images/onboarding.jpg',
//       'title': 'Shop With Ease',
//       'description':
//       'Enjoy a simple, smooth and effortless shopping experience.',
//     },
//   ];
//
//   void _nextPage() {
//     if (_currentPage < onboardingData.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _goToHome();
//     }
//   }
//
//   void _skipOnboarding() {
//     _goToHome();
//   }
//
//   void _goToHome() {
//     // We will connect this to the Home Screen later.
//     // debugPrint('Go to Home Screen');
//     Navigator.pushReplacement(context,
//       MaterialPageRoute(
//           builder:(context) => HomeScreen(), )
//     );
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFAF9F7),
//
//       body: SafeArea(
//         child: Column(
//           children: [
//
//             // Skip Button
//             Align(
//               alignment: Alignment.topRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(
//                   top: 16,
//                   right: 20,
//                 ),
//                 child: TextButton(
//                   onPressed: _skipOnboarding,
//                   child: const Text(
//                     'Skip',
//                     style: TextStyle(
//                       color: Color(0xFF777777),
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // Onboarding Pages
//             //This is what actually creates the swipeable pages.
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: onboardingData.length,
//
//                 onPageChanged: (index) {
//                   setState(() {
//                     _currentPage = index;
//                   });
//                 },
//
//                 itemBuilder: (context, index) {
//                   final item = onboardingData[index];
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                     ),
//
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//
//                         // Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.asset(
//                             item['image']!,
//                             height: 330,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//
//                         const SizedBox(height: 35),
//
//                         // Title
//                         Text(
//                           item['title']!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Color(0xFF111111),
//                             fontSize: 27,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         const SizedBox(height: 15),
//
//                         // Description
//                         Text(
//                           item['description']!,
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Color(0xFF777777),
//                             fontSize: 16,
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             // Page Indicators
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 onboardingData.length,
//                     (index) {
//                   final bool isActive = _currentPage == index;
//
//                   return AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//
//                     margin: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                     ),
//
//                     width: isActive ? 25 : 8,
//                     height: 8,
//
//                     decoration: BoxDecoration(
//                       color: isActive
//                           ? const Color(0xFF111111)
//                           : const Color(0xFFD6D6D6),
//
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // Next / Get Started Button
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24,
//               ),
//
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//
//                 child: ElevatedButton(
//                   onPressed: _nextPage,
//
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF111111),
//                     foregroundColor: Colors.white,
//
//                     elevation: 0,
//
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//
//                   child: Text(
//                     _currentPage == onboardingData.length - 1
//                         ? 'Get Started'
//                         : 'Next',
//
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }
// }