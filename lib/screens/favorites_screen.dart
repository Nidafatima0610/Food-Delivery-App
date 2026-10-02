import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoritesProvider);
    final favRestaurants = SampleData.restaurants.where((r) => favIds.contains(r.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: favRestaurants.isEmpty
          ? const Center(child: Text('No favorites yet', style: AppStyles.subtitle))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favRestaurants.length,
              itemBuilder: (context, index) {
                return RestaurantCard(
                  restaurant: favRestaurants[index],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: favRestaurants[index])));
                  },
                );
              },
            ),
    );
  }
}
