// import 'package:new_expense/models/product.dart';

import 'package:new_expense/models/product_model.dart';

class WishlistData {
  static final List<Product> items = [];

  static bool contains(Product product) {
    return items.any(
          (item) => item.name == product.name,
    );
  }

  static void add(Product product) {
    if (!contains(product)) {
      items.add(product);
    }
  }

  static void remove(Product product) {
    items.removeWhere(
          (item) => item.name == product.name,
    );
  }

  static void toggle(Product product) {
    if (contains(product)) {
      remove(product);
    } else {
      add(product);
    }
  }
}