import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'api_config.dart';
import 'auth_service.dart';

class CartResult {
  final bool success;
  final String message;
  final dynamic data;

  CartResult({
    required this.success,
    required this.message,
    this.data,
  });
}

class CartService {
  static Future<CartResult> addToCart({
    required String productId,
    int quantity = 1,
    String? variantId,
  }) async {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      return CartResult(
        success: false,
        message: 'Please login to add products to cart.',
      );
    }

    if (productId.isEmpty) {
      return CartResult(
        success: false,
        message: 'Product information is missing.',
      );
    }

    if (quantity < 1) {
      return CartResult(
        success: false,
        message: 'Quantity must be at least 1.',
      );
    }

    try {
      final Map<String, dynamic> requestBody = {
        'productId': productId,
        'quantity': quantity,
      };

      if (variantId != null && variantId.isNotEmpty) {
        requestBody['variantId'] = variantId;
      }

      final response = await http
          .post(
        Uri.parse('${ApiConfig.cart}/items'),
        headers: ApiConfig.headers(token: token),
        body: jsonEncode(requestBody),
      )
          .timeout(
        const Duration(seconds: 20),
      );

      debugPrint('Add to cart status: ${response.statusCode}');
      debugPrint('Add to cart response: ${response.body}');

      Map<String, dynamic> responseBody = {};

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          responseBody = decoded;
        }
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return CartResult(
          success: responseBody['success'] == true ||
              responseBody.isEmpty,
          message: responseBody['message']?.toString() ??
              'Product added to cart successfully.',
          data: responseBody['data'],
        );
      }

      if (response.statusCode == 401) {
        return CartResult(
          success: false,
          message: 'Your session has expired. Please login again.',
        );
      }

      if (response.statusCode == 400) {
        return CartResult(
          success: false,
          message: responseBody['message']?.toString() ??
              'Unable to add product to cart.',
        );
      }

      return CartResult(
        success: false,
        message: responseBody['message']?.toString() ??
            'Something went wrong while adding the product.',
      );
    } catch (e) {
      debugPrint('Add to cart error: $e');

      return CartResult(
        success: false,
        message: 'Unable to connect to the server.',
      );
    }
  }

  static Future<CartResult> getCart() async {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      return CartResult(
        success: false,
        message: 'Please login to view your cart.',
      );
    }

    try {
      final response = await http
          .get(
        Uri.parse(ApiConfig.cart),
        headers: ApiConfig.headers(token: token),
      )
          .timeout(
        const Duration(seconds: 20),
      );

      debugPrint('Get cart status: ${response.statusCode}');
      debugPrint('Get cart response: ${response.body}');

      Map<String, dynamic> responseBody = {};

      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          responseBody = decoded;
        }
      }

      if (response.statusCode == 200) {
        return CartResult(
          success: responseBody['success'] == true,
          message: responseBody['message']?.toString() ??
              'Cart loaded successfully.',
          data: responseBody['data'],
        );
      }

      if (response.statusCode == 401) {
        return CartResult(
          success: false,
          message: 'Your session has expired. Please login again.',
        );
      }

      return CartResult(
        success: false,
        message: responseBody['message']?.toString() ??
            'Unable to load cart.',
      );
    } catch (e) {
      debugPrint('Get cart error: $e');

      return CartResult(
        success: false,
        message: 'Unable to connect to the server.',
      );
    }
  }
}