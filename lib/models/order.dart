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
