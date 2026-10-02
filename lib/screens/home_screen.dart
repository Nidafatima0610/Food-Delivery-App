import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';
import 'search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredRestaurants = selectedCategory == 'All' 
        ? SampleData.restaurants 
        : SampleData.restaurants.where((r) => r.cuisine == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deliver to', style: AppStyles.body),
                      Row(
                        children: [
                          Text('Home, 123 Main St', style: AppStyles.subtitle),
                          Icon(Icons.keyboard_arrow_down, color: AppColors.primary)
                        ],
                      )
                    ],
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textLight),
                      SizedBox(width: 8),
                      Text('Search restaurants, food...', style: TextStyle(color: AppColors.textLight)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Free Delivery!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('On your first order across the app.', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Categories', style: AppStyles.title.copyWith(fontSize: 22)),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: SampleData.categories.length,
                  itemBuilder: (context, index) {
                    final cat = SampleData.categories[index];
                    final isSelected = selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? AppColors.white : AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(selectedCategory == 'All' ? 'Popular Restaurants' : '$selectedCategory Restaurants', style: AppStyles.title.copyWith(fontSize: 22)),
              const SizedBox(height: 16),
              if (filteredRestaurants.isEmpty)
                 const Center(child: Padding(
                   padding: EdgeInsets.all(32.0),
                   child: Text('No restaurants found in this category.'),
                 ))
              else
                ...filteredRestaurants.map((restaurant) => RestaurantCard(
                  restaurant: restaurant,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: restaurant)));
                  },
                )),
            ],
          ),
        ),
      ),
    );
  }
}
