import 'dart:io';

void main() {
  final baseDir = r'c:\Users\umair\Desktop\food_delivery_app\lib';

  final files = {
    'screens/orders_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order #${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('${order.items.length} items', style: const TextStyle(color: AppColors.textLight)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Status: ${order.status.name.toUpperCase()}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                              ElevatedButton(
                                onPressed: () {
                                  final cartNotifier = ref.read(cartProvider.notifier);
                                  for (var item in order.items) {
                                    cartNotifier.addItem(item);
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reordered items added to cart')));
                                },
                                child: const Text('Reorder')
                              )
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
''',
    'screens/restaurant_details.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/food_card.dart';
import '../providers/app_providers.dart';
import 'food_details_screen.dart';

class RestaurantDetailsScreen extends ConsumerWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = SampleData.foods.where((f) => f.restaurantId == restaurant.id).toList();
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant.name),
              background: Image.network(restaurant.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name, style: AppStyles.title),
                      IconButton(
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${restaurant.rating} • ${restaurant.reviewCount} Reviews • ${restaurant.cuisine}', style: AppStyles.body),
                  const SizedBox(height: 24),
                  Text('Menu', style: AppStyles.title.copyWith(fontSize: 22)),
                  const SizedBox(height: 16),
                  ...foods.map((food) => FoodCard(
                    food: food,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)));
                    },
                    onAdd: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)));
                    },
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
'''
  };

  files.forEach((path, content) {
    final file = File('$baseDir\\$path');
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
  });
}
