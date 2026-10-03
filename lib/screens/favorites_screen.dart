import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../providers/app_providers.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/food_card.dart';
import 'restaurant_details.dart';
import 'food_details_screen.dart';
import 'restaurant_list_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  void _addFoodDirectlyToCart(FoodItem food) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final item = CartItem(food: food, quantity: 1);

    if (!cartNotifier.canAddItem(food.restaurantId)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Replace Cart Items?'),
          content: const Text(
            'Your cart already contains items from another restaurant. Do you want to clear the cart and add this dish?',
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favIds = ref.watch(favoritesProvider);
    final favRestaurants = SampleData.restaurants.where((r) => favIds.contains(r.id)).toList();
    final favFoods = SampleData.foods.where((f) => favIds.contains(f.id)).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Favorites',
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.white,
          elevation: 0.5,
          iconTheme: const IconThemeData(color: AppColors.textDark),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'Restaurants (${favRestaurants.length})'),
              Tab(text: 'Dishes (${favFoods.length})'),
            ],
          ),
        ),
        backgroundColor: AppColors.background,
        body: TabBarView(
          children: [
            // Tab 1: Restaurants
            favRestaurants.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.favorite_border, size: 68, color: AppColors.primary),
                          ),
                          const SizedBox(height: 20),
                          const Text('No favorite restaurants yet', style: AppStyles.title),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap the heart icon on any restaurant card to save your favorite spots in Bahawalpur.',
                            style: AppStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RestaurantListScreen(title: 'All Restaurants'),
                                ),
                              );
                            },
                            child: const Text('Explore Restaurants', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favRestaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = favRestaurants[index];
                      return RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
                            ),
                          );
                        },
                      );
                    },
                  ),

            // Tab 2: Dishes
            favFoods.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.lunch_dining_outlined, size: 68, color: AppColors.primary),
                          ),
                          const SizedBox(height: 20),
                          const Text('No favorite dishes yet', style: AppStyles.title),
                          const SizedBox(height: 8),
                          const Text(
                            'Save your favorite Biryanis, Pizzas, Burgers, and Desserts for quick ordering.',
                            style: AppStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RestaurantListScreen(title: 'All Restaurants'),
                                ),
                              );
                            },
                            child: const Text('Discover Dishes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favFoods.length,
                    itemBuilder: (context, index) {
                      final food = favFoods[index];
                      return FoodCard(
                        food: food,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FoodDetailsScreen(food: food),
                            ),
                          );
                        },
                        onAdd: () => _addFoodDirectlyToCart(food),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
