class Product {
  final String? id;
  final String name;
  final String category;
  final List<String> images;
  final double price;
  final double oldPrice;
  final double rating;
  final String? description;
  final String? brand;
  final int stock;
  final bool featured;
  final bool flashSale;
  final List<String> sizes;
  final List<String> colors;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.images,
    required this.price,
    required this.oldPrice,
    required this.rating,
    this.description,
    this.brand = 'StyleHub',
    this.stock = 25,
    this.featured = false,
    this.flashSale = false,
    this.sizes = const ['S', 'M', 'L', 'XL'],
    this.colors = const ['Black', 'Beige', 'Navy Blue'],
  });

  String get image => images.isNotEmpty ? images.first : 'assets/images/dress6.webp';

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] != null && json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    if (imgList.isEmpty) {
      imgList = ['assets/images/dress6.webp'];
    }

    double parsedPrice = 0.0;
    if (json['price'] != null) {
      parsedPrice = (json['price'] as num).toDouble();
    }

    double parsedOldPrice = 0.0;
    if (json['discountPrice'] != null) {
      parsedOldPrice = (json['discountPrice'] as num).toDouble();
    } else if (json['oldPrice'] != null) {
      parsedOldPrice = (json['oldPrice'] as num).toDouble();
    } else {
      parsedOldPrice = (parsedPrice > 0) ? (parsedPrice * 1.35).roundToDouble() : 0.0;
    }

    double parsedRating = 4.5;
    if (json['avgRating'] != null) {
      parsedRating = (json['avgRating'] as num).toDouble();
    } else if (json['rating'] != null) {
      parsedRating = (json['rating'] as num).toDouble();
    }

    List<String> parsedSizes = ['S', 'M', 'L', 'XL'];
    if (json['sizes'] != null && json['sizes'] is List) {
      parsedSizes = (json['sizes'] as List).map((e) => e.toString()).toList();
    }

    List<String> parsedColors = ['Black', 'Beige', 'Navy Blue'];
    if (json['colors'] != null && json['colors'] is List) {
      parsedColors = (json['colors'] as List).map((e) => e.toString()).toList();
    }

    return Product(
      id: json['id']?.toString(),
      name: json['title'] ?? json['name'] ?? 'Product',
      category: json['categoryName'] ?? json['category'] ?? 'Fashion',
      images: imgList,
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      rating: parsedRating,
      description: json['description']?.toString() ?? 'Premium quality product designed for modern style and ultimate comfort.',
      brand: json['brand']?.toString() ?? 'StyleHub',
      stock: (json['stock'] != null) ? (json['stock'] as num).toInt() : 25,
      featured: json['featured'] == true,
      flashSale: json['flashSale'] == true,
      sizes: parsedSizes.isNotEmpty ? parsedSizes : ['S', 'M', 'L', 'XL'],
      colors: parsedColors.isNotEmpty ? parsedColors : ['Black', 'Beige', 'Navy Blue'],
    );
  }
}