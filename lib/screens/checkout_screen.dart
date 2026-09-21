import 'package:flutter/material.dart';
import 'package:new_expense/core/constants/app_colors.dart';
import 'package:new_expense/data/order_data.dart';
import 'package:new_expense/models/order_model.dart';
import 'package:new_expense/screens/home/payment_method_screen.dart';

import '../../data/cart_data.dart';
import '../../models/cart_item.dart';
import '../../data/user_data.dart';

class CheckoutScreen extends StatefulWidget {
  // If this is provided, checkout is coming from Buy Now.
  // If null, checkout is coming from the cart.
  final CartItem? buyNowItem;

  const CheckoutScreen({
    super.key,
    this.buyNowItem,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();

}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // ---------------------------------------------------------------------------
  // ADDRESS
  // ---------------------------------------------------------------------------

  String customerName = UserData.name;

  String deliveryAddress = UserData.location;

  // ---------------------------------------------------------------------------
  // CHECKOUT ITEMS
  // ---------------------------------------------------------------------------

  List<CartItem> get checkoutItems {
    if (widget.buyNowItem != null) {
      return [widget.buyNowItem!];
    }

    return CartData.items;
  }

  // ---------------------------------------------------------------------------
  // PRICE CALCULATIONS
  // ---------------------------------------------------------------------------

  double get subtotal {
    return checkoutItems.fold(
      0,
          (total, item) {
        return total + (item.product.price * item.quantity);
      },
    );
  }

  double get deliveryCharge {
    // Free delivery above ₹999
    return subtotal >= 999 ? 0 : 49;
  }

  double get total {
    return subtotal + deliveryCharge;
  }


  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final items = checkoutItems;

    return Scaffold(
      backgroundColor: AppColors.softBackground,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,

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
          'Checkout',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: items.isEmpty
          ? _buildEmptyCart()
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            140,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================================
              // DELIVERY ADDRESS
              // =========================================================

              const Text(
                'Delivery Address',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // LOCATION ICON
                    Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 23,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ADDRESS
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerName,
                            style: const TextStyle(
                              color: AppColors.dark,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            deliveryAddress,
                            style: const TextStyle(
                              color: AppColors.grey,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // CHANGE BUTTON
                    GestureDetector(
                      onTap: _changeAddress,
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // =========================================================
              // ORDER ITEMS
              // =========================================================

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      color: AppColors.dark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    '${items.length} ${items.length == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ...items.map(
                    (item) => _buildProductCard(item),
              ),

              const SizedBox(height: 26),

              // =========================================================
              // COUPON
              // =========================================================

              const Text(
                'Offers & Coupons',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
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
                        Icons.local_offer_outlined,
                        color: AppColors.primary,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Apply Coupon',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: 3),

                          Text(
                            'Save more on your order',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // =========================================================
              // PRICE DETAILS
              // =========================================================

              const Text(
                'Price Details',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: Column(
                  children: [
                    _buildPriceRow(
                      'Subtotal',
                      '₹${subtotal.toStringAsFixed(0)}',
                    ),

                    const SizedBox(height: 12),

                    _buildPriceRow(
                      'Delivery',
                      deliveryCharge == 0
                          ? 'FREE'
                          : '₹${deliveryCharge.toStringAsFixed(0)}',
                      valueColor: deliveryCharge == 0
                          ? AppColors.primary
                          : AppColors.dark,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Divider(
                        color: AppColors.border,
                        height: 1,
                      ),
                    ),

                    _buildPriceRow(
                      'Total Amount',
                      '₹${total.toStringAsFixed(0)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================================================
              // SECURE PAYMENT MESSAGE
              // =========================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      color: AppColors.primaryDark,
                      size: 20,
                    ),

                    const SizedBox(width: 10),

                    const Expanded(
                      child: Text(
                        'Your payment is secure and encrypted.',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // =======================================================================
      // BOTTOM PAYMENT BAR
      // =======================================================================

      bottomNavigationBar: items.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          16,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // TOTAL
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // PAY BUTTON
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _proceedToPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PRODUCT CARD
  // ===========================================================================

  Widget _buildProductCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          // PRODUCT IMAGE
          Container(
            height: 105,
            width: 82,
            decoration: BoxDecoration(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.product.image,
                fit: BoxFit.cover,
                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.lightGrey,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          // PRODUCT DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 7),

                // SIZE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softBackground,
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Size: ${item.size}',
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '₹${item.product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 8),

                    if (item.product.oldPrice >
                        item.product.price)
                      Text(
                        '₹${item.product.oldPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 11,
                          decoration:
                          TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 7),

                Text(
                  'Quantity: ${item.quantity}',
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ITEM TOTAL
          Text(
            '₹${(item.product.price * item.quantity).toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRICE ROW
  // ===========================================================================

  Widget _buildPriceRow(
      String title,
      String value, {
        Color valueColor = AppColors.dark,
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
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
                : FontWeight.w500,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal
                ? FontWeight.w800
                : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // EMPTY CART
  // ===========================================================================

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primary,
                size: 38,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Add some products to your cart before checkout.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Continue Shopping',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // CHANGE ADDRESS
  // ===========================================================================

  void _changeAddress() {
    final nameController = TextEditingController(
      text: customerName,
    );

    final addressController = TextEditingController(
      text: deliveryAddress,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
            MediaQuery.of(context).viewInsets.bottom +
                20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: const TextStyle(
                    color: AppColors.grey,
                  ),
                  focusedBorder:
                  const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  enabledBorder:
                  OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: const TextStyle(
                    color: AppColors.grey,
                  ),
                  focusedBorder:
                  const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.primary,
                    ),
                  ),
                  enabledBorder:
                  OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      customerName =
                          nameController.text.trim();

                      deliveryAddress =
                          addressController.text.trim();
                          
                      UserData.name = customerName;
                      UserData.location = deliveryAddress;
                    });

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(11),
                    ),
                  ),
                  child: const Text(
                    'Save Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ===========================================================================
  // PAYMENT
  // ===========================================================================

  void _proceedToPayment() {
    if (checkoutItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodScreen(
          totalAmount: total,
          items: checkoutItems,
        ),
      ),
    );
  }

}




