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

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = state.map((o) => o.id == orderId ? o.copyWith(status: status) : o).toList();
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

  void markAllAsRead() {
    state = state.map((n) => AppNotification(id: n.id, title: n.title, message: n.message, date: n.date, isRead: true)).toList();
    _save();
  }

  void clearAll() {
    state = [];
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
  static final List<Address> defaultAddresses = [
    Address(
      id: 'addr_home',
      label: 'Home',
      addressLine: 'House 14, Street 3, Model Town A, Bahawalpur',
      contactNumber: '+92 300 1234567',
      instructions: 'Ring doorbell twice. Leave on porch if unavailable.',
      isDefault: true,
    ),
    Address(
      id: 'addr_work',
      label: 'Office / Work',
      addressLine: 'Commercial Plaza, Aziz Bhatti Shaheed Road, Cantt, Bahawalpur',
      contactNumber: '+92 300 1234567',
      instructions: 'Deliver to 2nd floor reception.',
      isDefault: false,
    ),
    Address(
      id: 'addr_campus',
      label: 'University Campus',
      addressLine: 'Hostel 3, IUB Baghdad-ul-Jadeed Campus, University Road, Bahawalpur',
      contactNumber: '+92 300 1234567',
      instructions: 'Call upon arrival at the main security gate.',
      isDefault: false,
    ),
  ];

  @override
  List<Address> build() {
    final strList = ref.watch(storageServiceProvider).getStringList('addresses');
    if (strList.isEmpty) {
      return defaultAddresses;
    }
    return strList.map((e) => Address.fromJson(jsonDecode(e))).toList();
  }

  void addAddress(Address addr) {
    state = [
      ...state.map((a) => addr.isDefault
          ? Address(
              id: a.id,
              label: a.label,
              addressLine: a.addressLine,
              contactNumber: a.contactNumber,
              instructions: a.instructions,
              isDefault: false)
          : a),
      addr
    ];
    _save();
  }

  void removeAddress(String id) {
    state = state.where((a) => a.id != id).toList();
    if (state.isNotEmpty && !state.any((a) => a.isDefault)) {
      final first = state.first;
      state = [
        Address(
          id: first.id,
          label: first.label,
          addressLine: first.addressLine,
          contactNumber: first.contactNumber,
          instructions: first.instructions,
          isDefault: true,
        ),
        ...state.sublist(1),
      ];
    }
    _save();
  }

  void setDefault(String id) {
    state = state.map((a) => Address(
      id: a.id,
      label: a.label,
      addressLine: a.addressLine,
      contactNumber: a.contactNumber,
      instructions: a.instructions,
      isDefault: a.id == id,
    )).toList();
    _save();
  }

  void _save() {
    ref.read(storageServiceProvider).setStringList('addresses', state.map((e) => jsonEncode(e.toJson())).toList());
  }
}
final addressesProvider = NotifierProvider<AddressesNotifier, List<Address>>(() => AddressesNotifier());

class SettingsNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    final storage = ref.watch(storageServiceProvider);
    return {
      'notifications': storage.getBool('notifications', defaultValue: true),
      'darkMode': storage.getBool('darkMode', defaultValue: false),
      'language': storage.getString('language') ?? 'English',
      'preferredArea': storage.getString('preferredArea') ?? 'Model Town, Bahawalpur',
    };
  }

  void toggleSetting(String key) {
    final val = !(state[key] as bool? ?? false);
    state = {...state, key: val};
    ref.read(storageServiceProvider).setBool(key, val);
  }

  void setString(String key, String value) {
    state = {...state, key: value};
    ref.read(storageServiceProvider).setString(key, value);
  }

  void setPreferredArea(String area) {
    setString('preferredArea', area);
  }

  void setLanguage(String lang) {
    setString('language', lang);
  }
}
final settingsProvider = NotifierProvider<SettingsNotifier, Map<String, dynamic>>(() => SettingsNotifier());

class RecentSearchesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return ref.watch(storageServiceProvider).getStringList('recent_searches');
  }

  void addSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final updated = [trimmed, ...state.where((s) => s.toLowerCase() != trimmed.toLowerCase())].take(8).toList();
    state = updated;
    ref.read(storageServiceProvider).setStringList('recent_searches', updated);
  }

  void removeSearch(String query) {
    final updated = state.where((s) => s != query).toList();
    state = updated;
    ref.read(storageServiceProvider).setStringList('recent_searches', updated);
  }

  void clearSearches() {
    state = [];
    ref.read(storageServiceProvider).setStringList('recent_searches', []);
  }
}
final recentSearchesProvider = NotifierProvider<RecentSearchesNotifier, List<String>>(() => RecentSearchesNotifier());
