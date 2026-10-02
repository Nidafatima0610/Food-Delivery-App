import 'package:flutter/material.dart';
import '../models/order.dart';
import '../core/constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order', style: TextStyle(color: AppColors.textDark)), backgroundColor: AppColors.white, iconTheme: const IconThemeData(color: AppColors.textDark)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Order #${order.id.substring(0,8)}', style: AppStyles.title),
            const SizedBox(height: 32),
            _buildTimelineItem('Order Placed', true),
            _buildTimelineItem('Confirmed', order.status.index >= 1),
            _buildTimelineItem('Preparing', order.status.index >= 2),
            _buildTimelineItem('Out for Delivery', order.status.index >= 3),
            _buildTimelineItem('Delivered', order.status.index >= 4, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: isDone ? Colors.green : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: isDone ? FontWeight.bold : FontWeight.normal, color: isDone ? AppColors.textDark : AppColors.textLight)),
      ],
    );
  }
}
