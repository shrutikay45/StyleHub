class Product {
  final String name;
  final String category;
  final List<String> images;
  final double price;
  final double oldPrice;
  final double rating;

  Product({
    required this.name,
    required this.category,
    required this.images,
    required this.price,
    required this.oldPrice,
    required this.rating,
  });

  String get image => images.first;
}