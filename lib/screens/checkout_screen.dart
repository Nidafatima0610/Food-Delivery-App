import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';
import '../models/notification.dart';
import '../widgets/app_image.dart';
import 'package:uuid/uuid.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String? initialCouponCode;
  const CheckoutScreen({super.key, this.initialCouponCode});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  double discountPercentage = 0.0;
  double flatDiscount = 0.0;
  String appliedCouponCode = '';
  String paymentMethod = 'Cash on Delivery';
  String deliveryAddress = 'House 14, Street 3, Model Town A, Bahawalpur';
  String deliveryLabel = 'Home';
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _nameController.text = user?.name ?? 'Umair Raza';
    _phoneController.text = user?.phone ?? '+92 300 8654321';

    final savedAddresses = ref.read(addressesProvider);
    if (savedAddresses.isNotEmpty) {
      final defaultAddr = savedAddresses.firstWhere((a) => a.isDefault, orElse: () => savedAddresses.first);
      deliveryAddress = defaultAddr.addressLine;
      deliveryLabel = defaultAddr.label;
    }

    if (widget.initialCouponCode != null && widget.initialCouponCode!.isNotEmpty) {
      _couponController.text = widget.initialCouponCode!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final subtotal = ref.read(cartProvider.notifier).subtotal;
        final cartState = ref.read(cartProvider);
        final restaurant = cartState.restaurantId != null ? SampleData.getRestaurantById(cartState.restaurantId!) : null;
        final deliveryFee = restaurant?.deliveryFee ?? 80.0;
        applyCoupon(subtotal, deliveryFee);
      });
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void applyCoupon(double subtotal, double currentDeliveryFee) {
    final code = _couponController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    final matched = SampleData.coupons.where((c) => c.code.toUpperCase() == code).toList();
    if (matched.isNotEmpty) {
      final coupon = matched.first;
      if (subtotal < coupon.minOrderAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Minimum order of ${AppFormatters.currency(coupon.minOrderAmount)} required for ${coupon.code}.')),
        );
        return;
      }
      setState(() {
        if (coupon.isPercentage) {
          discountPercentage = coupon.discountValue;
          flatDiscount = 0.0;
        } else {
          discountPercentage = 0.0;
          flatDiscount = coupon.code == 'FREESHIP' ? currentDeliveryFee : coupon.discountValue;
        }
        appliedCouponCode = coupon.code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Coupon ${coupon.code} applied successfully!'), backgroundColor: AppColors.primary),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code. Try WELCOME10, FEAST20, FREESHIP or BIRYANI15.')),
      );
    }
  }

  void _showAddressPicker(BuildContext context) {
    final addresses = ref.read(addressesProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 10),
              ...addresses.map((a) {
                final isSelected = deliveryAddress == a.addressLine;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.primary : Colors.grey,
                  ),
                  title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(a.addressLine, style: const TextStyle(fontSize: 12)),
                  onTap: () {
                    setState(() {
                      deliveryAddress = a.addressLine;
                      deliveryLabel = a.label;
                    });
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.edit_location_alt_outlined),
                label: const Text('Enter Custom Address'),
                onPressed: () {
                  Navigator.pop(ctx);
                  _showEditAddressDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditAddressDialog(BuildContext context) {
    final editController = TextEditingController(text: deliveryAddress);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Delivery Address'),
        content: TextField(
          controller: editController,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'House/Street, Area, Bahawalpur',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (editController.text.trim().isNotEmpty) {
                setState(() {
                  deliveryAddress = editController.text.trim();
                  deliveryLabel = 'Custom';
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton.icon(
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                    icon: const Icon(Icons.swap_horiz, size: 16, color: AppColors.primary),
                    label: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    onPressed: () => _showAddressPicker(context),
                  ),
                ],
              ),
              const SizedBox(height: 6),
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
                      child: const Icon(Icons.location_on, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(deliveryLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(
                            deliveryAddress,
                            style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                      onPressed: () => _showEditAddressDialog(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 1.5 Contact Information Card
              const Text('Contact Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Recipient Name *',
                        prefixIcon: Icon(Icons.person_outline, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter recipient name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone Number (For rider) *',
                        prefixIcon: Icon(Icons.phone_outlined, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a valid contact phone' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Delivery Instructions (Optional)',
                        hintText: 'e.g. Ring bell, leave with security guard',
                        prefixIcon: Icon(Icons.note_alt_outlined, size: 20),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(),
                      ),
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
                  const SizedBox(width: 8),
                  if (restaurant != null)
                    Expanded(
                      child: Text(
                        restaurant.name,
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

                    if (!formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete required contact details.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final restaurantId = cartItems.first.food.restaurantId;
                    final resObj = SampleData.getRestaurantById(restaurantId);
                    final restaurantName = resObj?.name ?? 'Restaurant';

                    final fullDeliveryInfo = '$deliveryAddress\nRecipient: ${_nameController.text.trim()} (${_phoneController.text.trim()})${_notesController.text.trim().isNotEmpty ? "\nNote: ${_notesController.text.trim()}" : ""}';

                    final order = OrderModel(
                      id: const Uuid().v4(),
                      restaurantId: restaurantId,
                      restaurantName: restaurantName,
                      restaurantImage: resObj?.image,
                      items: cartItems,
                      subtotal: subtotal,
                      deliveryFee: deliveryFee,
                      discount: calculatedDiscount,
                      total: total,
                      date: DateTime.now(),
                      status: OrderStatus.placed,
                      deliveryAddress: fullDeliveryInfo,
                      paymentMethod: paymentMethod,
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
