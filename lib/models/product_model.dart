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
  final Map<String, List<String>> colorImages;

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
    this.colors = const [],
    this.colorImages = const {},
  });

  String get image => images.isNotEmpty ? images.first : 'assets/images/dress6.webp';

  List<String> getImagesForColor(String? color) {
    if (color != null && colorImages.isNotEmpty) {
      if (colorImages.containsKey(color) && colorImages[color]!.isNotEmpty) {
        return colorImages[color]!;
      }
      for (final entry in colorImages.entries) {
        if (entry.key.toLowerCase().trim() == color.toLowerCase().trim() && entry.value.isNotEmpty) {
          return entry.value;
        }
      }
    }
    return images;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String> imgList = [];
    if (json['images'] != null && json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (json['image'] != null && json['image'].toString().trim().isNotEmpty) {
      imgList = [json['image'].toString().trim()];
    }

    double p1 = 0.0;
    if (json['price'] != null) {
      p1 = (json['price'] as num).toDouble();
    }

    double p2 = 0.0;
    if (json['discountPrice'] != null) {
      p2 = (json['discountPrice'] as num).toDouble();
    } else if (json['oldPrice'] != null) {
      p2 = (json['oldPrice'] as num).toDouble();
    }

    double parsedPrice = 0.0;
    double parsedOldPrice = 0.0;

    if (p1 > 0 && p2 > 0 && p1 != p2) {
      // Selling price is always the lower discounted/offer price
      parsedPrice = p1 < p2 ? p1 : p2;
      // MRP / Old price is always the higher original price
      parsedOldPrice = p1 > p2 ? p1 : p2;
    } else if (p1 > 0) {
      parsedPrice = p1;
      parsedOldPrice = (p1 * 1.35).roundToDouble();
    } else if (p2 > 0) {
      parsedPrice = p2;
      parsedOldPrice = (p2 * 1.35).roundToDouble();
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

    List<String> parsedColors = [];
    if (json['colors'] != null && json['colors'] is List) {
      parsedColors = (json['colors'] as List)
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    String cleanDescription = json['description']?.toString() ?? 'Premium quality product designed for modern style and ultimate comfort.';
    if (parsedColors.isEmpty && cleanDescription.contains('Colors:')) {
      final match = RegExp(r'Colors:\s*([^\n\r<]+)').firstMatch(cleanDescription);
      if (match != null) {
        parsedColors = match.group(1)!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        cleanDescription = cleanDescription.replaceAll(RegExp(r'\s*Colors:\s*[^\n\r<]+'), '').trim();
      }
    }

    // Parse Color to Images mapping if provided by backend
    Map<String, List<String>> parsedColorImages = {};
    if (json['colorImages'] != null && json['colorImages'] is Map) {
      (json['colorImages'] as Map).forEach((k, v) {
        if (v is List) {
          final list = v.map((e) => e.toString().trim()).where((e) => e.isNotEmpty).toList();
          if (list.isNotEmpty) {
            parsedColorImages[k.toString()] = list;
          }
        }
      });
    }

    // Dynamically assign each color variant to its corresponding gallery image from backend
    if (parsedColorImages.isEmpty && parsedColors.length > 1 && imgList.length >= parsedColors.length) {
      for (int i = 0; i < parsedColors.length; i++) {
        parsedColorImages[parsedColors[i]] = [imgList[i]];
      }
    }

    // If colorImages exist from backend, prioritize those keys as available colors
    if (parsedColors.isEmpty && parsedColorImages.isNotEmpty) {
      parsedColors = parsedColorImages.keys.toList();
    }

    return Product(
      id: json['id']?.toString(),
      name: json['title'] ?? json['name'] ?? 'Product',
      category: json['categoryName'] ?? json['category'] ?? 'Fashion',
      images: imgList,
      price: parsedPrice,
      oldPrice: parsedOldPrice,
      rating: parsedRating,
      description: cleanDescription,
      brand: json['brand']?.toString() ?? 'StyleHub',
      stock: (json['stock'] != null) ? (json['stock'] as num).toInt() : 25,
      featured: json['featured'] == true,
      flashSale: json['flashSale'] == true,
      sizes: parsedSizes.isNotEmpty ? parsedSizes : ['S', 'M', 'L', 'XL'],
      colors: parsedColors,
      colorImages: parsedColorImages,
    );
  }
}