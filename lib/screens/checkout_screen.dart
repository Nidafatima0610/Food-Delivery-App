import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import '../models/order.dart';
import '../models/notification.dart';
import 'package:uuid/uuid.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String couponCode = '';
  double discount = 0.0;
  final formKey = GlobalKey<FormState>();

  void applyCoupon() {
    if (couponCode == 'WELCOME10') {
      setState(() => discount = 10.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coupon applied!')));
    } else {
      setState(() => discount = 0.0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid coupon code')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider).items;
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final deliveryFee = cartItems.isNotEmpty ? 2.99 : 0.0;
    final calculatedDiscount = discount > 0 ? (subtotal * (discount / 100)) : 0.0;
    final total = subtotal + deliveryFee - calculatedDiscount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
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
              const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primary),
                    SizedBox(width: 16),
                    Expanded(child: Text('123 Main St, Apt 4B, New York, NY 10001')),
                    Icon(Icons.edit, color: AppColors.textLight)
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                child: const Row(
                  children: [
                    Icon(Icons.credit_card, color: Colors.blue),
                    SizedBox(width: 16),
                    Expanded(child: Text('Cash on Delivery')),
                    Icon(Icons.edit, color: AppColors.textLight)
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Coupon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter coupon code',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (val) => couponCode = val,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: applyCoupon,
                    child: const Text('Apply'),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal'), Text('\$${subtotal.toStringAsFixed(2)}')]),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Delivery Fee'), Text('\$${deliveryFee.toStringAsFixed(2)}')]),
                    const SizedBox(height: 8),
                    if (calculatedDiscount > 0)
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Discount', style: TextStyle(color: Colors.green)), Text('-\$${calculatedDiscount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green))]),
                    const Divider(height: 32),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary))]),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your cart is empty!')));
                      return;
                    }
                    if (formKey.currentState!.validate()) {
                      final order = OrderModel(
                        id: const Uuid().v4(),
                        restaurantId: cartItems.first.food.restaurantId,
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
                      
                      ref.read(notificationsProvider.notifier).addNotification(AppNotification(
                        id: const Uuid().v4(),
                        title: 'Order Placed!',
                        message: 'Your order #${order.id.substring(0,8)} has been placed successfully.',
                        date: DateTime.now(),
                      ));
                      
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()), (route) => false);
                    }
                  },
                  child: Text('Place Order • \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
