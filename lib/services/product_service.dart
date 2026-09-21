import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../data/mock_products.dart';
import 'api_config.dart';

class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  List<Product> _allProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get allProducts => _allProducts.isNotEmpty ? _allProducts : mockProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Initialize and fetch products
  Future<List<Product>> fetchAllProducts({bool forceRefresh = false}) async {
    if (_allProducts.isNotEmpty && !forceRefresh) {
      return _allProducts;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConfig.products}?size=100');
      final response = await http.get(url, headers: ApiConfig.headers()).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> items = [];

        if (decoded is Map<String, dynamic>) {
          if (decoded['data'] != null) {
            if (decoded['data'] is Map && decoded['data']['content'] != null) {
              items = decoded['data']['content'];
            } else if (decoded['data'] is List) {
              items = decoded['data'];
            }
          } else if (decoded['content'] != null) {
            items = decoded['content'];
          }
        } else if (decoded is List) {
          items = decoded;
        }

        if (items.isNotEmpty) {
          _allProducts = items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          // If backend returned empty list, fall back to mockProducts
          _allProducts = mockProducts;
        }
      } else {
        _allProducts = mockProducts;
      }
    } catch (e) {
      debugPrint('ProductService fetch error (using fallback): $e');
      _allProducts = mockProducts;
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _allProducts;
  }

  // Get products by category
  List<Product> getByCategory(String category) {
    if (category.toLowerCase() == 'all' || category.trim().isEmpty) {
      return allProducts;
    }
    return allProducts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
  }

  // Get Featured products
  List<Product> getFeaturedProducts() {
    final featured = allProducts.where((p) => p.featured).toList();
    if (featured.isNotEmpty) return featured;
    return allProducts.take(6).toList();
  }

  // Get Flash Sale products
  List<Product> getFlashSaleProducts() {
    final flash = allProducts.where((p) => p.flashSale).toList();
    if (flash.isNotEmpty) return flash;
    return allProducts.skip(2).take(6).toList();
  }

  // Get Recommended products
  List<Product> getRecommendedProducts() {
    return allProducts.skip(4).take(8).toList();
  }

  // Get Recently Viewed products
  List<Product> getRecentlyViewedProducts() {
    return allProducts.skip(1).take(6).toList();
  }
}
