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
  
  double get totalPrice =>
      (food.price + (customizations.where((c) => !c.startsWith('Spice:') && !c.startsWith('Note:')).length * 50.0)) * quantity;

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
