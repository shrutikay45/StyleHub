import '../models/order_model.dart';

class OrderData {
  static final List<OrderModel> orders = [];

  static void addOrder(OrderModel order) {
    orders.insert(0, order);
  }
}