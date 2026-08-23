// import 'package:e_com/homescreens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_expense/services/products_screen.dart';
// import 'package:new_expense/screens/home_screen.dart';
// import 'package:new_expense/screens/onboarding_screen.dart';
// import 'package:new_expense/screens/splash_screen.dart';
import 'package:new_expense/theme/app_theme.dart';

import 'homescreens/home_screen.dart';
import 'homescreens/onboarding_screen.dart';
import 'homescreens/splash_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // home: ProductsScreen(),
      // home: HomeScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        // we give a direct route here so that we can dirctly use their it in code
        '/home': (context) => const HomeScreen(),
      },

    );
  }
}
