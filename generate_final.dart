import 'dart:io';

void main() {
  final baseDir = r'c:\Users\umair\Desktop\food_delivery_app\lib';

  final files = {
    'models/restaurant.dart': r'''
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

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'image': image, 'cuisine': cuisine,
    'rating': rating, 'reviewCount': reviewCount, 'deliveryTime': deliveryTime,
    'deliveryFee': deliveryFee, 'minimumOrder': minimumOrder, 'distance': distance,
    'featured': featured, 'isOpen': isOpen,
  };

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'], name: json['name'], image: json['image'], cuisine: json['cuisine'],
    rating: (json['rating'] ?? 0.0).toDouble(), reviewCount: json['reviewCount'], deliveryTime: json['deliveryTime'],
    deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(), minimumOrder: (json['minimumOrder'] ?? 0.0).toDouble(), distance: (json['distance'] ?? 0.0).toDouble(),
    featured: json['featured'], isOpen: json['isOpen'],
  );
}
''',
    'models/food_item.dart': r'''
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

  Map<String, dynamic> toJson() => {
    'id': id, 'restaurantId': restaurantId, 'name': name, 'description': description,
    'image': image, 'price': price, 'category': category, 'rating': rating,
    'popular': popular, 'available': available,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'], restaurantId: json['restaurantId'], name: json['name'], description: json['description'],
    image: json['image'], price: (json['price'] ?? 0.0).toDouble(), category: json['category'], rating: (json['rating'] ?? 0.0).toDouble(),
    popular: json['popular'], available: json['available'],
  );
}
''',
    'models/cart_item.dart': r'''
import 'food_item.dart';

class CartItem {
  final FoodItem food;
  int quantity;
  final List<String> customizations;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.customizations = const [],
  });
  
  double get totalPrice => (food.price + (customizations.length * 1.0)) * quantity;

  Map<String, dynamic> toJson() => {
    'food': food.toJson(),
    'quantity': quantity,
    'customizations': customizations,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    food: FoodItem.fromJson(json['food']),
    quantity: json['quantity'],
    customizations: List<String>.from(json['customizations'] ?? []),
  );
}
''',
    'models/order.dart': r'''
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

  Map<String, dynamic> toJson() => {
    'id': id, 'restaurantId': restaurantId, 
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal': subtotal, 'deliveryFee': deliveryFee, 'discount': discount, 'total': total,
    'date': date.toIso8601String(), 'status': status.index,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'], restaurantId: json['restaurantId'],
    items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    subtotal: (json['subtotal'] ?? 0.0).toDouble(), deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(), discount: (json['discount'] ?? 0.0).toDouble(), total: (json['total'] ?? 0.0).toDouble(),
    date: DateTime.parse(json['date']), status: OrderStatus.values[json['status']],
  );
}
''',
    'models/notification.dart': r'''
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  AppNotification({required this.id, required this.title, required this.message, required this.date, this.isRead = false});

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'message': message, 'date': date.toIso8601String(), 'isRead': isRead,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'], title: json['title'], message: json['message'], date: DateTime.parse(json['date']), isRead: json['isRead'] ?? false,
  );
}
''',
    'providers/app_providers.dart': r'''
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/address.dart';
import '../services/storage_service.dart';
import '../models/notification.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.watch(sharedPreferencesProvider));
});

class CartState {
  final List<CartItem> items;
  final String? restaurantId;
  CartState({required this.items, this.restaurantId});
  CartState copyWith({List<CartItem>? items, String? restaurantId}) {
    return CartState(items: items ?? this.items, restaurantId: restaurantId ?? this.restaurantId);
  }
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() {
    final str = ref.watch(storageServiceProvider).getString('cart');
    if (str != null) {
      final List dec = jsonDecode(str);
      final items = dec.map((i) => CartItem.fromJson(i)).toList();
      if (items.isNotEmpty) {
        return CartState(items: items, restaurantId: items.first.food.restaurantId);
      }
    }
    return CartState(items: []);
  }

  void _save() {
    ref.read(storageServiceProvider).setString('cart', jsonEncode(state.items.map((i) => i.toJson()).toList()));
  }

  bool canAddItem(String resId) {
    if (state.items.isEmpty) return true;
    return state.restaurantId == resId;
  }

  void addItem(CartItem item) {
    if (!canAddItem(item.food.restaurantId)) return;
    
    final index = state.items.indexWhere((i) => i.food.id == item.food.id);
    List<CartItem> newItems = List.from(state.items);
    if (index >= 0) {
      newItems[index].quantity += item.quantity;
    } else {
      newItems.add(item);
    }
    state = state.copyWith(items: newItems, restaurantId: item.food.restaurantId);
    _save();
  }

  void replaceCart(CartItem item) {
    state = CartState(items: [item], restaurantId: item.food.restaurantId);
    _save();
  }

  void removeItem(String foodId) {
    List<CartItem> newItems = state.items.where((item) => item.food.id != foodId).toList();
    state = state.copyWith(
      items: newItems, 
      restaurantId: newItems.isEmpty ? null : state.restaurantId
    );
    _save();
  }
  
  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    List<CartItem> newItems = state.items.map((item) {
      if (item.food.id == foodId) {
        item.quantity = quantity;
      }
      return item;
    }).toList();
    state = state.copyWith(items: newItems);
    _save();
  }

  void clear() {
    state = CartState(items: []);
    _save();
  }

  double get subtotal => state.items.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() => CartNotifier());

class OrdersNotifier extends Notifier<List<OrderModel>> {
  @override
  List<OrderModel> build() {
    final strList = ref.watch(storageServiceProvider).getStringList('orders');
    return strList.map((e) => OrderModel.fromJson(jsonDecode(e))).toList();
  }

  void addOrder(OrderModel order) {
    state = [order, ...state];
    _save();
  }

  void _save() {
    ref.read(storageServiceProvider).setStringList('orders', state.map((e) => jsonEncode(e.toJson())).toList());
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<OrderModel>>(() => OrdersNotifier());

class NotificationsNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() {
    final strList = ref.watch(storageServiceProvider).getStringList('notifications');
    return strList.map((e) => AppNotification.fromJson(jsonDecode(e))).toList();
  }

  void addNotification(AppNotification notification) {
    state = [notification, ...state];
    _save();
  }

  void markAsRead(String id) {
    state = state.map((n) => n.id == id ? AppNotification(id: n.id, title: n.title, message: n.message, date: n.date, isRead: true) : n).toList();
    _save();
  }

  void _save() {
    ref.read(storageServiceProvider).setStringList('notifications', state.map((e) => jsonEncode(e.toJson())).toList());
  }
}
final notificationsProvider = NotifierProvider<NotificationsNotifier, List<AppNotification>>(() => NotificationsNotifier());

class FavoritesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.watch(storageServiceProvider).getFavorites();
  }

  void toggleFavorite(String id) {
    if (state.contains(id)) {
      state = state.where((e) => e != id).toList();
    } else {
      state = [...state, id];
    }
    ref.read(storageServiceProvider).saveFavorites(state);
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider = NotifierProvider<FavoritesNotifier, List<String>>(() => FavoritesNotifier());

class AddressesNotifier extends Notifier<List<Address>> {
  @override
  List<Address> build() {
    final strList = ref.watch(storageServiceProvider).getStringList('addresses');
    return strList.map((e) => Address.fromJson(jsonDecode(e))).toList();
  }

  void addAddress(Address addr) {
    state = [...state.map((a) => addr.isDefault ? Address(id: a.id, label: a.label, addressLine: a.addressLine, contactNumber: a.contactNumber, instructions: a.instructions, isDefault: false) : a), addr];
    _save();
  }

  void _save() {
    ref.read(storageServiceProvider).setStringList('addresses', state.map((e) => jsonEncode(e.toJson())).toList());
  }
}
final addressesProvider = NotifierProvider<AddressesNotifier, List<Address>>(() => AddressesNotifier());

class SettingsNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    final storage = ref.watch(storageServiceProvider);
    return {
      'notifications': storage.getBool('notifications', defaultValue: true),
      'darkMode': storage.getBool('darkMode', defaultValue: false),
    };
  }

  void toggleSetting(String key) {
    final val = !(state[key] ?? false);
    state = {...state, key: val};
    ref.read(storageServiceProvider).setBool(key, val);
  }
}
final settingsProvider = NotifierProvider<SettingsNotifier, Map<String, bool>>(() => SettingsNotifier());
''',
    'screens/notifications_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications', style: AppStyles.subtitle))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  title: Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(notif.message),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: notif.isRead ? Colors.transparent : Colors.blue.withOpacity(0.05),
                  onTap: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                  },
                );
              },
            ),
    );
  }
}
''',
    'screens/offers_screen.dart': r'''
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Deals', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: SampleData.coupons.length,
        itemBuilder: (context, index) {
          final coupon = SampleData.coupons[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.local_offer, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coupon.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(coupon.isPercentage ? '${coupon.discountValue}% off on your order' : '\$${coupon.discountValue} flat off on your order', style: AppStyles.body),
                        const SizedBox(height: 4),
                        Text('Min. order: \$${coupon.minOrderAmount}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
''',
    'screens/checkout_screen.dart': r'''
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
''',
    'screens/profile_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'offers_screen.dart';
import 'notifications_screen.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;
    final notifications = settings['notifications'] ?? true;
    final user = ref.watch(authProvider);
    final unreadNotifs = ref.watch(notificationsProvider).where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                if (unreadNotifs > 0)
                  Positioned(
                    right: -2, top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  )
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          )
        ],
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
          Center(child: Text(user?.name ?? 'Guest', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          Center(child: Text(user?.email ?? 'Please log in', style: const TextStyle(color: AppColors.textLight))),
          const SizedBox(height: 32),
          
          ListTile(
            leading: const Icon(Icons.local_offer_outlined),
            title: const Text('Offers & Deals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
            },
          ),
          const Divider(),
          const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).toggleSetting('darkMode');
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: notifications,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).toggleSetting('notifications');
            },
          ),
          const Divider(),
          if (user != null)
            TextButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16)),
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
