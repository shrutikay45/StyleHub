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
    List<String>? colors,
    Map<String, List<String>>? colorImages,
  })  : colors = (colors != null && colors.isNotEmpty)
            ? colors
            : _defaultColorsForCategory(category),
        colorImages = colorImages ?? const {};

  static List<String> _defaultColorsForCategory(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('dress')) return const ['Floral Red', 'Cream Beige', 'Emerald Green', 'Blush Pink', 'Midnight Black'];
    if (cat.contains('top')) return const ['White', 'Dusty Rose', 'Teal Blue', 'Olive Green', 'Black'];
    if (cat.contains('jean')) return const ['Light Blue', 'Dark Blue', 'Vintage Washed', 'Midnight Black'];
    if (cat.contains('t-shirt') || cat.contains('tshirt')) return const ['White', 'Navy Blue', 'Sage Green', 'Charcoal Grey', 'Black'];
    if (cat.contains('kurti')) return const ['Mustard Yellow', 'Pristine White', 'Indigo Blue', 'Ruby Red', 'Peach Pink'];
    if (cat.contains('saree')) return const ['Crimson Red', 'Emerald Green', 'Royal Blue', 'Pastel Pink', 'Midnight Black'];
    if (cat.contains('shoe') || cat.contains('footwear')) return const ['Triple White', 'Nude Beige', 'Black'];
    if (cat.contains('bag')) return const ['Midnight Black', 'Caramel Brown'];
    if (cat.contains('jewel')) return const ['Royal Gold', 'Sterling Silver', 'Rose Gold'];
    if (cat.contains('skirt')) return const ['Sage Green', 'Crimson Red', 'Navy Blue', 'Black'];
    if (cat.contains('coord') || cat.contains('co-ord')) return const ['Lilac Purple', 'Cream Beige', 'Emerald Green', 'Charcoal Black'];
    if (cat.contains('western')) return const ['Ruby Red', 'Dusty Blue', 'Forest Green', 'Midnight Black'];
    if (cat.contains('ethnic')) return const ['Mustard Gold', 'Peacock Blue', 'Maroon Red', 'Emerald Green'];
    return const ['Black', 'Beige', 'Navy Blue'];
  }

  String get image => images.isNotEmpty ? images.first : 'assets/images/dress6.webp';

  List<String> getImagesForColor(String? color) {
    if (color != null) {
      // 1. Check exact match in colorImages
      if (colorImages.containsKey(color) && colorImages[color]!.isNotEmpty) {
        return colorImages[color]!;
      }
      // 2. Check case-insensitive match in colorImages
      for (final entry in colorImages.entries) {
        if (entry.key.toLowerCase().trim() == color.toLowerCase().trim() && entry.value.isNotEmpty) {
          return entry.value;
        }
      }
      // 3. Fallback matching based on category and color name keywords
      final cat = category.toLowerCase();
      final col = color.toLowerCase();

      if (cat.contains('dress')) {
        if (col.contains('black') || col.contains('dark')) return const ['assets/images/dress12.webp', 'assets/images/dress16.webp'];
        if (col.contains('beige') || col.contains('cream') || col.contains('white') || col.contains('gold')) return const ['assets/images/dress1.webp', 'assets/images/dress14.webp'];
        if (col.contains('navy') || col.contains('blue')) return const ['assets/images/dress7.webp', 'assets/images/dress9.webp'];
        if (col.contains('red') || col.contains('crimson') || col.contains('wine') || col.contains('ruby')) return const ['assets/images/dress3.webp', 'assets/images/dress6.webp'];
        if (col.contains('green') || col.contains('sage') || col.contains('emerald')) return const ['assets/images/dress2.webp', 'assets/images/dress3.webp'];
        if (col.contains('pink') || col.contains('peach') || col.contains('blush') || col.contains('rose')) return const ['assets/images/dress4.webp', 'assets/images/dress13.webp'];
        if (col.contains('purple') || col.contains('lilac')) return const ['assets/images/dress11.webp', 'assets/images/dress15.webp'];
        if (col.contains('yellow') || col.contains('mustard')) return const ['assets/images/dress7.webp', 'assets/images/dress10.webp'];
      } else if (cat.contains('top')) {
        if (col.contains('black')) return const ['assets/images/top4.webp', 'assets/images/top8.webp'];
        if (col.contains('beige') || col.contains('cream') || col.contains('white') || col.contains('ivory')) return const ['assets/images/top.webp', 'assets/images/top2.webp'];
        if (col.contains('blue') || col.contains('navy') || col.contains('teal')) return const ['assets/images/top1.webp', 'assets/images/top5.webp'];
        if (col.contains('green') || col.contains('olive') || col.contains('forest')) return const ['assets/images/top3.webp', 'assets/images/top1.webp'];
        if (col.contains('pink') || col.contains('rose') || col.contains('dusty')) return const ['assets/images/top2.webp', 'assets/images/top7.webp'];
        if (col.contains('wine') || col.contains('red')) return const ['assets/images/top8.webp', 'assets/images/top4.webp'];
        if (col.contains('yellow') || col.contains('sunflower')) return const ['assets/images/top6.webp', 'assets/images/top7.webp'];
      } else if (cat.contains('jean')) {
        if (col.contains('light') || col.contains('ice')) return const ['assets/images/jeans1.webp', 'assets/images/jeans3.webp'];
        if (col.contains('dark') || col.contains('navy') || col.contains('indigo')) return const ['assets/images/jeans6.webp', 'assets/images/jeans2.webp'];
        if (col.contains('black') || col.contains('charcoal') || col.contains('midnight')) return const ['assets/images/jeans7.webp', 'assets/images/jeans.webp'];
        if (col.contains('washed') || col.contains('vintage') || col.contains('blue')) return const ['assets/images/jeans5.webp', 'assets/images/jeans3.webp'];
      } else if (cat.contains('t-shirt') || cat.contains('tshirt')) {
        if (col.contains('black') || col.contains('faded')) return const ['assets/images/tshirt.webp', 'assets/images/tshirt2.webp'];
        if (col.contains('white') || col.contains('off white') || col.contains('cream')) return const ['assets/images/tshirt.webp', 'assets/images/tshirt8.webp'];
        if (col.contains('navy') || col.contains('blue')) return const ['assets/images/tshirt1.webp', 'assets/images/tshirt3.webp'];
        if (col.contains('grey') || col.contains('charcoal')) return const ['assets/images/tshirt1.webp', 'assets/images/tshirt8.webp'];
        if (col.contains('green') || col.contains('sage')) return const ['assets/images/tshirt5.webp', 'assets/images/tshirt2.webp'];
      } else if (cat.contains('kurti')) {
        if (col.contains('white') || col.contains('cream') || col.contains('pristine')) return const ['assets/images/kurti.webp', 'assets/images/kurti6.webp'];
        if (col.contains('blue') || col.contains('indigo') || col.contains('sky') || col.contains('royal')) return const ['assets/images/kurti2.webp', 'assets/images/kurti5.webp'];
        if (col.contains('yellow') || col.contains('mustard')) return const ['assets/images/kurti1.webp', 'assets/images/kurti7.webp'];
        if (col.contains('red') || col.contains('ruby')) return const ['assets/images/kurti3.webp', 'assets/images/kurti4.webp'];
        if (col.contains('pink') || col.contains('peach')) return const ['assets/images/kurti4.webp', 'assets/images/kurti3.webp'];
        if (col.contains('wine') || col.contains('purple')) return const ['assets/images/kurti7.webp', 'assets/images/kurti3.webp'];
        if (col.contains('teal')) return const ['assets/images/kurti1.webp', 'assets/images/kurti5.webp'];
      } else if (cat.contains('saree')) {
        if (col.contains('red') || col.contains('crimson') || col.contains('maroon')) return const ['assets/images/saree.webp', 'assets/images/saree1.webp'];
        if (col.contains('green') || col.contains('emerald')) return const ['assets/images/saree.webp', 'assets/images/saree3.webp'];
        if (col.contains('blue') || col.contains('royal') || col.contains('magenta')) return const ['assets/images/saree1.webp', 'assets/images/saree.webp'];
        if (col.contains('pink') || col.contains('pastel')) return const ['assets/images/saree2.webp', 'assets/images/saree4.webp'];
        if (col.contains('black') || col.contains('midnight')) return const ['assets/images/saree3.webp', 'assets/images/saree.webp'];
        if (col.contains('white')) return const ['assets/images/saree4.webp', 'assets/images/saree2.webp'];
      } else if (cat.contains('shoe') || cat.contains('footwear')) {
        if (col.contains('black')) return const ['assets/images/shoes.webp', 'assets/images/shoes2.webp'];
        if (col.contains('white')) return const ['assets/images/shoes1.webp', 'assets/images/shoes3.webp'];
        if (col.contains('beige') || col.contains('nude') || col.contains('brown')) return const ['assets/images/shoes.webp', 'assets/images/footwear.webp'];
      } else if (cat.contains('bag')) {
        if (col.contains('black')) return const ['assets/images/black_bag.webp', 'assets/images/bag2.webp'];
        if (col.contains('brown') || col.contains('caramel') || col.contains('tan') || col.contains('beige')) return const ['assets/images/brown_bag.webp', 'assets/images/bag1.webp'];
      }
    }
    return images.isNotEmpty ? images : const ['assets/images/dress6.webp'];
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final catName = (json['categoryName'] ?? json['category'] ?? '').toString().toLowerCase();
    List<String> imgList = [];
    if (json['images'] != null && json['images'] is List) {
      imgList = (json['images'] as List)
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
    if (imgList.isEmpty) {
      if (catName.contains('dress')) {
        imgList = ['assets/images/dress6.webp', 'assets/images/dress7.webp'];
      } else if (catName.contains('top')) {
        imgList = ['assets/images/top1.webp', 'assets/images/top2.webp'];
      } else if (catName.contains('jean')) {
        imgList = ['assets/images/jeans1.webp', 'assets/images/jeans2.webp'];
      } else if (catName.contains('t-shirt') || catName.contains('tshirt')) {
        imgList = ['assets/images/tshirt1.webp', 'assets/images/tshirt2.webp'];
      } else if (catName.contains('kurti')) {
        imgList = ['assets/images/kurti1.webp', 'assets/images/kurti2.webp'];
      } else if (catName.contains('saree')) {
        imgList = ['assets/images/saree1.webp', 'assets/images/saree2.webp'];
      } else if (catName.contains('shoe') || catName.contains('footwear')) {
        imgList = ['assets/images/shoes1.webp', 'assets/images/shoes2.webp'];
      } else if (catName.contains('bag')) {
        imgList = ['assets/images/black_bag.webp', 'assets/images/brown_bag.webp'];
      } else if (catName.contains('jewel')) {
        imgList = ['assets/images/jeweller1.webp', 'assets/images/jewellery2.webp'];
      } else if (catName.contains('skirt')) {
        imgList = ['assets/images/skirt1.webp', 'assets/images/skirt2.webp'];
      } else if (catName.contains('coord') || catName.contains('co-ord')) {
        imgList = ['assets/images/coord1.webp', 'assets/images/coord2.webp'];
      } else if (catName.contains('western')) {
        imgList = ['assets/images/western1.webp', 'assets/images/western2.webp'];
      } else if (catName.contains('ethnic')) {
        imgList = ['assets/images/ethnic1.webp', 'assets/images/ethnic2.webp'];
      } else {
        imgList = ['assets/images/dress6.webp'];
      }
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

    // Parse or build Color to Images mapping
    Map<String, List<String>> parsedColorImages = {};
    if (json['colorImages'] != null && json['colorImages'] is Map) {
      (json['colorImages'] as Map).forEach((k, v) {
        if (v is List) {
          parsedColorImages[k.toString()] = v.map((e) => e.toString()).toList();
        }
      });
    }

    // Auto-generate smart variant images if not explicitly provided
    if (parsedColorImages.isEmpty) {
      if (catName.contains('jean')) {
        parsedColorImages = {
          'Light Blue': ['assets/images/jeans1.webp', 'assets/images/jeans3.webp'],
          'Ice Blue': ['assets/images/jeans1.webp', 'assets/images/jeans5.webp'],
          'Blue': ['assets/images/jeans.webp', 'assets/images/jeans2.webp'],
          'Navy Blue': ['assets/images/jeans2.webp', 'assets/images/jeans6.webp'],
          'Dark Blue': ['assets/images/jeans6.webp', 'assets/images/jeans2.webp'],
          'Deep Indigo': ['assets/images/jeans4.webp', 'assets/images/jeans6.webp'],
          'Midnight Black': ['assets/images/jeans7.webp', 'assets/images/jeans.webp'],
          'Black': ['assets/images/jeans7.webp', 'assets/images/jeans.webp'],
          'Washed Blue': ['assets/images/jeans3.webp', 'assets/images/jeans5.webp'],
          'Vintage Blue': ['assets/images/jeans5.webp', 'assets/images/jeans3.webp'],
        };
      } else if (catName.contains('dress')) {
        parsedColorImages = {
          'Floral Red': ['assets/images/dress1.webp', 'assets/images/dress12.webp'],
          'Cream': ['assets/images/dress1.webp', 'assets/images/dress14.webp'],
          'Sage Green': ['assets/images/dress2.webp', 'assets/images/dress3.webp'],
          'White': ['assets/images/dress2.webp', 'assets/images/dress14.webp'],
          'Emerald Green': ['assets/images/dress3.webp', 'assets/images/dress2.webp'],
          'Wine Red': ['assets/images/dress3.webp', 'assets/images/dress12.webp'],
          'Blush Pink': ['assets/images/dress4.webp', 'assets/images/dress13.webp'],
          'Coral': ['assets/images/dress4.webp', 'assets/images/dress8.webp'],
          'Champagne Gold': ['assets/images/dress6.webp', 'assets/images/dress7.webp'],
          'Ruby': ['assets/images/dress6.webp', 'assets/images/dress12.webp'],
          'Navy Blue': ['assets/images/dress7.webp', 'assets/images/dress9.webp'],
          'Mustard': ['assets/images/dress7.webp', 'assets/images/dress10.webp'],
          'Lilac Purple': ['assets/images/dress11.webp', 'assets/images/dress15.webp'],
          'Crimson Red': ['assets/images/dress12.webp', 'assets/images/dress3.webp'],
          'Black': ['assets/images/dress12.webp', 'assets/images/dress16.webp'],
        };
      } else if (catName.contains('top')) {
        parsedColorImages = {
          'White': ['assets/images/top.webp', 'assets/images/top2.webp'],
          'Dusty Rose': ['assets/images/top.webp', 'assets/images/top6.webp'],
          'Teal': ['assets/images/top1.webp', 'assets/images/top5.webp'],
          'Cream': ['assets/images/top1.webp', 'assets/images/top3.webp'],
          'Ivory': ['assets/images/top2.webp', 'assets/images/top.webp'],
          'Blush': ['assets/images/top2.webp', 'assets/images/top7.webp'],
          'Olive': ['assets/images/top3.webp', 'assets/images/top1.webp'],
          'Black': ['assets/images/top4.webp', 'assets/images/top8.webp'],
          'Champagne': ['assets/images/top5.webp', 'assets/images/top.webp'],
          'Forest Green': ['assets/images/top5.webp', 'assets/images/top3.webp'],
          'Sunflower': ['assets/images/top6.webp', 'assets/images/top7.webp'],
          'Wine': ['assets/images/top8.webp', 'assets/images/top4.webp'],
        };
      } else if (catName.contains('t-shirt') || catName.contains('tshirt')) {
        parsedColorImages = {
          'White': ['assets/images/tshirt.webp', 'assets/images/tshirt8.webp'],
          'Black': ['assets/images/tshirt.webp', 'assets/images/tshirt2.webp'],
          'Charcoal Grey': ['assets/images/tshirt1.webp', 'assets/images/tshirt8.webp'],
          'Navy': ['assets/images/tshirt1.webp', 'assets/images/tshirt3.webp'],
          'Faded Black': ['assets/images/tshirt2.webp', 'assets/images/tshirt1.webp'],
          'Sage Green': ['assets/images/tshirt5.webp', 'assets/images/tshirt2.webp'],
          'Cream': ['assets/images/tshirt6.webp', 'assets/images/tshirt.webp'],
          'Off White': ['assets/images/tshirt8.webp', 'assets/images/tshirt.webp'],
        };
      } else if (catName.contains('kurti')) {
        parsedColorImages = {
          'Pristine White': ['assets/images/kurti.webp', 'assets/images/kurti6.webp'],
          'Sky Blue': ['assets/images/kurti.webp', 'assets/images/kurti2.webp'],
          'Mustard Yellow': ['assets/images/kurti1.webp', 'assets/images/kurti7.webp'],
          'Teal': ['assets/images/kurti1.webp', 'assets/images/kurti5.webp'],
          'Indigo Blue': ['assets/images/kurti2.webp', 'assets/images/kurti5.webp'],
          'Ruby Red': ['assets/images/kurti3.webp', 'assets/images/kurti4.webp'],
          'Peach Pink': ['assets/images/kurti4.webp', 'assets/images/kurti3.webp'],
          'Royal Blue': ['assets/images/kurti5.webp', 'assets/images/kurti2.webp'],
          'Wine Purple': ['assets/images/kurti7.webp', 'assets/images/kurti3.webp'],
        };
      } else if (catName.contains('saree')) {
        parsedColorImages = {
          'Crimson Red & Gold': ['assets/images/saree.webp', 'assets/images/saree1.webp'],
          'Emerald Green': ['assets/images/saree.webp', 'assets/images/saree3.webp'],
          'Royal Blue & Magenta': ['assets/images/saree1.webp', 'assets/images/saree.webp'],
          'Pastel Pink': ['assets/images/saree2.webp', 'assets/images/saree4.webp'],
          'Midnight Black': ['assets/images/saree3.webp', 'assets/images/saree.webp'],
          'White & Red Border': ['assets/images/saree4.webp', 'assets/images/saree2.webp'],
        };
      } else if (catName.contains('shoe') || catName.contains('footwear')) {
        parsedColorImages = {
          'Nude Beige': ['assets/images/shoes.webp', 'assets/images/footwear.webp'],
          'Black': ['assets/images/shoes.webp', 'assets/images/shoes2.webp'],
          'Triple White': ['assets/images/shoes1.webp', 'assets/images/shoes3.webp'],
          'Pastel Pink': ['assets/images/shoes1.webp', 'assets/images/shoes.webp'],
          'Patent Red': ['assets/images/shoes2.webp', 'assets/images/shoes.webp'],
          'Golden': ['assets/images/footwear.webp', 'assets/images/shoes.webp'],
        };
      } else if (catName.contains('bag')) {
        parsedColorImages = {
          'Jet Black': ['assets/images/black_bag.webp', 'assets/images/purple_bag.webp'],
          'Caramel Brown': ['assets/images/brown_bag.webp', 'assets/images/black_bag.webp'],
          'Blush Pink': ['assets/images/pink_bag.webp', 'assets/images/purple_bag.webp'],
          'Deep Purple': ['assets/images/purple_bag.webp', 'assets/images/black_bag.webp'],
        };
      }
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
      colorImages: parsedColorImages,
    );
  }
}