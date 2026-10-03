import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class RestaurantListScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  final String? title;

  const RestaurantListScreen({
    super.key,
    this.initialCategory,
    this.title,
  });

  @override
  ConsumerState<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  late String selectedCategory;
  String sortBy = 'rating'; // 'rating', 'time', 'fee'

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? 'All';
  }

  List<Restaurant> _getSortedAndFilteredRestaurants() {
    List<Restaurant> list = List<Restaurant>.from(SampleData.getRestaurantsForCategory(selectedCategory));

    switch (sortBy) {
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'time':
        list.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'fee':
        list.sort((a, b) => a.deliveryFee.compareTo(b.deliveryFee));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = _getSortedAndFilteredRestaurants();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.title ?? (selectedCategory == 'All' ? 'All Restaurants' : '$selectedCategory Spots'),
          style: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: SampleData.categories.length,
                    itemBuilder: (context, index) {
                      final cat = SampleData.categories[index];
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${restaurants.length} restaurants found',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Sort: ', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                          DropdownButton<String>(
                            value: sortBy,
                            underline: const SizedBox(),
                            isDense: true,
                            style: const TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.bold),
                            items: const [
                              DropdownMenuItem(value: 'rating', child: Text('Top Rated')),
                              DropdownMenuItem(value: 'time', child: Text('Nearest')),
                              DropdownMenuItem(value: 'fee', child: Text('Lowest Fee')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => sortBy = val);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: restaurants.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No restaurants found for "$selectedCategory"',
                            style: AppStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try selecting "All" or browse another category.',
                            style: AppStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => setState(() => selectedCategory = 'All'),
                            child: const Text('Show All Restaurants', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
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
          ),
        ],
      ),
    );
  }
}
