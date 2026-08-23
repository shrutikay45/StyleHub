import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Function to check whether the user has already seen onboarding
  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding =
        prefs.getBool('hasSeenOnboarding') ?? false;

    if (!mounted) return;

    if (hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      _checkFirstLaunch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Theme background
      backgroundColor: AppTheme.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // Logo
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: AppTheme.beige,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 40,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              'STYLE-HUB',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: AppTheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Your style, your way',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}