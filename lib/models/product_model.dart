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

    final categoryStr = json['categoryName']?.toString() ?? json['category']?.toString() ?? 'Dresses';

    // Sanitize any mismatched footwear image URLs if category is clothing/apparel
    final isFootwear = categoryStr.toLowerCase().contains('shoe') || categoryStr.toLowerCase().contains('footwear');
    if (!isFootwear && imgList.isNotEmpty) {
      imgList = imgList.where((img) {
        final lower = img.toLowerCase();
        return !lower.contains('photo-1518049362265') &&
               !lower.contains('photo-1543163521-1bf539c55dd2') &&
               !lower.contains('photo-1560343090-f0409e92791a') &&
               !lower.contains('photo-1535043934128') &&
               !lower.contains('photo-1595950653106') &&
               !lower.contains('photo-1542291026-7eec264c27ff') &&
               !lower.contains('photo-1525966222134');
      }).toList();
    }

    if (imgList.isEmpty) {
      final cat = categoryStr.toLowerCase();
      if (cat.contains('dress')) {
        imgList = [
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('jean') || cat.contains('denim')) {
        imgList = [
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1542272604-780c96856592?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1582552938357-32b906df40cb?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('top') || cat.contains('blouse')) {
        imgList = [
          'https://images.unsplash.com/photo-1564257631407-4deb1f99d992?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1534126511673-b6899657816a?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('t-shirt') || cat.contains('tee')) {
        imgList = [
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('kurti')) {
        imgList = [
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('saree')) {
        imgList = [
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('shoe') || cat.contains('footwear')) {
        imgList = [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('bag')) {
        imgList = [
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('jewel')) {
        imgList = [
          'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('skirt')) {
        imgList = [
          'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('coord') || cat.contains('co-ord')) {
        imgList = [
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=800&auto=format&fit=crop'
        ];
      } else if (cat.contains('ethnic')) {
        imgList = [
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800&auto=format&fit=crop'
        ];
      } else {
        imgList = [
          'https://images.unsplash.com/photo-1548142813-c348350df52b?w=800&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?w=800&auto=format&fit=crop'
        ];
      }
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