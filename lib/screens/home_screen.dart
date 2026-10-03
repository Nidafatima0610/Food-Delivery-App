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
import 'restaurant_list_screen.dart';
import 'food_details_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'offers_screen.dart';
import 'cart_screen.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  String currentAddress = 'Home, Model Town A, Bahawalpur';

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  void _showAddressSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final savedAddresses = ref.watch(addressesProvider);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Choose Delivery Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (savedAddresses.isNotEmpty)
                  ...savedAddresses.map((a) {
                    final isSel = currentAddress.contains(a.addressLine);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on, color: isSel ? AppColors.primary : Colors.grey.shade700),
                      ),
                      title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Text(a.addressLine, style: const TextStyle(fontSize: 13, color: AppColors.textLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: isSel ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                      onTap: () {
                        setState(() {
                          currentAddress = '${a.label}, ${a.addressLine}';
                        });
                        Navigator.pop(context);
                      },
                    );
                  })
                else ...[
                  _buildAddressTile('Home', 'House 14, Model Town A, Bahawalpur', Icons.home_outlined),
                  const Divider(height: 1),
                  _buildAddressTile('Work / Office', 'Commercial Area, Cantt, Bahawalpur', Icons.work_outline),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddressTile(String label, String address, IconData icon) {
    final isSelected = currentAddress.contains(address);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey.shade700),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(address, style: const TextStyle(fontSize: 13, color: AppColors.textLight), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          currentAddress = '$label, $address';
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCravingItem(String label, String cat) {
    final isSelected = selectedCategory == cat;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? 'All' : cat;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza_outlined;
      case 'burgers':
        return Icons.lunch_dining_outlined;
      case 'pakistani':
        return Icons.soup_kitchen_outlined;
      case 'bbq':
        return Icons.outdoor_grill_outlined;
      case 'chinese':
        return Icons.ramen_dining_outlined;
      case 'fast food':
        return Icons.fastfood_outlined;
      case 'biryani':
        return Icons.rice_bowl_outlined;
      case 'desserts':
        return Icons.cake_outlined;
      case 'drinks':
        return Icons.local_cafe_outlined;
      case 'breakfast':
        return Icons.breakfast_dining_outlined;
      case 'healthy':
        return Icons.eco_outlined;
      case 'snacks':
        return Icons.cookie_outlined;
      case 'shawarma':
        return Icons.kebab_dining_outlined;
      case 'tea/coffee':
        return Icons.coffee_outlined;
      case 'bakery':
        return Icons.bakery_dining_outlined;
      case 'home kitchen':
        return Icons.house_outlined;
      default:
        return Icons.restaurant_outlined;
    }
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
            'Your cart already contains items from another restaurant. Would you like to clear the cart and add this item?',
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
    final unreadNotifs = ref.watch(notificationsProvider).where((n) => !n.isRead).length;
    final previousOrders = ref.watch(ordersProvider);
    final user = ref.watch(authProvider);

    // Filtered data based on selected category
    final categoryRestaurants = SampleData.getRestaurantsForCategory(selectedCategory);
    final categoryDishes = SampleData.getFoodsForCategory(selectedCategory);

    // Curated diverse section data from 25 unique restaurants
    final popularRestaurants = SampleData.getPopularRestaurants();
    final topRatedRestaurants = SampleData.getTopRatedRestaurants();
    final fastDeliveryRestaurants = SampleData.getFastDeliveryRestaurants();
    final dealRestaurants = SampleData.getDealRestaurants();
    final recommendedRestaurants = SampleData.getRecommendedRestaurants();
    final popularDishes = SampleData.getPopularDishes();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header / Location
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _showAddressSelector,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: AppColors.primary, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'DELIVER TO',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    currentAddress,
                                    style: AppStyles.subtitle.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.notifications_outlined, color: AppColors.textDark, size: 22),
                              ),
                              if (unreadNotifs > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '$unreadNotifs',
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                          },
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                          },
                          child: const CircleAvatar(
                            radius: 19,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 1.5 Dynamic Greeting & City Context
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_getGreeting()}, ${user?.name.split(' ').first ?? 'Foodie'} 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Craving something delicious in Bahawalpur today?',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppColors.primary, size: 22),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Search "Biryani", "Pizza", "Burger"...',
                            style: TextStyle(color: AppColors.textLight, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.tune, color: AppColors.textDark, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Promotional Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF4B3A), Color(0xFFFF7A59)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF4B3A).withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'PROMO CODE: WELCOME10',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Free Delivery & 10% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Tap to view all discount coupons & deals',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delivery_dining, color: Colors.white, size: 36),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 3.5 What are you craving?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'What are you craving?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    if (selectedCategory != 'All')
                      GestureDetector(
                        onTap: () => setState(() => selectedCategory = 'All'),
                        child: const Text(
                          'Show All',
                          style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCravingItem('🍔 Burgers', 'Burgers'),
                    _buildCravingItem('🍕 Pizza', 'Pizza'),
                    _buildCravingItem('🍗 BBQ', 'BBQ'),
                    _buildCravingItem('🍚 Biryani', 'Biryani'),
                    _buildCravingItem('🥤 Drinks', 'Drinks'),
                    _buildCravingItem('🍰 Desserts', 'Desserts'),
                    _buildCravingItem('🍲 Pakistani', 'Pakistani'),
                    _buildCravingItem('🌯 Shawarma', 'Shawarma'),
                    _buildCravingItem('🥢 Chinese', 'Chinese'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 4. Food Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Categories', style: AppStyles.title.copyWith(fontSize: 19)),
                    if (selectedCategory != 'All')
                      TextButton(
                        onPressed: () => setState(() => selectedCategory = 'All'),
                        child: const Text('Reset', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 44,
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
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getCategoryIcon(cat),
                              size: 18,
                              color: isSelected ? Colors.white : AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textDark,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // If a specific category is selected, show that category's filtered view immediately!
              if (selectedCategory != 'All') ...[
                const SizedBox(height: 22),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$selectedCategory Spots (${categoryRestaurants.length})',
                          style: AppStyles.title.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantListScreen(
                                initialCategory: selectedCategory,
                                title: '$selectedCategory Spots',
                              ),
                            ),
                          );
                        },
                        child: const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (categoryRestaurants.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text('No restaurants found for $selectedCategory', style: AppStyles.subtitle),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: categoryRestaurants.map((restaurant) => RestaurantCard(
                        restaurant: restaurant,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
                            ),
                          );
                        },
                      )).toList(),
                    ),
                  ),

                if (categoryDishes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Popular $selectedCategory Dishes',
                      style: AppStyles.title.copyWith(fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 185,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categoryDishes.length,
                      itemBuilder: (context, index) {
                        final food = categoryDishes[index];
                        return FoodHorizontalCard(
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
                  ),
                ],
              ] else ...[
                // DEFAULT CURATED HOME PAGE SECTIONS

                // Quick Order / Order Again (Only when previous orders exist!)
                if (previousOrders.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(Icons.history, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text('Order Again', style: AppStyles.title.copyWith(fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 145,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: previousOrders.take(4).length,
                      itemBuilder: (context, index) {
                        final order = previousOrders[index];
                        final dishNames = order.items.map((i) => '${i.quantity}x ${i.food.name}').join(', ');
                        return Container(
                          width: 290,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      order.restaurantName,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    AppFormatters.currency(order.total),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                                  ),
                                ],
                              ),
                              Text(
                                dishNames,
                                style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      final targetRes = SampleData.getRestaurantById(order.restaurantId);
                                      if (targetRes != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RestaurantDetailsScreen(restaurant: targetRes),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('View Menu', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: () {
                                      final cartNotifier = ref.read(cartProvider.notifier);
                                      for (var item in order.items) {
                                        cartNotifier.addItem(item);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Items from ${order.restaurantName} added to cart!'),
                                          backgroundColor: AppColors.primary,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const CartScreen()),
                                      );
                                    },
                                    child: const Text('Reorder', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // 5. Popular Restaurants
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Popular Near You',
                          style: AppStyles.title.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestaurantListScreen(title: 'Popular Restaurants'),
                            ),
                          );
                        },
                        child: const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: popularRestaurants.take(6).length,
                    itemBuilder: (context, index) {
                      final res = popularRestaurants[index];
                      return RestaurantHorizontalCard(
                        restaurant: res,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: res),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // 6. Top Rated Spots
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Top Rated Spots (4.7+ ★)',
                                style: AppStyles.title.copyWith(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestaurantListScreen(title: 'Top Rated Spots'),
                            ),
                          );
                        },
                        child: const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: topRatedRestaurants.take(6).length,
                    itemBuilder: (context, index) {
                      final res = topRatedRestaurants[index];
                      return RestaurantHorizontalCard(
                        restaurant: res,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: res),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // 7. Fast Delivery
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.bolt, color: Colors.deepOrange, size: 20),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Fast Delivery (< 25 mins)',
                                style: AppStyles.title.copyWith(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestaurantListScreen(title: 'Fast Delivery Spots'),
                            ),
                          );
                        },
                        child: const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: fastDeliveryRestaurants.take(6).length,
                    itemBuilder: (context, index) {
                      final res = fastDeliveryRestaurants[index];
                      return RestaurantHorizontalCard(
                        restaurant: res,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: res),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // 8. Today's Deals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.local_offer_outlined, color: AppColors.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Today's Deals & Discounts",
                                style: AppStyles.title.copyWith(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const OffersScreen(),
                            ),
                          );
                        },
                        child: const Text('All Offers', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 205,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dealRestaurants.take(6).length,
                    itemBuilder: (context, index) {
                      final res = dealRestaurants[index];
                      return RestaurantHorizontalCard(
                        restaurant: res,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailsScreen(restaurant: res),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // 9. Popular Dishes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Popular Dishes',
                          style: AppStyles.title.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(),
                            ),
                          );
                        },
                        child: const Text('Explore', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 195,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: popularDishes.take(8).length,
                    itemBuilder: (context, index) {
                      final food = popularDishes[index];
                      return FoodHorizontalCard(
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
                ),

                const SizedBox(height: 24),

                // 10. Offers / Deals Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'COUPONS AVAILABLE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Save up to Rs. 300 on Orders',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Use FEAST20, FLAT300, or FREESHIP coupons',
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.local_offer, color: Colors.amber, size: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 11. Recommended For You
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Recommended For You',
                          style: AppStyles.title.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RestaurantListScreen(title: 'All Restaurants'),
                            ),
                          );
                        },
                        child: const Text('See All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: recommendedRestaurants.map((restaurant) => RestaurantCard(
                      restaurant: restaurant,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
                          ),
                        );
                      },
                    )).toList(),
                  ),
                ),

                // 12. Bottom Full Catalog CTA Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RestaurantListScreen(title: 'All Restaurants'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.restaurant_menu, color: Colors.white),
                      label: Text(
                        'Browse All ${SampleData.restaurants.length} Restaurants',
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
