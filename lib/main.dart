import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/screens/auth/login_screen.dart';
import 'package:new_expense/screens/home/main_bottom_nav.dart';
import 'package:new_expense/data/address_data.dart';
import 'package:new_expense/services/auth_service.dart';
import 'package:new_expense/services/product_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initSession();
  await AddressData.init();
  ProductService().fetchAllProducts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StyleHub',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.dark,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: AppColors.dark,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.softBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14),
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: AuthService.isLoggedIn
          ? const MainBottomNavigation()
          : const LoginScreen(),
    );
  }
}
