import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/review_model.dart';
import 'api_config.dart';

class ReviewService {
  Future<List<Review>> fetchReviews(
      String productId, {
        int page = 0,
        int size = 10,
      }) async {
    final uri = Uri.parse(
      '${ApiConfig.products}/$productId/reviews'
          '?page=$page&size=$size',
    );

    final response = await http
        .get(
      uri,
      headers: ApiConfig.headers(),
    )
        .timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load reviews: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid reviews response');
    }

    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      return [];
    }

    final content = data['content'];

    if (content is! List) {
      return [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(Review.fromJson)
        .toList();
  }

  Future<Review> addReview({
    required String productId,
    required int rating,
    String? comment,
    required String token,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.products}/$productId/reviews',
    );

    final response = await http
        .post(
      uri,
      headers: ApiConfig.headers(token: token),
      body: jsonEncode({
        'rating': rating,
        'comment': comment,
      }),
    )
        .timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to add review: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid review response');
    }

    final data = decoded['data'];

    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid review data');
    }

    return Review.fromJson(data);
  }

  Future<void> markHelpful({
    required String reviewId,
  }) async {
    final uri = Uri.parse(
      '${ApiConfig.baseUrl}/api/reviews/$reviewId/helpful',
    );

    final response = await http
        .post(
      uri,
      headers: ApiConfig.headers(),
    )
        .timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark review helpful: ${response.statusCode}',
      );
    }
  }
}