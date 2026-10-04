import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../models/notification.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import 'cart_screen.dart';

class OrderTrackingScreen extends ConsumerWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  void _reorder(BuildContext context, WidgetRef ref, OrderModel currentOrder) {
    final cartNotifier = ref.read(cartProvider.notifier);

    if (currentOrder.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No items available in this order.')),
      );
      return;
    }

    // Availability verification per Requirement 21
    final availableItems = <CartItem>[];
    final unavailableNames = <String>[];

    for (var item in currentOrder.items) {
      final catalogFood = SampleData.foods.firstWhere(
        (f) => f.id == item.food.id,
        orElse: () => item.food,
      );
      if (catalogFood.isAvailable) {
        availableItems.add(CartItem(
          food: catalogFood,
          quantity: item.quantity,
          customizations: item.customizations,
        ));
      } else {
        unavailableNames.add(item.food.name);
      }
    }

    if (availableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('None of the items from this order are currently available in the kitchen catalog.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final firstItem = availableItems.first;

    if (!cartNotifier.canAddItem(firstItem.food.restaurantId)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Replace Cart?'),
          content: Text(
            'Your cart currently contains items from another restaurant. Would you like to clear the cart and reorder from ${currentOrder.restaurantName}?',
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
                for (var item in availableItems) {
                  cartNotifier.addItem(item);
                }
                Navigator.pop(ctx);
                _showSuccess(context, currentOrder, unavailableNames);
              },
              child: const Text('Replace & Reorder', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    } else {
      for (var item in availableItems) {
        cartNotifier.addItem(item);
      }
      _showSuccess(context, currentOrder, unavailableNames);
    }
  }

  void _showSuccess(BuildContext context, OrderModel currentOrder, List<String> unavailable) {
    if (unavailable.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${unavailable.join(", ")} is currently unavailable and was skipped.'),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Items from ${currentOrder.restaurantName} added to cart!'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _advanceStatus(BuildContext context, WidgetRef ref, OrderModel currentOrder) {
    OrderStatus nextStatus;
    String notifTitle;
    String notifMsg;

    switch (currentOrder.status) {
      case OrderStatus.placed:
        nextStatus = OrderStatus.confirmed;
        notifTitle = 'Order Confirmed!';
        notifMsg = '${currentOrder.restaurantName} confirmed your order #${currentOrder.id.length > 8 ? currentOrder.id.substring(0, 8) : currentOrder.id}.';
        break;
      case OrderStatus.confirmed:
        nextStatus = OrderStatus.preparing;
        notifTitle = 'Preparing Food in Kitchen';
        notifMsg = 'Chef is preparing your fresh meal with authentic ingredients.';
        break;
      case OrderStatus.preparing:
        nextStatus = OrderStatus.outForDelivery;
        notifTitle = 'Out for Delivery!';
        notifMsg = 'Rider has picked up your food package and is heading to your address.';
        break;
      case OrderStatus.outForDelivery:
        nextStatus = OrderStatus.delivered;
        notifTitle = 'Order Delivered!';
        notifMsg = 'Your order #${currentOrder.id.length > 8 ? currentOrder.id.substring(0, 8) : currentOrder.id} has arrived. Enjoy your meal!';
        break;
      case OrderStatus.delivered:
        nextStatus = OrderStatus.placed;
        notifTitle = 'Status Reset (Demo)';
        notifMsg = 'Order #${currentOrder.id.length > 8 ? currentOrder.id.substring(0, 8) : currentOrder.id} reset to Order Placed for evaluation.';
        break;
    }

    ref.read(ordersProvider.notifier).updateOrderStatus(currentOrder.id, nextStatus);
    ref.read(notificationsProvider.notifier).addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: notifTitle,
        message: notifMsg,
        date: DateTime.now(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order Status: ${_statusTitle(nextStatus)}'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _statusTitle(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing Food';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(ordersProvider);
    final currentOrder = allOrders.firstWhere((o) => o.id == order.id, orElse: () => order);
    final formattedDate = DateFormat('EEEE, MMM d, yyyy • h:mm a').format(currentOrder.date);
    final restaurant = SampleData.getRestaurantById(currentOrder.restaurantId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Details', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Card with Estimated Delivery and Restaurant Name
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated Delivery',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: currentOrder.status == OrderStatus.delivered
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: currentOrder.status == OrderStatus.delivered
                                ? Colors.green.shade300
                                : Colors.blue.shade300,
                          ),
                        ),
                        child: Text(
                          currentOrder.status == OrderStatus.delivered ? 'COMPLETED' : 'IN PROGRESS',
                          style: TextStyle(
                            color: currentOrder.status == OrderStatus.delivered ? Colors.green : Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentOrder.deliveryMethod.contains('Priority') ? '20 - 30 mins' : '30 - 45 mins',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          currentOrder.restaurantName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '#${currentOrder.id.length > 8 ? currentOrder.id.substring(0, 8) : currentOrder.id}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          formattedDate,
                          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Visual Status Timeline
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Order Status Timeline',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _statusTitle(currentOrder.status),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildTimelineItem('Order Placed', 'Order received and sent to kitchen', true),
                  _buildTimelineItem('Order Confirmed', 'The restaurant accepted your order', currentOrder.status.index >= 1),
                  _buildTimelineItem('Preparing Food', 'Chef is cooking your fresh meal in kitchen', currentOrder.status.index >= 2),
                  _buildTimelineItem('Out for Delivery', 'Rider is on the way to your doorstep', currentOrder.status.index >= 3),
                  _buildTimelineItem('Delivered', 'Order arrived at your doorstep. Enjoy!', currentOrder.status.index >= 4, isLast: true),

                  const SizedBox(height: 16),

                  // Demo Status Progression Controller (Requirement 20)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.science_outlined, size: 16, color: Colors.amber.shade900),
                            const SizedBox(width: 6),
                            Text(
                              'Demo Order Simulation',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.amber.shade900),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Simulate order progression milestones locally to verify timeline reactions.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentOrder.status == OrderStatus.delivered ? Colors.teal : AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: Icon(
                              currentOrder.status == OrderStatus.delivered ? Icons.restart_alt : Icons.fast_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              currentOrder.status == OrderStatus.delivered
                                  ? 'Reset Status (Demo Evaluation)'
                                  : 'Advance Next Milestone (Demo)',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            onPressed: () => _advanceStatus(context, ref, currentOrder),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 3. Delivery Details (Address, Method & Payment)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery & Payment Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              currentOrder.deliveryAddress.isNotEmpty ? currentOrder.deliveryAddress : (restaurant?.address ?? 'Model Town, Bahawalpur'),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.delivery_dining_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Delivery Option', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              currentOrder.deliveryMethod,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.payment_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(
                              currentOrder.paymentMethod,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Order Items Summary Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Food Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  ...currentOrder.items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                      Text(AppFormatters.currency(currentOrder.subtotal), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Delivery Fee', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
                      Text(
                        currentOrder.deliveryFee == 0 ? 'Free' : AppFormatters.currency(currentOrder.deliveryFee),
                        style: TextStyle(
                          color: currentOrder.deliveryFee == 0 ? Colors.green.shade700 : AppColors.textDark,
                          fontWeight: currentOrder.deliveryFee == 0 ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  if (currentOrder.discount > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discount Applied', style: TextStyle(color: Colors.green, fontSize: 13)),
                        Text(
                          '-${AppFormatters.currency(currentOrder.discount)}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total in PKR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        AppFormatters.currency(currentOrder.total),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5. Reorder Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                label: const Text(
                  'Reorder This Meal',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _reorder(context, ref, currentOrder),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 36, color: isDone ? Colors.green : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
                  color: isDone ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDone ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
