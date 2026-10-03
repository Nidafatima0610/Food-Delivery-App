import 'cart_item.dart';

enum OrderStatus { placed, confirmed, preparing, outForDelivery, delivered }

class OrderModel {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImage;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final DateTime date;
  final OrderStatus status;
  final String deliveryAddress;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.restaurantId,
    this.restaurantName = 'Restaurant',
    this.restaurantImage,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.date,
    required this.status,
    this.deliveryAddress = '123 Model Town, Bahawalpur',
    this.paymentMethod = 'Cash on Delivery',
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'restaurantId': restaurantId, 'restaurantName': restaurantName,
    'restaurantImage': restaurantImage,
    'items': items.map((i) => i.toJson()).toList(),
    'subtotal': subtotal, 'deliveryFee': deliveryFee, 'discount': discount, 'total': total,
    'date': date.toIso8601String(), 'status': status.index,
    'deliveryAddress': deliveryAddress, 'paymentMethod': paymentMethod,
  };

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'], restaurantId: json['restaurantId'],
    restaurantName: json['restaurantName'] ?? 'Restaurant',
    restaurantImage: json['restaurantImage'],
    items: (json['items'] as List).map((i) => CartItem.fromJson(i)).toList(),
    subtotal: (json['subtotal'] ?? 0.0).toDouble(), deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(), discount: (json['discount'] ?? 0.0).toDouble(), total: (json['total'] ?? 0.0).toDouble(),
    date: DateTime.parse(json['date']), status: OrderStatus.values[json['status']],
    deliveryAddress: json['deliveryAddress'] ?? '123 Model Town, Bahawalpur',
    paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
  );
}
