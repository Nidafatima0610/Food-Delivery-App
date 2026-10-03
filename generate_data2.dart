import 'dart:io';

void main() {
  final restaurantsData = [
    ['r1', 'Spice Route', 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500', 'Pakistani'],
    ['r2', 'Urban Bites', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500', 'Fast Food'],
    ['r3', 'Karachi Grill', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=500', 'BBQ'],
    ['r4', 'The Pizza House', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500', 'Pizza'],
    ['r5', 'Burger District', 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500', 'Burgers'],
    ['r6', 'Royal BBQ', 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=500', 'BBQ'],
    ['r7', 'Desi Kitchen', 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?w=500', 'Pakistani'],
    ['r8', 'China Bowl', 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500', 'Chinese'],
    ['r9', 'Sweet Cravings', 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500', 'Desserts'],
    ['r10', 'Street Food Co.', 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500', 'Snacks'],
    ['r11', 'Green Garden', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500', 'Healthy'],
    ['r12', 'Coffee & Co.', 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500', 'Drinks'],
    ['r13', 'Food Junction', 'https://images.unsplash.com/photo-1610440042657-612c34d95e9f?w=500', 'Fast Food'],
    ['r14', 'Lahore Tikka', 'https://images.unsplash.com/photo-1599487405270-864f134591a2?w=500', 'BBQ'],
    ['r15', 'Daily Dine', 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=500', 'Breakfast'],
  ];

  final foodTemplates = {
    'Pakistani': ['Chicken Biryani', 'Beef Biryani', 'Chicken Karahi', 'Mutton Nihari', 'Haleem', 'Chapli Kabab', 'Seekh Kabab', 'Naan'],
    'Fast Food': ['Zinger Burger', 'Beef Burger', 'Loaded Fries', 'Chicken Wrap', 'Club Sandwich', 'Fried Chicken', 'Chicken Nuggets', 'Onion Rings'],
    'BBQ': ['Chicken Tikka', 'Beef Boti', 'Malai Boti', 'Seekh Kabab', 'Mutton Ribs', 'Bihari Kabab', 'Reshmi Kabab', 'Fish Tikka'],
    'Pizza': ['Cheese Pizza', 'Pepperoni Pizza', 'Chicken Fajita Pizza', 'BBQ Chicken Pizza', 'Veggie Supreme Pizza', 'Margherita Pizza', 'Meat Lovers Pizza', 'Hawaiian Pizza'],
    'Burgers': ['Classic Beef Burger', 'Cheeseburger', 'Double Decker', 'Chicken Fillet Burger', 'Mushroom Swiss Burger', 'Spicy Jalapeno Burger', 'Veggie Burger', 'BBQ Bacon Burger'],
    'Chinese': ['Chow Mein', 'Chicken Fried Rice', 'Spring Rolls', 'Sweet and Sour Chicken', 'Kung Pao Chicken', 'Manchurian', 'Egg Drop Soup', 'Dumplings'],
    'Desserts': ['Chocolate Cake', 'Brownie', 'Ice Cream Sundae', 'Cheesecake', 'Gulab Jamun', 'Rasmalai', 'Fruit Trifle', 'Lava Cake'],
    'Snacks': ['Samosa', 'Pakora', 'Fries', 'Nachos', 'Chicken Wings', 'Garlic Bread', 'Mozzarella Sticks', 'Chaat'],
    'Healthy': ['Grilled Chicken Salad', 'Quinoa Bowl', 'Fruit Salad', 'Avocado Toast', 'Green Smoothie', 'Oatmeal', 'Vegetable Stir Fry', 'Baked Salmon'],
    'Drinks': ['Milkshake', 'Cold Coffee', 'Fresh Juice', 'Lemonade', 'Iced Tea', 'Cappuccino', 'Lassi', 'Mint Margarita'],
    'Breakfast': ['Pancakes', 'Omelette', 'Waffles', 'French Toast', 'Halwa Puri', 'Aloo Paratha', 'Scrambled Eggs', 'Hash Browns'],
  };

  final foodImages = {
    'Pakistani': 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?w=500',
    'Fast Food': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
    'BBQ': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=500',
    'Pizza': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
    'Burgers': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500',
    'Chinese': 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500',
    'Desserts': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500',
    'Snacks': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500',
    'Healthy': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=500',
    'Drinks': 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=500',
    'Breakfast': 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=500',
  };

  var out = """import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../models/coupon.dart';

class SampleData {
  static final List<String> categories = [
    'All', 'Pizza', 'Burgers', 'Pakistani', 'BBQ', 'Chinese', 'Fast Food', 'Desserts', 'Drinks', 'Breakfast', 'Healthy', 'Snacks'
  ];

  static final List<Restaurant> restaurants = [
""";

  for (var r in restaurantsData) {
    out += '''    Restaurant(
      id: '${r[0]}',
      name: '${r[1]}',
      image: '${r[2]}',
      cuisine: '${r[3]}',
      rating: 4.5,
      reviewCount: 150,
      deliveryTime: '20-40 min',
      deliveryFee: 2.99,
      minimumOrder: 10.0,
      distance: 2.5,
      featured: true,
      isOpen: true,
    ),
''';
  }
  out += "  ];\n\n  static final List<FoodItem> foods = [\n";

  int fId = 1;
  for (var r in restaurantsData) {
    var items = foodTemplates[r[3]] ?? foodTemplates['Fast Food']!;
    var img = foodImages[r[3]] ?? foodImages['Fast Food']!;
    for (int i = 0; i < items.length; i++) {
      double price = 5.99 + i;
      out += '''    FoodItem(
      id: 'f$fId',
      restaurantId: '${r[0]}',
      name: '${items[i]}',
      description: 'Delicious ${items[i]}',
      image: '$img',
      price: $price,
      category: '${r[3]}',
      rating: 4.6,
      popular: ${i < 3},
      available: true,
    ),
''';
      fId++;
    }
  }

  out += """  ];

  static final List<Coupon> coupons = [
    Coupon(code: 'WELCOME10', discountValue: 10, isPercentage: true, minOrderAmount: 20),
    Coupon(code: 'FLAT5', discountValue: 5, isPercentage: false, minOrderAmount: 15),
  ];
}
""";

  File(r"c:\\Users\\umair\\Desktop\\food_delivery_app\\lib\\core\\sample_data.dart").writeAsStringSync(out);
  print("done");
}
