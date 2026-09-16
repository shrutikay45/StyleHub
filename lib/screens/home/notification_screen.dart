import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  // Mock notification data
  static const List<Map<String, String>> notifications = [
    {
      'title': 'Flash Sale is Live!',
      'message': 'Get up to 50% off on selected women\'s fashion.',
      'time': '10 min ago',
      'type': 'flash',
    },
    {
      'title': 'New Collection Available',
      'message': 'Discover our latest arrivals and trending styles.',
      'time': '1 hour ago',
      'type': 'shopping',
    },
    {
      'title': 'Special Offer Just for You',
      'message': 'Enjoy an exclusive discount on your next order.',
      'time': '3 hours ago',
      'type': 'offer',
    },
    {
      'title': 'Order Update',
      'message': 'Your order has been successfully confirmed.',
      'time': 'Yesterday',
      'type': 'order',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF222222),
          ),
        ),

        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Notification List
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          return _buildNotificationItem(notification);
        },
      ),
    );
  }

  // Notification Item
  Widget _buildNotificationItem(
      Map<String, String> notification,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getNotificationIcon(notification['type']!),
              color: const Color(0xFFE91E63),
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title']!,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  notification['message']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  notification['time']!,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Notification Icon
  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'flash':
        return Icons.local_fire_department_outlined;

      case 'shopping':
        return Icons.shopping_bag_outlined;

      case 'offer':
        return Icons.local_offer_outlined;

      case 'order':
        return Icons.inventory_2_outlined;

      default:
        return Icons.notifications_none;
    }
  }

  // Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F1F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 42,
              color: Color(0xFFAAAAAA),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'No notifications',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'You\'re all caught up!',
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}