import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class FoodDetailsScreen extends ConsumerStatefulWidget {
  final FoodItem food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  ConsumerState<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  int quantity = 1;
  final List<String> selectedAddons = [];
  final addons = ['Extra Cheese', 'Extra Sauce', 'Bacon'];

  void toggleAddon(String addon) {
    setState(() {
      if (selectedAddons.contains(addon)) {
        selectedAddons.remove(addon);
      } else {
        selectedAddons.add(addon);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = (widget.food.price + (selectedAddons.length * 1.0)) * quantity;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(widget.food.image, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, e, s) => Container(height: 200, color: Colors.grey))),
            const SizedBox(height: 16),
            Text(widget.food.name, style: AppStyles.title),
            Text('\$${widget.food.price}', style: TextStyle(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.food.description, style: AppStyles.body),
            const SizedBox(height: 24),
            const Text('Add-ons (+1.00 each)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...addons.map((a) => CheckboxListTile(
              title: Text(a),
              value: selectedAddons.contains(a),
              onChanged: (val) => toggleAddon(a),
            )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline, size: 32), onPressed: () => setState(() => quantity > 1 ? quantity-- : null)),
                Text('$quantity', style: const TextStyle(fontSize: 24)),
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 32), onPressed: () => setState(() => quantity++)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  final cartNotifier = ref.read(cartProvider.notifier);
                  final item = CartItem(food: widget.food, quantity: quantity, customizations: selectedAddons);
                  if (!cartNotifier.canAddItem(widget.food.restaurantId)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Replace Cart Item?'),
                        content: const Text('Your cart contains items from a different restaurant. Do you want to discard them and add this item?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartNotifier.replaceCart(item);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!')));
                            },
                            child: const Text('Replace'),
                          ),
                        ],
                      ),
                    );
                  } else {
                     cartNotifier.addItem(item);
                     Navigator.pop(context);
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!')));
                  }
                },
                child: Text('Add to Cart - \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      )
    );
  }
}
