import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';

import '../models/order_model.dart';
// import '../utils/app_colors.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
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
          'Order Details',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),

            const SizedBox(height: 16),

            _buildProductsSection(),

            const SizedBox(height: 16),

            _buildDeliveryStatus(),

            const SizedBox(height: 16),

            _buildDeliveryAddress(),

            const SizedBox(height: 16),

            _buildPaymentMethod(),

            const SizedBox(height: 16),

            _buildPriceDetails(),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ORDER HEADER
  // ----------------------------------------------------------

  Widget _buildOrderHeader() {
    return _buildSectionCard(
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.orderId}',
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Placed on ${_formatDate(order.orderDate)}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBadge(order.status),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCTS
  // ----------------------------------------------------------

  Widget _buildProductsSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Items in this order',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...order.items.asMap().entries.map(
                (entry) {
              final index = entry.key;
              final item = entry.value;

              return Column(
                children: [
                  _buildProductItem(item),
                  if (index < order.items.length - 1)
                    const Divider(
                      height: 24,
                      color: AppColors.border,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(dynamic item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 82,
            height: 100,
            color: AppColors.softBackground,
            child: item.product.image.startsWith('http')
                ? Image.network(
                    item.product.image,
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
                    item.product.image,
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
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Size: ${item.size}',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Quantity: ${item.quantity}',
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '₹${_formatAmount(item.product.price)}',
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // DELIVERY STATUS
  // ----------------------------------------------------------

  Widget _buildDeliveryStatus() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Status',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          _buildTrackingStep(
            title: 'Order Confirmed',
            subtitle: 'Your order has been confirmed',
            icon: Icons.check_circle_outline,
            isCompleted: true,
            isLast: false,
          ),

          _buildTrackingStep(
            title: 'Packed',
            subtitle: 'Your order has been packed',
            icon: Icons.inventory_2_outlined,
            isCompleted: _isStepCompleted(1),
            isLast: false,
          ),

          _buildTrackingStep(
            title: 'Shipped',
            subtitle: 'Your order is on the way',
            icon: Icons.local_shipping_outlined,
            isCompleted: _isStepCompleted(2),
            isLast: false,
          ),

          _buildTrackingStep(
            title: 'Out for Delivery',
            subtitle: 'Your order is out for delivery',
            icon: Icons.delivery_dining_outlined,
            isCompleted: _isStepCompleted(3),
            isLast: false,
          ),

          _buildTrackingStep(
            title: 'Delivered',
            subtitle: 'Your order has been delivered',
            icon: Icons.home_outlined,
            isCompleted: _isStepCompleted(4),
            isLast: true,
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.softBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    order.expectedDelivery,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isLast,
  }) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary
                        : AppColors.blush,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: isCompleted
                        ? AppColors.background
                        : AppColors.lightGrey,
                  ),
                ),

                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted
                        ? AppColors.primaryLight
                        : AppColors.border,
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 2,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isCompleted
                          ? AppColors.dark
                          : AppColors.lightGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DELIVERY ADDRESS
  // ----------------------------------------------------------

  Widget _buildDeliveryAddress() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Address',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 22,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      order.deliveryAddress,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PAYMENT METHOD
  // ----------------------------------------------------------

  Widget _buildPaymentMethod() {
    return _buildSectionCard(
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payment_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order.paymentMethod,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRICE DETAILS
  // ----------------------------------------------------------

  Widget _buildPriceDetails() {
    double productTotal = 0;

    for (final item in order.items) {
      productTotal +=
          item.product.price * item.quantity;
    }

    final deliveryCharge =
    order.totalAmount > productTotal
        ? order.totalAmount - productTotal
        : 0;

    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          _buildPriceRow(
            'Product Total',
            '₹${_formatAmount(productTotal)}',
          ),

          const SizedBox(height: 10),

          _buildPriceRow(
            'Delivery',
            deliveryCharge == 0
                ? 'FREE'
                : '₹${_formatAmount(deliveryCharge)}',
            valueColor: deliveryCharge == 0
                ? AppColors.rating
                : AppColors.dark,
          ),

          const SizedBox(height: 13),

          const Divider(
            height: 1,
            color: AppColors.border,
          ),

          const SizedBox(height: 13),

          _buildPriceRow(
            'Total Amount',
            '₹${_formatAmount(order.totalAmount)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
      String title,
      String value, {
        Color? valueColor,
        bool isTotal = false,
      }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal
                ? AppColors.dark
                : AppColors.grey,
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.dark,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // COMMON CARD
  // ----------------------------------------------------------

  Widget _buildSectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: child,
    );
  }

  // ----------------------------------------------------------
  // STATUS BADGE
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // TRACKING LOGIC
  // ----------------------------------------------------------

  bool _isStepCompleted(int step) {
    switch (order.status.toLowerCase()) {
      case 'delivered':
        return true;

      case 'out for delivery':
        return step <= 3;

      case 'shipped':
        return step <= 2;

      case 'packed':
        return step <= 1;

      case 'order confirmed':
        return step == 0;

      case 'cancelled':
        return false;

      default:
        return step == 0;
    }
  }

  // ----------------------------------------------------------
  // DATE FORMAT
  // ----------------------------------------------------------

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

  // ----------------------------------------------------------
  // AMOUNT FORMAT
  // ----------------------------------------------------------

  String _formatAmount(num amount) {
    return amount.toStringAsFixed(0);
  }
}