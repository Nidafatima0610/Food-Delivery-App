import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/food_card.dart';
import '../providers/app_providers.dart';
import 'restaurant_details.dart';
import 'food_details_screen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String query = '';
  String activeFilter = 'All'; // 'All', 'Restaurants', 'Dishes'

  final List<String> trendingKeywords = [
    'Biryani',
    'Pizza',
    'Burger',
    'Karahi',
    'Tikka',
    'BBQ',
    'Coffee',
    'Lava Cake',
    'Fries',
    'Chow Mein',
    'Pancakes',
    'Roll',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  void _performSearch(String term) {
    final trimmed = term.trim();
    if (trimmed.isNotEmpty) {
      ref.read(recentSearchesProvider.notifier).addSearch(trimmed);
    }
    _searchController.text = term;
    setState(() => query = term);
  }

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final recentSearches = ref.watch(recentSearchesProvider);

    // Search across names, cuisines, descriptions, categories, and tags
    final matchingRestaurants = q.isEmpty
        ? <Restaurant>[]
        : SampleData.restaurants.where((r) {
            return r.name.toLowerCase().contains(q) ||
                r.cuisine.toLowerCase().contains(q) ||
                r.description.toLowerCase().contains(q) ||
                r.area.toLowerCase().contains(q) ||
                r.address.toLowerCase().contains(q);
          }).toList();

    final matchingFoods = q.isEmpty
        ? <FoodItem>[]
        : SampleData.foods.where((f) {
            return f.name.toLowerCase().contains(q) ||
                f.description.toLowerCase().contains(q) ||
                f.category.toLowerCase().contains(q) ||
                f.tags.any((t) => t.toLowerCase().contains(q));
          }).toList();

    final totalResults = matchingRestaurants.length + matchingFoods.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search restaurants, biryani, burgers, bbq...',
            hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
            border: InputBorder.none,
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => query = '');
                    },
                  )
                : null,
          ),
          onChanged: (val) => setState(() => query = val),
          onSubmitted: (val) {
            if (val.trim().isNotEmpty) {
              ref.read(recentSearchesProvider.notifier).addSearch(val.trim());
            }
          },
        ),
      ),
      body: query.isEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Recent Searches (If Any)
                  if (recentSearches.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(recentSearchesProvider.notifier).clearSearches();
                          },
                          child: const Text('Clear All', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: recentSearches.map((search) {
                        return InputChip(
                          avatar: const Icon(Icons.history, size: 16, color: Colors.grey),
                          label: Text(search),
                          backgroundColor: AppColors.white,
                          side: BorderSide(color: Colors.grey.shade300),
                          labelStyle: const TextStyle(color: AppColors.textDark, fontSize: 13),
                          onDeleted: () {
                            ref.read(recentSearchesProvider.notifier).removeSearch(search);
                          },
                          onPressed: () => _performSearch(search),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 2. Trending Keywords
                  const Text('Trending Searches', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trendingKeywords.map((keyword) {
                      return ActionChip(
                        avatar: const Icon(Icons.trending_up, size: 16, color: AppColors.primary),
                        label: Text(keyword),
                        backgroundColor: AppColors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        labelStyle: const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500, fontSize: 13),
                        onPressed: () => _performSearch(keyword),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // 3. Popular Cuisines
                  const Text('Popular Cuisines in Bahawalpur', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: SampleData.categories.where((c) => c != 'All').map((cat) {
                      return FilterChip(
                        label: Text(cat),
                        backgroundColor: AppColors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        labelStyle: const TextStyle(fontSize: 13),
                        onSelected: (_) => _performSearch(cat),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : totalResults == 0
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No results found for "$query"',
                          style: AppStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Check your spelling or try searching for "Biryani", "Pizza", "Burger", "Karahi", "BBQ" or "Coffee".',
                          style: AppStyles.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Filter Chips (All, Restaurants, Dishes)
                    Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: Text('All ($totalResults)'),
                              selected: activeFilter == 'All',
                              onSelected: (_) => setState(() => activeFilter = 'All'),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: activeFilter == 'All' ? Colors.white : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text('Restaurants (${matchingRestaurants.length})'),
                              selected: activeFilter == 'Restaurants',
                              onSelected: (_) => setState(() => activeFilter = 'Restaurants'),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: activeFilter == 'Restaurants' ? Colors.white : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: Text('Dishes (${matchingFoods.length})'),
                              selected: activeFilter == 'Dishes',
                              onSelected: (_) => setState(() => activeFilter = 'Dishes'),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: activeFilter == 'Dishes' ? Colors.white : AppColors.textDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if ((activeFilter == 'All' || activeFilter == 'Restaurants') &&
                              matchingRestaurants.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Restaurants (${matchingRestaurants.length})',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...matchingRestaurants.map((res) => RestaurantCard(
                                  restaurant: res,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RestaurantDetailsScreen(restaurant: res),
                                      ),
                                    );
                                  },
                                )),
                            const SizedBox(height: 12),
                          ],
                          if ((activeFilter == 'All' || activeFilter == 'Dishes') &&
                              matchingFoods.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Dishes (${matchingFoods.length})',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ...matchingFoods.map((food) => FoodCard(
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
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
