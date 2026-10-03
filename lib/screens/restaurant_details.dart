import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/food_card.dart';
import '../widgets/app_image.dart';
import '../providers/app_providers.dart';
import 'food_details_screen.dart';
import 'cart_screen.dart';

class RestaurantDetailsScreen extends ConsumerStatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  ConsumerState<RestaurantDetailsScreen> createState() => _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends ConsumerState<RestaurantDetailsScreen> {
  String selectedMenuCategory = 'All';

  void _addFoodDirectlyToCart(FoodItem food) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final item = CartItem(food: food, quantity: 1);

    if (!cartNotifier.canAddItem(food.restaurantId)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace Cart Item?'),
          content: const Text(
            'Your cart already contains items from another restaurant. Do you want to clear the cart and add this item?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cartNotifier.replaceCart(item);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added ${food.name} to cart!'),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 2),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${food.name} to cart!'),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;
    final allFoods = SampleData.foods.where((f) => f.restaurantId == restaurant.id).toList();
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);
    final cartState = ref.watch(cartProvider);
    final isCurrentRestaurantInCart = cartState.restaurantId == restaurant.id && cartState.items.isNotEmpty;

    // Distinct menu categories for this restaurant
    final menuCategories = ['All', ...{...allFoods.map((f) => f.category)}];

    final filteredFoods = selectedMenuCategory == 'All'
        ? allFoods
        : allFoods.where((f) => f.category == selectedMenuCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withValues(alpha: 0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.textDark, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppColors.textDark,
                      size: 20,
                    ),
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppImage(
                    imageUrl: restaurant.image,
                    category: restaurant.cuisine,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: AppStyles.title.copyWith(fontSize: 22),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: restaurant.isOpen ? Colors.green.shade50 : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: restaurant.isOpen ? Colors.green.shade300 : Colors.red.shade300,
                          ),
                        ),
                        child: Text(
                          restaurant.isOpen ? 'OPEN NOW' : 'CLOSED',
                          style: TextStyle(
                            color: restaurant.isOpen ? Colors.green.shade800 : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    restaurant.description,
                    style: AppStyles.body.copyWith(fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(Icons.star_rounded, '${restaurant.rating}', '${restaurant.reviewCount} reviews', Colors.amber),
                      _buildInfoColumn(Icons.schedule, restaurant.deliveryTime, 'Delivery Time', Colors.blue),
                      _buildInfoColumn(
                        Icons.delivery_dining,
                        restaurant.deliveryFee == 0 ? 'Free' : '\$${restaurant.deliveryFee.toStringAsFixed(2)}',
                        'Delivery Fee',
                        Colors.green,
                      ),
                      _buildInfoColumn(
                        Icons.shopping_bag_outlined,
                        '\$${restaurant.minimumOrder.toStringAsFixed(0)}',
                        'Min Order',
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Menu Categories', style: AppStyles.title.copyWith(fontSize: 17)),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: menuCategories.length,
                      itemBuilder: (context, index) {
                        final cat = menuCategories[index];
                        final isSelected = selectedMenuCategory == cat;
                        return GestureDetector(
                          onTap: () => setState(() => selectedMenuCategory = cat),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textDark,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final food = filteredFoods[index];
                  return FoodCard(
                    food: food,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)),
                      );
                    },
                    onAdd: () => _addFoodDirectlyToCart(food),
                  );
                },
                childCount: filteredFoods.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 70)),
        ],
      ),
      bottomSheet: isCurrentRestaurantInCart
          ? Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cartState.items.fold(0, (sum, i) => sum + i.quantity)} Items in Cart',
                            style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                          ),
                          Text(
                            '\$${ref.watch(cartProvider.notifier).subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                      child: const Row(
                        children: [
                          Text('View Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoColumn(IconData icon, String value, String label, Color iconColor) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
