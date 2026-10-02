import os

base_dir = r"c:\Users\umair\Desktop\food_delivery_app\lib"

files = {
    "models/restaurant.dart": """
class Restaurant {
  final String id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final double distance;
  final bool featured;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.distance,
    this.featured = false,
    this.isOpen = true,
  });
}
""",
    "models/food_item.dart": """
class FoodItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String image;
  final double price;
  final String category;
  final double rating;
  final bool popular;
  final bool available;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    this.popular = false,
    this.available = true,
  });
}
""",
    "models/cart_item.dart": """
import 'food_item.dart';

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });
  
  double get totalPrice => food.price * quantity;
}
""",
    "models/order.dart": """
import 'cart_item.dart';

enum OrderStatus { placed, confirmed, preparing, outForDelivery, delivered }

class OrderModel {
  final String id;
  final String restaurantId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final DateTime date;
  final OrderStatus status;

  OrderModel({
    required this.id,
    required this.restaurantId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.date,
    required this.status,
  });
}
""",
    "core/constants.dart": """
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF4B3A);
  static const background = Color(0xFFF2F2F2);
  static const textDark = Color(0xFF333333);
  static const textLight = Color(0xFF8E8E93);
  static const white = Colors.white;
  static const black = Colors.black;
}

class AppStyles {
  static const title = TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark);
  static const subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark);
  static const body = TextStyle(fontSize: 14, color: AppColors.textLight);
}
""",
    "core/sample_data.dart": """
import '../models/restaurant.dart';
import '../models/food_item.dart';

class SampleData {
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Burger King',
      image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500',
      cuisine: 'Fast Food',
      rating: 4.5,
      reviewCount: 120,
      deliveryTime: '20-30 min',
      deliveryFee: 2.99,
      minimumOrder: 10.0,
      distance: 1.2,
      featured: true,
    ),
    Restaurant(
      id: 'r2',
      name: 'Pizza Hut',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
      cuisine: 'Italian',
      rating: 4.2,
      reviewCount: 85,
      deliveryTime: '30-40 min',
      deliveryFee: 3.99,
      minimumOrder: 15.0,
      distance: 2.5,
    ),
    Restaurant(
      id: 'r3',
      name: 'Spice of India',
      image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500',
      cuisine: 'Indian',
      rating: 4.8,
      reviewCount: 200,
      deliveryTime: '40-50 min',
      deliveryFee: 0.0,
      minimumOrder: 20.0,
      distance: 3.1,
      featured: true,
    )
  ];

  static final List<FoodItem> foods = [
    FoodItem(
      id: 'f1',
      restaurantId: 'r1',
      name: 'Whopper',
      description: 'Classic flame-grilled beef burger',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      price: 6.99,
      category: 'Burgers',
      rating: 4.6,
      popular: true,
    ),
    FoodItem(
      id: 'f2',
      restaurantId: 'r1',
      name: 'Fries',
      description: 'Crispy golden fries',
      image: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=500',
      price: 2.99,
      category: 'Fast Food',
      rating: 4.2,
    ),
    FoodItem(
      id: 'f3',
      restaurantId: 'r2',
      name: 'Pepperoni Pizza',
      description: 'Large pizza with pepperoni and extra cheese',
      image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500',
      price: 14.99,
      category: 'Pizza',
      rating: 4.7,
      popular: true,
    ),
  ];

  static final List<String> categories = [
    'Burgers', 'Pizza', 'Fast Food', 'Chinese', 'Healthy', 'Desserts', 'Drinks'
  ];
}
""",
    "providers/app_providers.dart": """
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    if (state.isNotEmpty && state.first.food.restaurantId != item.food.restaurantId) {
      // For now, clear cart if different restaurant
      state = [item];
    } else {
      final index = state.indexWhere((i) => i.food.id == item.food.id);
      if (index >= 0) {
        state[index].quantity += item.quantity;
        state = [...state];
      } else {
        state = [...state, item];
      }
    }
  }

  void removeItem(String foodId) {
    state = state.where((item) => item.food.id != foodId).toList();
  }
  
  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    state = state.map((item) {
      if (item.food.id == foodId) {
        item.quantity = quantity;
      }
      return item;
    }).toList();
  }

  void clear() {
    state = [];
  }

  double get subtotal => state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<OrderModel>>((ref) => OrdersNotifier());

class OrdersNotifier extends StateNotifier<List<OrderModel>> {
  OrdersNotifier() : super([]);

  void addOrder(OrderModel order) {
    state = [order, ...state];
  }
}
""",
    "widgets/restaurant_card.dart": """
import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../core/constants.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({Key? key, required this.restaurant, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(restaurant.image, height: 180, width: double.infinity, fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.broken_image)),),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: AppStyles.subtitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(' (${restaurant.reviewCount}) • ${restaurant.cuisine}', style: AppStyles.body),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(restaurant.deliveryTime, style: AppStyles.body),
                      const SizedBox(width: 16),
                      const Icon(Icons.delivery_dining, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('\\$${restaurant.deliveryFee}', style: AppStyles.body),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
""",
    "widgets/food_card.dart": """
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../core/constants.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const FoodCard({Key? key, required this.food, required this.onTap, required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(food.image, height: 80, width: 80, fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(height: 80, width: 80, color: Colors.grey[300], child: const Icon(Icons.fastfood)),),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: AppStyles.subtitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(food.description, style: AppStyles.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text('\\$${food.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                ],
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 32),
            )
          ],
        ),
      ),
    );
  }
}
""",
    "screens/home_screen.dart": """
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deliver to', style: AppStyles.body),
                      Row(
                        children: [
                          Text('Home, 123 Main St', style: AppStyles.subtitle),
                          Icon(Icons.keyboard_arrow_down, color: AppColors.primary)
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search restaurants, food...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: AppColors.textLight),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Categories', style: AppStyles.title.copyWith(fontSize: 22)),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SampleData.categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: index == 0 ? AppColors.primary : AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        SampleData.categories[index],
                        style: TextStyle(
                          color: index == 0 ? AppColors.white : AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text('Popular Restaurants', style: AppStyles.title.copyWith(fontSize: 22)),
              const SizedBox(height: 16),
              ...SampleData.restaurants.map((restaurant) => RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: restaurant)));
                },
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
""",
    "screens/restaurant_details.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/food_card.dart';
import '../providers/app_providers.dart';

class RestaurantDetailsScreen extends ConsumerWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = SampleData.foods.where((f) => f.restaurantId == restaurant.id).toList();

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
                      const Icon(Icons.favorite_border)
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${restaurant.rating} • ${restaurant.reviewCount} Reviews • ${restaurant.cuisine}', style: AppStyles.body),
                  const SizedBox(height: 24),
                  Text('Menu', style: AppStyles.title.copyWith(fontSize: 22)),
                  const SizedBox(height: 16),
                  ...foods.map((food) => FoodCard(
                    food: food,
                    onTap: () {},
                    onAdd: () {
                      ref.read(cartProvider.notifier).addItem(CartItem(food: food));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${food.name} added to cart')));
                    },
                  )).toList()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
""",
    "screens/cart_screen.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final deliveryFee = cartItems.isNotEmpty ? 2.99 : 0.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item.food.image, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(width: 50, height: 50, color: Colors.grey)),
                        ),
                        title: Text(item.food.name),
                        subtitle: Text('\\$${item.food.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(item.food.id, item.quantity - 1);
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                ref.read(cartProvider.notifier).updateQuantity(item.food.id, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text('\\$${subtotal.toStringAsFixed(2)}')
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Fee'),
                          Text('\\$${deliveryFee.toStringAsFixed(2)}')
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('\\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary))
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                          },
                          child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
""",
    "screens/checkout_screen.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import '../models/order.dart';
import 'package:uuid/uuid.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final deliveryFee = cartItems.isNotEmpty ? 2.99 : 0.0;
    final total = subtotal + deliveryFee;

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
                  Expanded(child: Text('**** **** **** 1234')),
                  Icon(Icons.edit, color: AppColors.textLight)
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
                  final order = OrderModel(
                    id: const Uuid().v4(),
                    restaurantId: cartItems.first.food.restaurantId,
                    items: cartItems,
                    subtotal: subtotal,
                    deliveryFee: deliveryFee,
                    discount: 0.0,
                    total: total,
                    date: DateTime.now(),
                    status: OrderStatus.placed,
                  );
                  ref.read(ordersProvider.notifier).addOrder(order);
                  ref.read(cartProvider.notifier).clear();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()), (route) => false);
                },
                child: Text('Place Order • \\$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
""",
    "screens/order_success_screen.dart": """
import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'main_navigation.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 24),
            const Text('Order Placed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Your food is on the way', style: TextStyle(color: AppColors.textLight, fontSize: 16)),
            const SizedBox(height: 48),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavigation()), (route) => false);
              },
              child: const Text('Back to Home', style: const TextStyle(color: AppColors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
""",
    "screens/orders_screen.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({Key? key}) : super(key: key);

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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order #\${order.id.substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('\\$${order.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('\${order.items.length} items', style: const TextStyle(color: AppColors.textLight)),
                        const SizedBox(height: 8),
                        Text('Status: \${order.status.name.toUpperCase()}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
""",
    "screens/profile_screen.dart": """
import 'package:flutter/material.dart';
import '../core/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const Center(child: Text('john.doe@example.com', style: TextStyle(color: AppColors.textLight))),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Delivery Addresses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Payment Methods'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
""",
    "screens/main_navigation.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Explore (Coming Soon)')),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartItemsCount = ref.watch(cartProvider).length;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart),
                if (cartItemsCount > 0)
                  Positioned(
                    right: -5,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('\$cartItemsCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  )
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
""",
    "main.dart": """
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const ProviderScope(child: FoodDeliveryApp()));
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const MainNavigation(),
    );
  }
}
"""
}

for path, content in files.items():
    full_path = os.path.join(base_dir, path)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content.strip() + "\\n")

print("Files generated successfully.")
