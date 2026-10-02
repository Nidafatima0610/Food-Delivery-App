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
  
  // Example: flat $1.00 per customization
  double get totalPrice => (food.price + (customizations.length * 1.0)) * quantity;
}
