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
