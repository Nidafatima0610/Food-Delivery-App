import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/app_image.dart';
import '../providers/app_providers.dart';

class FoodDetailsScreen extends ConsumerStatefulWidget {
  final FoodItem food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  ConsumerState<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  int quantity = 1;
  String selectedSpiceLevel = 'Medium';
  final List<String> selectedAddons = [];
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void toggleAddon(String addon) {
    setState(() {
      if (selectedAddons.contains(addon)) {
        selectedAddons.remove(addon);
      } else {
        selectedAddons.add(addon);
      }
    });
  }

  List<String> _getAvailableAddons() {
    if (widget.food.addOns.isNotEmpty) {
      return widget.food.addOns;
    }
    // Generic fallback based on category
    final cat = widget.food.category.toLowerCase();
    if (cat.contains('pizza')) {
      return ['Extra Cheese', 'Stuffed Crust', 'Garlic Dip', 'Extra Jalapenos'];
    }
    if (cat.contains('burger')) {
      return ['Cheddar Cheese Slice', 'Double Patty', 'Crispy Onion Rings', 'Spicy Mayo'];
    }
    if (cat.contains('drink') || cat.contains('coffee')) {
      return ['Extra Espresso Shot', 'Vanilla Syrup', 'Oat Milk Swap', 'Whipped Cream'];
    }
    if (cat.contains('dessert')) {
      return ['Vanilla Ice Cream Scoop', 'Hot Fudge Drizzle', 'Extra Strawberries'];
    }
    return ['Extra Sauce', 'Salad & Raita', 'Extra Spicy', 'Side of Fries'];
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final restaurant = SampleData.getRestaurantById(food.restaurantId);
    final availableAddons = _getAvailableAddons();
    final cat = food.category.toLowerCase();
    final showSpiceOptions = cat.contains('biryani') ||
        cat.contains('pakistani') ||
        cat.contains('bbq') ||
        cat.contains('burger') ||
        cat.contains('fast food') ||
        cat.contains('chinese') ||
        cat.contains('snacks');
    final double itemBaseWithAddons = food.price + (selectedAddons.length * 50.0);
    final double total = itemBaseWithAddons * quantity;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          food.name,
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Food Image
            AppImage(
              imageUrl: food.image,
              height: 220,
              width: double.infinity,
              category: food.category,
              borderRadius: BorderRadius.circular(18),
            ),
            const SizedBox(height: 16),

            // Restaurant Name
            if (restaurant != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.storefront, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),

            // Food Name & Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    food.name,
                    style: AppStyles.title.copyWith(fontSize: 22),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 3),
                      Text(
                        food.rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        ' (${food.reviewCount})',
                        style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Price & Category
            Row(
              children: [
                Text(
                  AppFormatters.currency(food.price),
                  style: const TextStyle(fontSize: 22, color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    food.category,
                    style: const TextStyle(fontSize: 12, color: AppColors.textDark, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Description
            Text(
              food.description,
              style: AppStyles.body.copyWith(fontSize: 14, height: 1.5, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // Spice Level Section
            if (showSpiceOptions) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Spice Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                    child: const Text('Free', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: ['Mild', 'Medium', 'Hot / Spicy'].map((level) {
                  final isSelected = selectedSpiceLevel == level;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      onSelected: (_) => setState(() => selectedSpiceLevel = level),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              const Divider(),
            ],

            // Add-ons Section
            if (availableAddons.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Customizations & Add-ons',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+Rs. 50 each',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ...availableAddons.map((addon) {
                final isSelected = selectedAddons.contains(addon);
                return CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(addon, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  secondary: Text('+Rs. 50', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  activeColor: AppColors.primary,
                  value: isSelected,
                  onChanged: (val) => toggleAddon(addon),
                );
              }),
              const SizedBox(height: 12),
              const Divider(),
            ],

            // Special Instructions
            const SizedBox(height: 8),
            const Text('Special Instructions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g. Extra spicy, sauce on the side, no onions...',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),

            // Quantity Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 36, color: AppColors.primary),
                  onPressed: () => setState(() => quantity > 1 ? quantity-- : null),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 36, color: AppColors.primary),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
              onPressed: () {
                final cartNotifier = ref.read(cartProvider.notifier);
                final customs = [
                  if (showSpiceOptions) 'Spice: $selectedSpiceLevel',
                  ...selectedAddons,
                ];
                final item = CartItem(
                  food: widget.food,
                  quantity: quantity,
                  customizations: customs,
                );

                final messenger = ScaffoldMessenger.of(context);

                if (!cartNotifier.canAddItem(widget.food.restaurantId)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Replace Cart Items?'),
                      content: const Text(
                        'Your cart contains items from a different restaurant. Would you like to clear those and add this item?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartNotifier.replaceCart(item);
                            Navigator.pop(context); // dialog
                            Navigator.pop(context); // food details
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text('Added ${widget.food.name} to cart!'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          child: const Text('Replace', style: TextStyle(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  );
                } else {
                  cartNotifier.addItem(item);
                  Navigator.pop(context);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('Added ${widget.food.name} to cart!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              child: Text(
                'Add to Cart • ${AppFormatters.currency(total)}',
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
