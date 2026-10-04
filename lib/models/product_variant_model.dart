class ProductVariant {
  final String? id;
  final String? productId;
  final String? size;
  final String? color;
  final double? priceOverride;
  final double? discountPrice;
  final int stock;
  final List<String> images;

  const ProductVariant({
    this.id,
    this.productId,
    this.size,
    this.color,
    this.priceOverride,
    this.discountPrice,
    this.stock = 0,
    this.images = const [],
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final List<String> parsedImages = [];

    if (json['images'] is List) {
      parsedImages.addAll(
        (json['images'] as List)
            .map((image) => image.toString())
            .where((image) => image.trim().isNotEmpty),
      );
    }

    return ProductVariant(
      id: json['id']?.toString() ?? json['variantId']?.toString(),
      productId: json['productId']?.toString(),
      size: json['size']?.toString(),
      color: json['color']?.toString(),
      priceOverride: json['priceOverride'] != null
          ? (json['priceOverride'] as num).toDouble()
          : null,
      discountPrice: json['discountPrice'] != null
          ? (json['discountPrice'] as num).toDouble()
          : null,
      stock: json['stock'] != null ? (json['stock'] as num).toInt() : 0,
      images: parsedImages,
    );
  }
}