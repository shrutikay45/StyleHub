import '../models/cart_item.dart';

class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final List<CartItem> items;
  final double totalAmount;
  final String customerName;
  final String deliveryAddress;
  final String paymentMethod;
  final String status;
  final String expectedDelivery;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.customerName,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.expectedDelivery,
  });
}