import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/food_card.dart';
import '../providers/app_providers.dart';
import 'food_details_screen.dart';

class RestaurantDetailsScreen extends ConsumerWidget {
  final Restaurant restaurant;

  const RestaurantDetailsScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foods = SampleData.foods.where((f) => f.restaurantId == restaurant.id).toList();
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant.name),
              background: Image.network(restaurant.image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(restaurant.name, style: AppStyles.title),
                      IconButton(
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${restaurant.rating} • ${restaurant.reviewCount} Reviews • ${restaurant.cuisine}', style: AppStyles.body),
                  const SizedBox(height: 24),
                  Text('Menu', style: AppStyles.title.copyWith(fontSize: 22)),
                  const SizedBox(height: 16),
                  ...foods.map((food) => FoodCard(
                    food: food,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)));
                    },
                    onAdd: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => FoodDetailsScreen(food: food)));
                    },
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
