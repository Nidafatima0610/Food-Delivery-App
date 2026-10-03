import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../models/restaurant.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';
import 'search_screen.dart';

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
  String selectedArea = 'All Areas';
  String sortBy = 'rating'; // 'rating', 'time', 'fee'

  static const List<String> bahawalpurAreas = [
    'All Areas',
    'Model Town',
    'Cantt',
    'Circular Road',
    'Dubai Chowk',
    'Commercial Area',
    'Farid Gate',
    'University Road',
    'Satellite Town',
    'Islamia Colony',
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? 'All';
  }

  List<Restaurant> _getSortedAndFilteredRestaurants() {
    List<Restaurant> list = List<Restaurant>.from(SampleData.getRestaurantsForCategory(selectedCategory));

    if (selectedArea != 'All Areas') {
      list = list.where((r) =>
        r.area.toLowerCase().contains(selectedArea.toLowerCase()) ||
        r.address.toLowerCase().contains(selectedArea.toLowerCase())
      ).toList();
    }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textDark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                // 1. Food Categories
                SizedBox(
                  height: 36,
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
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textDark,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // 2. Bahawalpur Areas
                SizedBox(
                  height: 32,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: bahawalpurAreas.length,
                    itemBuilder: (context, index) {
                      final area = bahawalpurAreas[index];
                      final isSelected = selectedArea == area;
                      return GestureDetector(
                        onTap: () => setState(() => selectedArea = area),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.teal.shade700 : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? Colors.teal.shade700 : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (area != 'All Areas') ...[
                                Icon(Icons.place_outlined, size: 12, color: isSelected ? Colors.white : Colors.grey.shade600),
                                const SizedBox(width: 3),
                              ],
                              Text(
                                area,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textDark,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Count & Sorting Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${restaurants.length} spots in Bahawalpur',
                          style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w600),
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
                              DropdownMenuItem(value: 'rating', child: Text('Top Rated ★')),
                              DropdownMenuItem(value: 'time', child: Text('Nearest Distance')),
                              DropdownMenuItem(value: 'fee', child: Text('Lowest Delivery Fee')),
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
                            'No restaurants found in $selectedArea for "$selectedCategory"',
                            style: AppStyles.subtitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try clearing the locality or category filter to discover all spots.',
                            style: AppStyles.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: () => setState(() {
                              selectedCategory = 'All';
                              selectedArea = 'All Areas';
                            }),
                            child: const Text('Reset All Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
