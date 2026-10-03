import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import '../models/order.dart';
import '../models/notification.dart';
import '../widgets/app_image.dart';
import 'package:uuid/uuid.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  double discountPercentage = 0.0;
  double flatDiscount = 0.0;
  String appliedCouponCode = '';
  String paymentMethod = 'Cash on Delivery';
  String deliveryAddress = '123 Main St, Apt 4B, Gulberg III, Lahore';
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void applyCoupon(double subtotal, double currentDeliveryFee) {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    if (code == 'WELCOME10') {
      if (subtotal < 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minimum order of Rs. 500 required for WELCOME10.')),
        );
        return;
      }
      setState(() {
        discountPercentage = 10.0;
        flatDiscount = 0.0;
        appliedCouponCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon WELCOME10 applied! 10% discount added.')),
      );
    } else if (code == 'FEAST20') {
      if (subtotal < 1000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minimum order of Rs. 1,000 required for FEAST20.')),
        );
        return;
      }
      setState(() {
        discountPercentage = 20.0;
        flatDiscount = 0.0;
        appliedCouponCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon FEAST20 applied! 20% discount added.')),
      );
    } else if (code == 'BIRYANI15') {
      if (subtotal < 600) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minimum order of Rs. 600 required for BIRYANI15.')),
        );
        return;
      }
      setState(() {
        discountPercentage = 15.0;
        flatDiscount = 0.0;
        appliedCouponCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon BIRYANI15 applied! 15% discount added.')),
      );
    } else if (code == 'FREESHIP') {
      if (subtotal < 600) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Minimum order of Rs. 600 required for FREESHIP.')),
        );
        return;
      }
      setState(() {
        discountPercentage = 0.0;
        flatDiscount = currentDeliveryFee;
        appliedCouponCode = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon FREESHIP applied! Free delivery discount added.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code. Try WELCOME10, FEAST20, or BIRYANI15.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;
    final subtotal = ref.watch(cartProvider.notifier).subtotal;

    final restaurant = cartState.restaurantId != null
        ? SampleData.getRestaurantById(cartState.restaurantId!)
        : (cartItems.isNotEmpty ? SampleData.getRestaurantById(cartItems.first.food.restaurantId) : null);

    final deliveryFee = cartItems.isNotEmpty ? (restaurant?.deliveryFee ?? 80.0) : 0.0;
    final calculatedDiscount = (discountPercentage > 0)
        ? (subtotal * (discountPercentage / 100))
        : flatDiscount;
    final total = (subtotal + deliveryFee - calculatedDiscount).clamp(0.0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Delivery Address Card
              const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(
                            deliveryAddress,
                            style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                      onPressed: () {
                        // Dialog to edit delivery address
                        final editController = TextEditingController(text: deliveryAddress);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Edit Delivery Address'),
                            content: TextField(
                              controller: editController,
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() => deliveryAddress = editController.text);
                                  Navigator.pop(context);
                                },
                                child: const Text('Save', style: TextStyle(color: AppColors.primary)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Order Items Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Order Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (restaurant != null)
                    Text(
                      restaurant.name,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: cartItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          AppImage(
                            imageUrl: item.food.image,
                            width: 45,
                            height: 45,
                            category: item.food.category,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.food.name,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.customizations.isNotEmpty)
                                  Text(
                                    item.customizations.join(', '),
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            AppFormatters.currency(item.totalPrice),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // 3. Payment Method
              const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildPaymentOption(
                      'Cash on Delivery',
                      Icons.money,
                      Colors.green,
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      'Credit / Debit Card',
                      Icons.credit_card,
                      Colors.blue,
                    ),
                    const Divider(height: 1),
                    _buildPaymentOption(
                      'Mobile Wallet (JazzCash / EasyPaisa)',
                      Icons.account_balance_wallet,
                      Colors.orange,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. Coupon Code
              const Text('Promotions & Coupons', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: 'Enter WELCOME10, FEAST20 or BIRYANI15',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textLight),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onPressed: () => applyCoupon(subtotal, deliveryFee),
                      child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 5. Bill Breakdown
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal', style: TextStyle(color: AppColors.textLight)),
                        Text(AppFormatters.currency(subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee', style: TextStyle(color: AppColors.textLight)),
                        Text(
                          deliveryFee == 0 ? 'Free' : AppFormatters.currency(deliveryFee),
                          style: TextStyle(
                            color: deliveryFee == 0 ? Colors.green.shade700 : AppColors.textDark,
                            fontWeight: deliveryFee == 0 ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (calculatedDiscount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount ($appliedCouponCode)', style: const TextStyle(color: Colors.green)),
                          Text(
                            '-${AppFormatters.currency(calculatedDiscount)}',
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Final Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text(
                          AppFormatters.currency(total),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // 6. Place Order Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Your cart is empty!')),
                      );
                      return;
                    }

                    final restaurantId = cartItems.first.food.restaurantId;
                    final resObj = SampleData.getRestaurantById(restaurantId);
                    final restaurantName = resObj?.name ?? 'Restaurant';

                    final order = OrderModel(
                      id: const Uuid().v4(),
                      restaurantId: restaurantId,
                      restaurantName: restaurantName,
                      items: cartItems,
                      subtotal: subtotal,
                      deliveryFee: deliveryFee,
                      discount: calculatedDiscount,
                      total: total,
                      date: DateTime.now(),
                      status: OrderStatus.placed,
                    );

                    ref.read(ordersProvider.notifier).addOrder(order);
                    ref.read(cartProvider.notifier).clear();

                    ref.read(notificationsProvider.notifier).addNotification(
                          AppNotification(
                            id: const Uuid().v4(),
                            title: 'Order Placed Successfully!',
                            message: 'Your order #${order.id.substring(0, 8)} from $restaurantName has been placed.',
                            date: DateTime.now(),
                          ),
                        );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => OrderSuccessScreen(order: order)),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Place Order • ${AppFormatters.currency(total)}',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, Color iconColor) {
    final isSelected = paymentMethod == title;
    return InkWell(
      onTap: () => setState(() => paymentMethod = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
