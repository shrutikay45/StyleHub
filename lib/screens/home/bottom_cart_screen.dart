import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/cart_data.dart';
import 'package:new_expense/screens/checkout_screen.dart';

class BottomCartScreen extends StatefulWidget {
  const BottomCartScreen({
    super.key,
  });

  @override
  State<BottomCartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<BottomCartScreen> {
  double get subtotal {
    double total = 0;

    for (final item in CartData.items) {
      total += item.product.price * item.quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.dark,
            size: 20,
          ),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: CartData.items.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 16,
          ),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: CartData.items.length,
              itemBuilder: (context, index) {
                final item = CartData.items[index];

                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                    BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.border,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: Image.asset(
                          item.product.image,
                          width: 90,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return Container(
                              width: 90,
                              height: 110,
                              color: AppColors.blush,
                              child: const Icon(
                                Icons.image_outlined,
                                color:
                                AppColors.lightGrey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.product.name,
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style:
                                    const TextStyle(
                                      color:
                                      AppColors.dark,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      CartData.items
                                          .removeAt(index);
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color:
                                    AppColors.grey,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Size: ${item.size}',
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '₹${item.product.price}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                _QuantityButton(
                                  icon: Icons.remove,
                                  onTap: () {
                                    setState(() {
                                      if (item.quantity >
                                          1) {
                                        item.quantity--;
                                      }
                                    });
                                  },
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Text(
                                    '${item.quantity}',
                                    style:
                                    const TextStyle(
                                      color:
                                      AppColors.dark,
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _QuantityButton(
                                  icon: Icons.add,
                                  onTap: () {
                                    setState(() {
                                      item.quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              16,
            ),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.border,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${subtotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      // Checkout will be added next.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      AppColors.primary,
                      foregroundColor:
                      AppColors.background,
                      elevation: 0,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
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
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: AppColors.dark,
        ),
      ),
    );
  }
}