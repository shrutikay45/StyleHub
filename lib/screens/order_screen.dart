import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';

import '../models/order_model.dart';
import '../data/order_data.dart';
// import '../utils/app_colors.dart';
import 'order_details_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderData.orders;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
          ),
          color: AppColors.dark,
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: orders.isEmpty
          ? _buildEmptyOrders()
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return _buildOrderCard(
            context,
            order,
          );
        },
      ),
    );
  }

  Widget _buildEmptyOrders() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No orders yet',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your placed orders will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context,
      OrderModel order,
      ) {
    final firstItem =
    order.items.isNotEmpty ? order.items.first : null;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          // Order header
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              14,
              16,
              12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.orderId}',
                        style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Placed on '
                            '${_formatDate(order.orderDate)}',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          // Product preview
          if (firstItem != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildProductImage(
                    firstItem.product.image,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.product.name,
                          maxLines: 2,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Size: ${firstItem.size}',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Quantity: '
                              '${firstItem.quantity}',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${_formatAmount(
                            firstItem.product.price,
                          )}',
                          style: const TextStyle(
                            color: AppColors.dark,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          // Total and delivery
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              13,
              16,
              13,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_formatAmount(
                        order.totalAmount,
                      )}',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 17,
                      color: AppColors.rating,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        order.expectedDelivery,
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          // View details
          InkWell(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(14),
              bottomRight: Radius.circular(14),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OrderDetailsScreen(
                      order: order,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  const Text(
                    'View Details',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 82,
        height: 105,
        color: AppColors.softBackground,
        child: imagePath.startsWith('http')
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.lightGrey,
                    size: 28,
                  );
                },
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.lightGrey,
                    size: 28,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final statusData = _getStatusData(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: statusData['background'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusData['icon'] as IconData,
            size: 14,
            color: statusData['color'] as Color,
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              color: statusData['color'] as Color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(
      String status,
      ) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return {
          'icon': Icons.check_circle_outline,
          'color': AppColors.rating,
          'background': AppColors.softBackground,
        };

      case 'shipped':
        return {
          'icon': Icons.local_shipping_outlined,
          'color': AppColors.primary,
          'background': AppColors.primaryLight,
        };

      case 'out for delivery':
        return {
          'icon': Icons.delivery_dining_outlined,
          'color': AppColors.primary,
          'background': AppColors.primaryLight,
        };

      case 'cancelled':
        return {
          'icon': Icons.cancel_outlined,
          'color': AppColors.primaryDark,
          'background': AppColors.blush,
        };

      default:
        return {
          'icon': Icons.inventory_2_outlined,
          'color': AppColors.grey,
          'background': AppColors.blush,
        };
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0);
  }
}