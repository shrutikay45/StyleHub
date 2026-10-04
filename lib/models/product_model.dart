import 'product_variant_model.dart';

class Product {
  final String? id;
  final String name;
  final String category;
  final List<String> images;
  final double price;
  final double discountPrice;
  final double rating;
  final int reviewCount;
  final String? description;
  final String? brand;
  final int stock;
  final bool featured;
  final bool flashSale;
  final List<ProductVariant> variants;

  const Product({
    this.id,
    required this.name,
    required this.category,
    required this.images,
    required this.price,
    double? discountPrice,
    double? oldPrice,
    required this.rating,
    this.reviewCount = 0,
    this.description,
    this.brand = 'StyleHub',
    this.stock = 0,
    this.featured = false,
    this.flashSale = false,
    this.variants = const [],
  }) : discountPrice = discountPrice ?? oldPrice ?? price;

  String get image {
    if (images.isNotEmpty) {
      return images.first;
    }

    return 'assets/images/dress6.webp';
  }

  double get oldPrice => price;

  double get discountPercentage {
    if (price <= 0 || discountPrice <= 0 || discountPrice >= price) {
      return 0;
    }

    return ((price - discountPrice) / price) * 100;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<String> parsedImages = [];

    if (json['images'] is List) {
      parsedImages.addAll(
        (json['images'] as List)
            .map((image) => image.toString())
            .where((image) => image.trim().isNotEmpty),
      );
    }

    final List<ProductVariant> parsedVariants = [];

    if (json['variants'] is List) {
      parsedVariants.addAll(
        (json['variants'] as List)
            .whereType<Map<String, dynamic>>()
            .map(ProductVariant.fromJson),
      );
    }

    final double parsedPrice = json['price'] != null
        ? (json['price'] as num).toDouble()
        : 0.0;

    final double parsedDiscountPrice = json['discountPrice'] != null
        ? (json['discountPrice'] as num).toDouble()
        : parsedPrice;

    final double parsedRating = json['avgRating'] != null
        ? (json['avgRating'] as num).toDouble()
        : json['rating'] != null
        ? (json['rating'] as num).toDouble()
        : 0.0;

    final int parsedReviewCount = json['reviewCount'] != null
        ? (json['reviewCount'] as num).toInt()
        : 0;

    final int parsedStock = json['stock'] != null
        ? (json['stock'] as num).toInt()
        : 0;

    return Product(
      id: json['id']?.toString(),
      name: json['title']?.toString() ??
          json['name']?.toString() ??
          'Product',
      category: json['categoryName']?.toString() ??
          json['category']?.toString() ??
          'Fashion',
      images: parsedImages,
      price: parsedPrice,
      discountPrice: parsedDiscountPrice,
      rating: parsedRating,
      reviewCount: parsedReviewCount,
      description: json['description']?.toString(),
      brand: json['brand']?.toString(),
      stock: parsedStock,
      featured: json['featured'] == true,
      flashSale: json['flashSale'] == true,
      variants: parsedVariants,
    );
  }
}