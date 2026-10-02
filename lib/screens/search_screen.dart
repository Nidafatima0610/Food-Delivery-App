import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../widgets/restaurant_card.dart';
import 'restaurant_details.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  
  @override
  Widget build(BuildContext context) {
    final results = SampleData.restaurants.where((r) => r.name.toLowerCase().contains(query.toLowerCase()) || r.cuisine.toLowerCase().contains(query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search restaurants, cuisines...',
            border: InputBorder.none,
          ),
          onChanged: (val) => setState(() => query = val),
        ),
      ),
      body: query.isEmpty
          ? const Center(child: Text('Type to search', style: AppStyles.body))
          : results.isEmpty
              ? const Center(child: Text('No results found', style: AppStyles.body))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return RestaurantCard(
                      restaurant: results[index],
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => RestaurantDetailsScreen(restaurant: results[index])));
                      },
                    );
                  },
                ),
    );
  }
}
