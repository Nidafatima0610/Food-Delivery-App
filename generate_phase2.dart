import 'dart:io';

void main() {
  final baseDir = r'c:\Users\umair\Desktop\food_delivery_app\lib';

  final files = {
    'models/address.dart': r'''
class Address {
  final String id;
  final String label;
  final String addressLine;
  final String contactNumber;
  final String instructions;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.addressLine,
    required this.contactNumber,
    this.instructions = '',
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'addressLine': addressLine,
    'contactNumber': contactNumber,
    'instructions': instructions,
    'isDefault': isDefault,
  };

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'],
    label: json['label'],
    addressLine: json['addressLine'],
    contactNumber: json['contactNumber'],
    instructions: json['instructions'] ?? '',
    isDefault: json['isDefault'] ?? false,
  );
}
''',
    'models/coupon.dart': r'''
class Coupon {
  final String code;
  final double discountValue;
  final bool isPercentage;
  final double minOrderAmount;

  Coupon({
    required this.code,
    required this.discountValue,
    required this.isPercentage,
    required this.minOrderAmount,
  });
}
''',
    'core/sample_data.dart': r'''
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../models/coupon.dart';

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
    'All', 'Burgers', 'Pizza', 'Fast Food', 'Chinese', 'Healthy', 'Desserts', 'Drinks'
  ];

  static final List<Coupon> coupons = [
    Coupon(code: 'WELCOME10', discountValue: 10, isPercentage: true, minOrderAmount: 20),
    Coupon(code: 'FLAT5', discountValue: 5, isPercentage: false, minOrderAmount: 15),
  ];
}
''',
    'services/storage_service.dart': r'''
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences prefs;

  StorageService(this.prefs);

  List<String> getFavorites() {
    return prefs.getStringList('favorites') ?? [];
  }

  Future<void> saveFavorites(List<String> favorites) async {
    await prefs.setStringList('favorites', favorites);
  }

  String? getString(String key) => prefs.getString(key);
  Future<void> setString(String key, String value) => prefs.setString(key, value);
  
  List<String> getStringList(String key) => prefs.getStringList(key) ?? [];
  Future<void> setStringList(String key, List<String> value) => prefs.setStringList(key, value);

  bool getBool(String key, {bool defaultValue = false}) => prefs.getBool(key) ?? defaultValue;
  Future<void> setBool(String key, bool value) => prefs.setBool(key, value);
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

// Ensure this is initialized in main.dart
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

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
  CartState build() => CartState(items: []);

  bool canAddItem(String resId) {
    if (state.items.isEmpty) return true;
    return state.restaurantId == resId;
  }

  void addItem(CartItem item) {
    if (!canAddItem(item.food.restaurantId)) {
      // Must be handled by UI dialog to call replaceCart
      return;
    }
    
    final index = state.items.indexWhere((i) => i.food.id == item.food.id);
    List<CartItem> newItems = List.from(state.items);
    if (index >= 0) {
      newItems[index].quantity += item.quantity;
    } else {
      newItems.add(item);
    }
    state = state.copyWith(items: newItems, restaurantId: item.food.restaurantId);
  }

  void replaceCart(CartItem item) {
    state = CartState(items: [item], restaurantId: item.food.restaurantId);
  }

  void removeItem(String foodId) {
    List<CartItem> newItems = state.items.where((item) => item.food.id != foodId).toList();
    state = state.copyWith(
      items: newItems, 
      restaurantId: newItems.isEmpty ? null : state.restaurantId
    );
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
  }

  void clear() {
    state = CartState(items: []);
  }

  double get subtotal => state.items.fold(0.0, (sum, item) => sum + item.totalPrice);
}

final cartProvider = NotifierProvider<CartNotifier, CartState>(() => CartNotifier());

class OrdersNotifier extends Notifier<List<OrderModel>> {
  @override
  List<OrderModel> build() => [];

  void addOrder(OrderModel order) {
    state = [order, ...state];
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<OrderModel>>(() => OrdersNotifier());

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
    'screens/home_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = selectedCategory == 'All' 
        ? SampleData.restaurants 
        : SampleData.restaurants.where((r) => r.cuisine == selectedCategory).toList();

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
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textLight),
                      SizedBox(width: 8),
                      Text('Search restaurants, food...', style: TextStyle(color: AppColors.textLight)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Free Delivery!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('On your first order across the app.', style: TextStyle(color: Colors.white70)),
                  ],
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
                    final cat = SampleData.categories[index];
                    final isSelected = selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(selectedCategory == 'All' ? 'Popular Restaurants' : '$selectedCategory Restaurants', style: AppStyles.title.copyWith(fontSize: 22)),
              const SizedBox(height: 16),
              if (filteredRestaurants.isEmpty)
                 const Center(child: Padding(
                   padding: EdgeInsets.all(32.0),
                   child: Text('No restaurants found in this category.'),
                 ))
              else
                ...filteredRestaurants.map((restaurant) => RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: restaurant)));
                  },
                )),
            ],
          ),
        ),
      ),
    );
  }
}
''',
    'screens/search_screen.dart': r'''
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  
  @override
  Widget build(BuildContext context) {
    final results = SampleData.restaurants.where((r) => r.name.toLowerCase().contains(query.toLowerCase()) || r.cuisine.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search restaurants, cuisines...',
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => query = val),
        ),
      ),
      body: query.isEmpty
          ? const Center(child: Text('Type to search', style: AppStyles.body))
          : results.isEmpty
              ? const Center(child: Text('No results found', style: AppStyles.body))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return RestaurantCard(
                      restaurant: results[index],
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: results[index])));
                      },
                    );
                  },
                ),
    );
  }
}
''',
    'screens/cart_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'checkout_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.items;
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final deliveryFee = cartItems.isNotEmpty ? 2.99 : 0.0;
    final total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              child: const Text('Clear', style: TextStyle(color: AppColors.primary)),
            )
        ],
      ),
      backgroundColor: AppColors.background,
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty', style: AppStyles.subtitle))
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
                        subtitle: Text('\$${item.food.price}'),
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
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text('\$${subtotal.toStringAsFixed(2)}')
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Fee'),
                          Text('\$${deliveryFee.toStringAsFixed(2)}')
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary))
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
''',
    'screens/checkout_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import '../models/order.dart';
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
    
    // Calculate percentage discount for WELCOME10
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
                  child: TextField(
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
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()), (route) => false);
                },
                child: Text('Place Order • \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
''',
    'screens/main_navigation.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoritesScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartItemsCount = ref.watch(cartProvider).items.length;

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
          const BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
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
                      child: Text('$cartItemsCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                    onTap: () {},
                    onAdd: () {
                      final cartNotifier = ref.read(cartProvider.notifier);
                      if (!cartNotifier.canAddItem(food.restaurantId)) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Start new cart?'),
                            content: const Text('Your cart contains items from another restaurant. Do you want to clear the cart and add this item?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  cartNotifier.replaceCart(CartItem(food: food));
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${food.name} added to new cart')));
                                },
                                child: const Text('Replace', style: TextStyle(color: Colors.red)),
                              )
                            ],
                          )
                        );
                      } else {
                        cartNotifier.addItem(CartItem(food: food));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${food.name} added to cart')));
                      }
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
''',
    'screens/favorites_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final favRestaurants = SampleData.restaurants.where((r) => favIds.contains(r.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: favRestaurants.isEmpty
          ? const Center(child: Text('No favorites yet', style: AppStyles.subtitle))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favRestaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: favRestaurants[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: favRestaurants[index])));
                  },
                );
              },
            ),
    );
  }
}
''',
    'main.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants.dart';
import 'providers/app_providers.dart';
import 'screens/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const FoodDeliveryApp(),
    ),
  );
}

class FoodDeliveryApp extends ConsumerWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;

    return MaterialApp(
      title: 'Food Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: isDark ? Colors.grey[900] : AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
''',
    'screens/profile_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;
    final notifications = settings['notifications'] ?? true;

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
'''
  };

  files.forEach((path, content) {
    final file = File('$baseDir\\$path');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  });
}
