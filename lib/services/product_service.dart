import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'api_config.dart';

class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;
  ProductService._internal();

  List<Product> _allProducts = [];
  bool _isLoading = false;
  bool _hasFetched = false;
  String? _errorMessage;

  List<Product> get allProducts => _allProducts;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;
  bool get isEmpty => _hasFetched && _allProducts.isEmpty;
  String? get errorMessage => _errorMessage;

  // Initialize and fetch products strictly from Backend API
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
        const Duration(seconds: 15),
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

        _allProducts = items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
        _hasFetched = true;
        debugPrint('ProductService: Loaded ${_allProducts.length} live products successfully.');
      } else {
        _errorMessage = 'Could not load products (${response.statusCode})';
        debugPrint('ProductService: API Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      debugPrint('ProductService fetch error: $e');
      _errorMessage = 'Network error: Please check internet connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return _allProducts;
  }

  // Get products by category from live data
  List<Product> getByCategory(String category) {
    if (category.toLowerCase() == 'all' || category.trim().isEmpty) {
      return _allProducts;
    }
    final target = category.toLowerCase().replaceAll('-', '').replaceAll(' ', '').trim();
    return _allProducts.where((p) {
      final cat = p.category.toLowerCase().replaceAll('-', '').replaceAll(' ', '').trim();
      return cat == target || cat.contains(target) || target.contains(cat);
    }).toList();
  }

  // Get Featured products from live data
  List<Product> getFeaturedProducts() {
    final featured = _allProducts.where((p) => p.featured).toList();
    if (featured.isNotEmpty) return featured;
    return _allProducts.take(8).toList();
  }

  // Get Flash Sale products from live data
  List<Product> getFlashSaleProducts() {
    final flash = _allProducts.where((p) => p.flashSale).toList();
    if (flash.isNotEmpty) return flash;
    return _allProducts.skip(2).take(8).toList();
  }

  // Get Recommended products from live data
  List<Product> getRecommendedProducts() {
    return _allProducts.skip(4).take(8).toList();
  }

  // Get Recently Viewed products from live data
  List<Product> getRecentlyViewedProducts() {
    return _allProducts.skip(1).take(6).toList();
  }
}

