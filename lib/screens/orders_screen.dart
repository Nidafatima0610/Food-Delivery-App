import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../providers/app_providers.dart';
import '../widgets/app_image.dart';
import 'order_tracking_screen.dart';
import 'restaurant_list_screen.dart';
import 'cart_screen.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  String _formatStatus(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.confirmed:
        return Colors.teal;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.outForDelivery:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }

  void _reorder(BuildContext context, WidgetRef ref, OrderModel order) {
    final cartNotifier = ref.read(cartProvider.notifier);

    if (order.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items available in this order.')),
      );
      return;
    }

    final firstItem = order.items.first;

    if (!cartNotifier.canAddItem(firstItem.food.restaurantId)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Replace Cart?'),
          content: Text(
            'Your cart currently contains items from another restaurant. Would you like to clear the cart and reorder from ${order.restaurantName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                cartNotifier.clear();
                for (var item in order.items) {
                  cartNotifier.addItem(CartItem(
                    food: item.food,
                    quantity: item.quantity,
                    customizations: item.customizations,
                  ));
                }
                Navigator.pop(ctx);
                _showReorderSuccess(context);
              },
              child: const Text('Replace & Reorder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      for (var item in order.items) {
        cartNotifier.addItem(CartItem(
          food: item.food,
          quantity: item.quantity,
          customizations: item.customizations,
        ));
      }
      _showReorderSuccess(context);
    }
  }

  void _showReorderSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Meal items added to cart!'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
      ),
      backgroundColor: AppColors.background,
      body: orders.isEmpty
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.receipt_long_outlined, size: 76, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    const Text('No orders yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover restaurants and order your favorite food.',
                      style: AppStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.explore_outlined, color: Colors.white),
                      label: const Text(
                        'Browse Restaurants',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RestaurantListScreen(title: 'All Restaurants'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final statusColor = _getStatusColor(order.status);
                final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(order.date);
                final restaurant = SampleData.getRestaurantById(order.restaurantId);
                final imageUrl = order.restaurantImage ?? restaurant?.image ?? '';
                final totalItemsCount = order.items.fold<int>(0, (sum, i) => sum + i.quantity);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant image + Name + Total
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AppImage(
                                  imageUrl: imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  category: restaurant?.cuisine,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.restaurantName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text('•', style: TextStyle(color: Colors.grey)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$totalItemsCount ${totalItemsCount == 1 ? 'item' : 'items'}',
                                          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                AppFormatters.currency(order.total),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Text(
                            formattedDate,
                            style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                          ),

                          const SizedBox(height: 10),

                          // Items List Summary
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              order.items.map((i) => '${i.quantity}x ${i.food.name}').join(', '),
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Status Pill & Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatStatus(order.status),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () => _reorder(context, ref, order),
                                    child: const Text('Reorder', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
                                      );
                                    },
                                    child: const Text('Details', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
