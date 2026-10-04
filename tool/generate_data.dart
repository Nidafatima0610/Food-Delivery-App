import 'dart:io';

void main() {
  final buffer = StringBuffer();

  buffer.writeln("import '../models/restaurant.dart';");
  buffer.writeln("import '../models/food_item.dart';");
  buffer.writeln("import '../models/coupon.dart';");
  buffer.writeln("");
  buffer.writeln("class SampleData {");
  buffer.writeln("  static final List<String> categories = [");
  buffer.writeln("    'All',");
  buffer.writeln("    'Biryani',");
  buffer.writeln("    'BBQ',");
  buffer.writeln("    'Burgers',");
  buffer.writeln("    'Pizza',");
  buffer.writeln("    'Pakistani',");
  buffer.writeln("    'Shawarma',");
  buffer.writeln("    'Chinese',");
  buffer.writeln("    'Fast Food',");
  buffer.writeln("    'Tea/Coffee',");
  buffer.writeln("    'Bakery',");
  buffer.writeln("    'Desserts',");
  buffer.writeln("    'Healthy',");
  buffer.writeln("    'Breakfast',");
  buffer.writeln("    'Home Kitchen',");
  buffer.writeln("    'Drinks',");
  buffer.writeln("  ];");
  buffer.writeln("");
  buffer.writeln("  static final List<Restaurant> restaurants = [");

  final restaurants = [
    {
      'id': 'r1',
      'name': 'Al-Noor Dum Biryani & Pulao',
      'image': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Biryani',
      'rating': 4.8,
      'reviewCount': 420,
      'deliveryTime': '20-30 min',
      'deliveryFee': 70.0,
      'minimumOrder': 400.0,
      'distance': 1.8,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': "Bahawalpur's famed aromatic Zafrani dum biryani, beef yakhni pulao, and spicy raita.",
      'address': 'Farid Gate Chowk, Bahawalpur',
      'area': 'Farid Gate',
      'offer': '15% OFF',
    },
    {
      'id': 'r2',
      'name': 'Sultani BBQ & Charcoal Grill',
      'image': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'BBQ',
      'rating': 4.9,
      'reviewCount': 530,
      'deliveryTime': '25-35 min',
      'deliveryFee': 99.0,
      'minimumOrder': 500.0,
      'distance': 2.3,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Sizzling reshmi kababs, charcoal chicken tikka boti, mutton chops, and tandoori parathas.',
      'address': 'Circular Road, Near Dring Stadium, Bahawalpur',
      'area': 'Circular Road',
      'offer': '20% OFF',
    },
    {
      'id': 'r3',
      'name': 'Grill Town Smashed Burgers',
      'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Burgers',
      'rating': 4.7,
      'reviewCount': 340,
      'deliveryTime': '15-25 min',
      'deliveryFee': 80.0,
      'minimumOrder': 450.0,
      'distance': 1.2,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Artisanal smashed beef patties, crunchy zinger stacks, melted cheddar, and secret signature dip.',
      'address': 'Aziz Bhatti Shaheed Road, Cantt, Bahawalpur',
      'area': 'Cantt',
      'offer': 'Rs. 100 OFF',
    },
    {
      'id': 'r4',
      'name': 'The Pizza Crust Studio',
      'image': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Pizza',
      'rating': 4.8,
      'reviewCount': 460,
      'deliveryTime': '25-35 min',
      'deliveryFee': 0.0,
      'minimumOrder': 600.0,
      'distance': 2.1,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Hand-tossed thin crust & stuffed crust pizzas smothered in creamy mozzarella and smoked meats.',
      'address': 'Main Commercial Area, Satellite Town, Bahawalpur',
      'area': 'Commercial Area',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r5',
      'name': 'Al-Madina Shawarma & Broast',
      'image': 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Shawarma',
      'rating': 4.6,
      'reviewCount': 310,
      'deliveryTime': '15-20 min',
      'deliveryFee': 50.0,
      'minimumOrder': 300.0,
      'distance': 1.1,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Authentic Syrian spiced chicken shawarma platters, garlic tahini wraps, and crispy quarter broast.',
      'address': 'Opposite IUB Gate 1, University Road, Bahawalpur',
      'area': 'University Road',
      'offer': 'Buy 1 Get 1',
    },
    {
      'id': 'r6',
      'name': 'Golden Dragon Chinese Bowl',
      'image': 'https://images.unsplash.com/photo-1552611052-33e04de081de?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Chinese',
      'rating': 4.7,
      'reviewCount': 290,
      'deliveryTime': '25-35 min',
      'deliveryFee': 90.0,
      'minimumOrder': 550.0,
      'distance': 2.8,
      'featured': true,
      'isPopular': false,
      'isOpen': true,
      'description': 'Fiery Chicken Manchurian, Kung Pao, egg fried rice, spring rolls, and wok-tossed chow mein.',
      'address': 'Block C, Model Town, Bahawalpur',
      'area': 'Model Town',
      'offer': '10% OFF',
    },
    {
      'id': 'r7',
      'name': 'Rooster Crispy Fried Chicken',
      'image': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Fast Food',
      'rating': 4.8,
      'reviewCount': 490,
      'deliveryTime': '15-25 min',
      'deliveryFee': 60.0,
      'minimumOrder': 400.0,
      'distance': 1.4,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Golden crunch fried chicken drumsticks, spicy popcorn nuggets, and loaded cheese curly fries.',
      'address': 'Dubai Chowk Commercial Hub, Bahawalpur',
      'area': 'Dubai Chowk',
      'offer': 'Rs. 150 OFF',
    },
    {
      'id': 'r8',
      'name': 'Chai Shai & Cafe Khana',
      'image': 'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Tea/Coffee',
      'rating': 4.9,
      'reviewCount': 380,
      'deliveryTime': '15-20 min',
      'deliveryFee': 50.0,
      'minimumOrder': 300.0,
      'distance': 1.5,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Karak Doodh Patti chai, Kashmiri pink tea, spiced parathas, Spanish lattes, and club sandwiches.',
      'address': 'Cantt Market, Near Officers Club, Bahawalpur',
      'area': 'Cantt',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r9',
      'name': 'Royal Sweets & Bakers',
      'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Bakery',
      'rating': 4.8,
      'reviewCount': 560,
      'deliveryTime': '15-25 min',
      'deliveryFee': 60.0,
      'minimumOrder': 350.0,
      'distance': 1.9,
      'featured': true,
      'isPopular': false,
      'isOpen': true,
      'description': 'Traditional Bahawalpuri Sohan Halwa, freshly baked pastries, dry fruit biscuits, and tea cakes.',
      'address': 'Shahi Bazaar, Farid Gate, Bahawalpur',
      'area': 'Farid Gate',
      'offer': '10% OFF',
    },
    {
      'id': 'r10',
      'name': 'Sweet Tooth Gelato & Waffles',
      'image': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Desserts',
      'rating': 4.9,
      'reviewCount': 430,
      'deliveryTime': '15-20 min',
      'deliveryFee': 70.0,
      'minimumOrder': 350.0,
      'distance': 1.6,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Belgian chocolate lava cakes, Nutella waffle sticks, gourmet sundae tubs, and Lotus milkshakes.',
      'address': 'Model Town A, Near Central Park, Bahawalpur',
      'area': 'Model Town',
      'offer': '15% OFF',
    },
    {
      'id': 'r11',
      'name': 'Green Leaf Fresh Bowls & Juices',
      'image': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Healthy',
      'rating': 4.7,
      'reviewCount': 220,
      'deliveryTime': '20-30 min',
      'deliveryFee': 80.0,
      'minimumOrder': 450.0,
      'distance': 2.4,
      'featured': false,
      'isPopular': false,
      'isOpen': true,
      'description': 'Protein power bowls, fresh Greek salads, beetroot cleanse juices, and cold-pressed citrus blends.',
      'address': 'Mall Road, Cantt, Bahawalpur',
      'area': 'Cantt',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r12',
      'name': 'Morning Glory Halwa Puri & Nashta',
      'image': 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Breakfast',
      'rating': 4.8,
      'reviewCount': 400,
      'deliveryTime': '15-25 min',
      'deliveryFee': 50.0,
      'minimumOrder': 300.0,
      'distance': 1.3,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Piping hot crispy puris, chana masala, sweet suji halwa, lassi, and Desi omelette parathas.',
      'address': 'Circular Road, Near Welcome Gate, Bahawalpur',
      'area': 'Circular Road',
      'offer': null,
    },
    {
      'id': 'r13',
      'name': "Mama's Secret Home Kitchen",
      'image': 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Home Kitchen',
      'rating': 4.9,
      'reviewCount': 350,
      'deliveryTime': '25-35 min',
      'deliveryFee': 60.0,
      'minimumOrder': 400.0,
      'distance': 1.7,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Pure home-style cooking: Daal Chawal thali, Palak Gosht, Aloo Keema, and tawa phulkas.',
      'address': 'Street 4, Islamia Colony, Bahawalpur',
      'area': 'Islamia Colony',
      'offer': 'Rs. 200 OFF',
    },
    {
      'id': 'r14',
      'name': 'Shinwari Dera & Karahi',
      'image': 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Pakistani',
      'rating': 4.8,
      'reviewCount': 620,
      'deliveryTime': '30-40 min',
      'deliveryFee': 120.0,
      'minimumOrder': 800.0,
      'distance': 3.5,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Authentic Namkeen Shinwari mutton karahi cooked in lamb fat with tomatoes and organic sea salt.',
      'address': 'Model Town C, Near Bypass, Bahawalpur',
      'area': 'Model Town',
      'offer': '20% OFF',
    },
    {
      'id': 'r15',
      'name': 'Karachi Student Biryani Hub',
      'image': 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Biryani',
      'rating': 4.6,
      'reviewCount': 470,
      'deliveryTime': '20-30 min',
      'deliveryFee': 70.0,
      'minimumOrder': 350.0,
      'distance': 2.0,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Spicy Karachi-style potato chicken biryani, zarda, mint raita, and shami kabab add-ons.',
      'address': 'Commercial Market, Satellite Town, Bahawalpur',
      'area': 'Satellite Town',
      'offer': '15% OFF',
    },
    {
      'id': 'r16',
      'name': 'Bahaar-e-Kabab Smokey BBQ',
      'image': 'https://images.unsplash.com/photo-1544025162-8111149c4398?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'BBQ',
      'rating': 4.7,
      'reviewCount': 290,
      'deliveryTime': '25-35 min',
      'deliveryFee': 90.0,
      'minimumOrder': 500.0,
      'distance': 2.2,
      'featured': false,
      'isPopular': false,
      'isOpen': true,
      'description': 'Mughlai beef gola kababs, chicken malai tikka, spicy seekh kababs, and khameeri kulchas.',
      'address': 'Old City, Near Farid Gate, Bahawalpur',
      'area': 'Farid Gate',
      'offer': 'Rs. 100 OFF',
    },
    {
      'id': 'r17',
      'name': 'Burger District 6',
      'image': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Burgers',
      'rating': 4.8,
      'reviewCount': 390,
      'deliveryTime': '15-25 min',
      'deliveryFee': 80.0,
      'minimumOrder': 450.0,
      'distance': 1.5,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Crispy fillet burgers, jalapeno beef melt, waffle potato fries, and loaded garlic mayo dips.',
      'address': 'Shop 12, Commercial Plaza, Bahawalpur',
      'area': 'Commercial Area',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r18',
      'name': 'Napoli Stone-Oven Pizza',
      'image': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Pizza',
      'rating': 4.9,
      'reviewCount': 410,
      'deliveryTime': '25-35 min',
      'deliveryFee': 99.0,
      'minimumOrder': 600.0,
      'distance': 2.6,
      'featured': true,
      'isPopular': false,
      'isOpen': true,
      'description': 'Neapolitan charred crust pizzas, buffalo mozzarella, fresh basil, pepperoni, and hot honey drizzle.',
      'address': 'Main Boulevard, Model Town B, Bahawalpur',
      'area': 'Model Town',
      'offer': '20% OFF',
    },
    {
      'id': 'r19',
      'name': 'Damascus Pita & Shawarma',
      'image': 'https://images.unsplash.com/photo-1561651823-34feb02250e4?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Shawarma',
      'rating': 4.7,
      'reviewCount': 320,
      'deliveryTime': '15-20 min',
      'deliveryFee': 50.0,
      'minimumOrder': 300.0,
      'distance': 1.3,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Levantine spiced chicken wraps, open hummus platters, crispy falafel boxes, and garlic toum.',
      'address': 'Ahmedpur East Road, Dubai Chowk, Bahawalpur',
      'area': 'Dubai Chowk',
      'offer': 'Buy 1 Get 1',
    },
    {
      'id': 'r20',
      'name': 'Mandarin Wok & Dimsum',
      'image': 'https://images.unsplash.com/photo-1541696432-82c6da8ce7bf?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Chinese',
      'rating': 4.6,
      'reviewCount': 240,
      'deliveryTime': '25-35 min',
      'deliveryFee': 100.0,
      'minimumOrder': 550.0,
      'distance': 3.1,
      'featured': false,
      'isPopular': false,
      'isOpen': true,
      'description': 'Steamed chicken dumplings, Szechuan crispy beef, hot & sour soup, and Singaporean rice noodles.',
      'address': 'Cantt Plaza, Main Cantt, Bahawalpur',
      'area': 'Cantt',
      'offer': '10% OFF',
    },
    {
      'id': 'r21',
      'name': 'The Crave Yard Fast Food',
      'image': 'https://images.unsplash.com/photo-1610440042657-612c34d95e9f?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Fast Food',
      'rating': 4.7,
      'reviewCount': 360,
      'deliveryTime': '15-25 min',
      'deliveryFee': 60.0,
      'minimumOrder': 400.0,
      'distance': 1.4,
      'featured': false,
      'isPopular': true,
      'isOpen': true,
      'description': 'Crispy chicken tenders, cheesy pizza fries, spicy chapli burgers, and frozen lime chillers.',
      'address': 'Near Baghdad-ul-Jadeed Campus, Bahawalpur',
      'area': 'University Road',
      'offer': 'Rs. 100 OFF',
    },
    {
      'id': 'r22',
      'name': 'Coffee Lounge & Roastery',
      'image': 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Tea/Coffee',
      'rating': 4.9,
      'reviewCount': 420,
      'deliveryTime': '15-20 min',
      'deliveryFee': 70.0,
      'minimumOrder': 350.0,
      'distance': 1.8,
      'featured': true,
      'isPopular': false,
      'isOpen': true,
      'description': 'Specialty espresso roasts, iced caramel macchiatos, cold brews, and buttery croissants.',
      'address': 'Sector A, Model Town, Bahawalpur',
      'area': 'Model Town',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r23',
      'name': "Bake O' Clock Artisan Patisserie",
      'image': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Bakery',
      'rating': 4.8,
      'reviewCount': 300,
      'deliveryTime': '20-30 min',
      'deliveryFee': 60.0,
      'minimumOrder': 350.0,
      'distance': 2.1,
      'featured': false,
      'isPopular': false,
      'isOpen': true,
      'description': 'Artisan sourdough loaves, red velvet cupcakes, lotus cheesecakes, and savory chicken patties.',
      'address': 'Block B, Satellite Town, Bahawalpur',
      'area': 'Satellite Town',
      'offer': 'Free Delivery',
    },
    {
      'id': 'r24',
      'name': 'Fit & Fine Healthy Kitchen',
      'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Healthy',
      'rating': 4.7,
      'reviewCount': 190,
      'deliveryTime': '20-30 min',
      'deliveryFee': 80.0,
      'minimumOrder': 450.0,
      'distance': 2.5,
      'featured': false,
      'isPopular': false,
      'isOpen': true,
      'description': 'Grilled lemon herb chicken breast, quinoa avocado salads, low-carb wraps, and detox shakes.',
      'address': 'Commercial Area Phase 1, Bahawalpur',
      'area': 'Commercial Area',
      'offer': '15% OFF',
    },
    {
      'id': 'r25',
      'name': 'Desi Dastarkhwan Handi & Karahi',
      'image': 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&w=600&q=80',
      'cuisine': 'Pakistani',
      'rating': 4.8,
      'reviewCount': 530,
      'deliveryTime': '25-35 min',
      'deliveryFee': 80.0,
      'minimumOrder': 500.0,
      'distance': 1.9,
      'featured': true,
      'isPopular': true,
      'isOpen': true,
      'description': 'Rich boneless chicken makhni handi, spicy mutton brain masala, daal mash fry, and garlic naan.',
      'address': 'Near Railway Station Road, Dubai Chowk, Bahawalpur',
      'area': 'Dubai Chowk',
      'offer': '25% OFF',
    },
  ];

  for (final r in restaurants) {
    buffer.writeln("    Restaurant(");
    buffer.writeln("      id: '${r['id']}',");
    buffer.writeln("      name: '${r['name'].toString().replaceAll("'", "\\'")}',");
    buffer.writeln("      image: '${r['image']}',");
    buffer.writeln("      cuisine: '${r['cuisine']}',");
    buffer.writeln("      rating: ${r['rating']},");
    buffer.writeln("      reviewCount: ${r['reviewCount']},");
    buffer.writeln("      deliveryTime: '${r['deliveryTime']}',");
    buffer.writeln("      deliveryFee: ${r['deliveryFee']},");
    buffer.writeln("      minimumOrder: ${r['minimumOrder']},");
    buffer.writeln("      distance: ${r['distance']},");
    buffer.writeln("      featured: ${r['featured']},");
    buffer.writeln("      isPopular: ${r['isPopular']},");
    buffer.writeln("      isOpen: ${r['isOpen']},");
    buffer.writeln("      description: '${r['description'].toString().replaceAll("'", "\\'")}',");
    buffer.writeln("      address: '${r['address'].toString().replaceAll("'", "\\'")}',");
    buffer.writeln("      area: '${r['area']}',");
    if (r['offer'] != null) {
      buffer.writeln("      offer: '${r['offer']}',");
    } else {
      buffer.writeln("      offer: null,");
    }
    buffer.writeln("    ),");
  }

  buffer.writeln("  ];");
  buffer.writeln("");
  buffer.writeln("  static final List<FoodItem> foods = [");

  // Foods per restaurant catalog (9-10 distinct authentic items per restaurant)
  final foods = [
    // r1: Al-Noor Dum Biryani & Pulao
    {
      'id': 'f1', 'res': 'r1', 'name': 'Special Chicken Dum Biryani',
      'desc': 'Fragrant aged basmati rice slow-cooked with spiced chicken, saffron milk, and fried onions.',
      'img': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600',
      'price': 480.0, 'cat': 'Biryani', 'rating': 4.9, 'pop': true,
      'addons': ['Extra Raita', 'Fresh Salad', 'Boiled Egg', 'Double Chicken Piece'],
      'tags': ['biryani', 'chicken', 'rice', 'dum', 'spicy', 'bestseller']
    },
    {
      'id': 'f2', 'res': 'r1', 'name': 'Beef Yakhni Pulao',
      'desc': 'Tender beef shank cuts infused with aromatic whole spice stock and aged basmati rice.',
      'img': 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?w=600',
      'price': 590.0, 'cat': 'Biryani', 'rating': 4.8, 'pop': true,
      'addons': ['Mint Chutney', 'Kachumber Salad', 'Shami Kabab'],
      'tags': ['pulao', 'beef', 'yakhni', 'rice', 'desi']
    },
    {
      'id': 'f3', 'res': 'r1', 'name': 'Zaffrani Mutton Biryani',
      'desc': 'Royal mutton dum biryani layered with golden caramelized onions, nuts, and saffron milk.',
      'img': 'https://images.unsplash.com/photo-1545247181-516773cae7be?w=600',
      'price': 890.0, 'cat': 'Biryani', 'rating': 4.9, 'pop': false,
      'addons': ['Zeera Raita', 'Extra Mutton Boti', 'Gulab Jamun'],
      'tags': ['biryani', 'mutton', 'zaffrani', 'rice', 'royal']
    },
    {
      'id': 'f4', 'res': 'r1', 'name': 'Shami Kabab (2 Pcs)',
      'desc': 'Pan-fried melt-in-mouth beef and lentils patties seasoned with fresh herbs and green chilies.',
      'img': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=600',
      'price': 220.0, 'cat': 'Pakistani', 'rating': 4.7, 'pop': false,
      'addons': ['Green Chutney', 'Pulao Raita'],
      'tags': ['kabab', 'shami', 'beef', 'snack', 'side']
    },
    {
      'id': 'f5', 'res': 'r1', 'name': 'Chicken Tikka Biryani',
      'desc': 'Smokey charcoal-grilled chicken tikka chunks layered over spicy aromatic biryani rice.',
      'img': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600',
      'price': 540.0, 'cat': 'Biryani', 'rating': 4.8, 'pop': true,
      'addons': ['Mint Raita', 'Extra Tikka Boti', 'Salad'],
      'tags': ['biryani', 'tikka', 'bbq', 'chicken', 'spicy']
    },
    {
      'id': 'f6', 'res': 'r1', 'name': 'Matka Dum Biryani (Spicy)',
      'desc': 'Piping hot earthen clay pot biryani cooked sealed with whole wheat dough crust.',
      'img': 'https://images.unsplash.com/photo-1589302168068-964664d93cb0?w=600',
      'price': 620.0, 'cat': 'Biryani', 'rating': 4.9, 'pop': true,
      'addons': ['Zeera Dahi', 'Spicy Green Chilies', 'Boiled Egg'],
      'tags': ['biryani', 'matka', 'spicy', 'chicken', 'special']
    },
    {
      'id': 'f7', 'res': 'r1', 'name': 'Aloo Chicken Pulao',
      'desc': 'Delicate, mildly spiced long grain rice with succulent bone-in chicken and soft potatoes.',
      'img': 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600',
      'price': 420.0, 'cat': 'Biryani', 'rating': 4.6, 'pop': false,
      'addons': ['Fresh Salad', 'Zeera Raita'],
      'tags': ['pulao', 'chicken', 'aloo', 'rice']
    },
    {
      'id': 'f8', 'res': 'r1', 'name': 'Zeera Raita & Salad Platter',
      'desc': 'Chilled creamy yogurt whipped with roasted cumin seeds, cucumber, tomatoes, and mint.',
      'img': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600',
      'price': 120.0, 'cat': 'Pakistani', 'rating': 4.7, 'pop': false,
      'addons': ['Extra Cucumber', 'Mint Dip'],
      'tags': ['raita', 'salad', 'yogurt', 'side']
    },
    {
      'id': 'f9', 'res': 'r1', 'name': 'Shahi Zarda with Khoya',
      'desc': 'Sweet fragrant saffron basmati rice topped with dry fruits, sweet gulab jamun, and khoya.',
      'img': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=600',
      'price': 280.0, 'cat': 'Desserts', 'rating': 4.8, 'pop': false,
      'addons': ['Extra Khoya', 'Almonds & Pistachios'],
      'tags': ['zarda', 'sweet', 'dessert', 'rice']
    },

    // r2: Sultani BBQ & Charcoal Grill
    {
      'id': 'f10', 'res': 'r2', 'name': 'Charcoal Chicken Tikka Boti',
      'desc': 'Boneless chicken cubes marinated in red spices, curd, ginger, and grilled over coal.',
      'img': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600',
      'price': 620.0, 'cat': 'BBQ', 'rating': 4.9, 'pop': true,
      'addons': ['Puri Paratha', 'Mint Dip', 'Fresh Lime Salad'],
      'tags': ['bbq', 'tikka', 'chicken', 'charcoal', 'bestseller']
    },
    {
      'id': 'f11', 'res': 'r2', 'name': 'Reshmi Seekh Kabab (4 Pcs)',
      'desc': 'Delicately spiced minced chicken blended with cream, coriander, and roasted over skewers.',
      'img': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=600',
      'price': 580.0, 'cat': 'BBQ', 'rating': 4.8, 'pop': true,
      'addons': ['Garlic Naan', 'Mint Chutney'],
      'tags': ['bbq', 'kabab', 'reshmi', 'chicken']
    },
    {
      'id': 'f12', 'res': 'r2', 'name': 'Mutton Chops Grill (4 Pcs)',
      'desc': 'Prime succulent mutton rib chops seasoned in raw papaya, black pepper, and smokey cumin.',
      'img': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=600',
      'price': 1350.0, 'cat': 'BBQ', 'rating': 4.9, 'pop': true,
      'addons': ['Roghni Naan', 'Imli Chutney', 'Grilled Tomatoes'],
      'tags': ['bbq', 'mutton', 'chops', 'grill', 'premium']
    },
    {
      'id': 'f13', 'res': 'r2', 'name': 'Malai Boti Platter',
      'desc': 'Silky white boneless chicken boti marinated in rich fresh cream, cheese, and white pepper.',
      'img': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600',
      'price': 690.0, 'cat': 'BBQ', 'rating': 4.9, 'pop': true,
      'addons': ['Paratha', 'Garlic Mayo', 'Green Raita'],
      'tags': ['bbq', 'malai', 'chicken', 'creamy']
    },
    {
      'id': 'f14', 'res': 'r2', 'name': 'Kasturi Chicken Boti',
      'desc': 'Golden grilled chicken chunks spiced with crushed kasuri methi and roasted spices.',
      'img': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600',
      'price': 650.0, 'cat': 'BBQ', 'rating': 4.7, 'pop': false,
      'addons': ['Tandoori Roti', 'Lemon Onions'],
      'tags': ['bbq', 'kasturi', 'chicken', 'methi']
    },
    {
      'id': 'f15', 'res': 'r2', 'name': 'Beef Bihari Boti',
      'desc': 'Thin tender beef strips marinated overnight in mustard oil, green papaya, and Bihari spice.',
      'img': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=600',
      'price': 780.0, 'cat': 'BBQ', 'rating': 4.8, 'pop': true,
      'addons': ['Tandoori Paratha', 'Ring Onions'],
      'tags': ['bbq', 'bihari', 'beef', 'tender']
    },
    {
      'id': 'f16', 'res': 'r2', 'name': 'Smokey Tandoori Paratha',
      'desc': 'Crispy layered clay-oven paratha brushed with pure melted desi butter.',
      'img': 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=600',
      'price': 90.0, 'cat': 'Pakistani', 'rating': 4.8, 'pop': false,
      'addons': ['Extra Butter'],
      'tags': ['bread', 'paratha', 'tandoori']
    },
    {
      'id': 'f17', 'res': 'r2', 'name': 'Sultan Mixed BBQ Platter (Family)',
      'desc': 'Includes 2 Chicken Tikka, 4 Malai Boti, 4 Seekh Kababs, 4 Bihari Boti, and 4 Parathas.',
      'img': 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600',
      'price': 2450.0, 'cat': 'BBQ', 'rating': 4.9, 'pop': true,
      'addons': ['Family Coke 1.5L', 'Extra 2 Parathas'],
      'tags': ['bbq', 'platter', 'family', 'deal', 'mixed']
    },
    {
      'id': 'f18', 'res': 'r2', 'name': 'Mint Chutney & Tandoori Kulcha',
      'desc': 'Freshly baked soft sesame tandoori kulcha with signature spicy garden mint dip.',
      'img': 'https://images.unsplash.com/photo-1544025162-8111149c4398?w=600',
      'price': 130.0, 'cat': 'Pakistani', 'rating': 4.7, 'pop': false,
      'addons': ['Extra Dip'],
      'tags': ['kulcha', 'bread', 'chutney']
    },

    // r3: Grill Town Smashed Burgers
    {
      'id': 'f19', 'res': 'r3', 'name': 'The Classic Smashed Double Beef',
      'desc': 'Two 100% prime beef smashed patties, double American cheddar, pickles, and signature house sauce.',
      'img': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
      'price': 680.0, 'cat': 'Burgers', 'rating': 4.9, 'pop': true,
      'addons': ['Extra Cheese Slice', 'Double Beef Patty', 'Fried Jalapenos', 'Beef Bacon Strips'],
      'tags': ['burger', 'beef', 'smashed', 'cheese', 'bestseller']
    },
    {
      'id': 'f20', 'res': 'r3', 'name': 'Crispy Zinger Crunch Stack',
      'desc': 'Extra crispy buttermilk battered chicken fillet, spicy peri mayonnaise, and crunchy lettuce in brioche.',
      'img': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=600',
      'price': 490.0, 'cat': 'Burgers', 'rating': 4.8, 'pop': true,
      'addons': ['Cheese Slice', 'Double Zinger Fillet', 'Spicy Jalapeno Poppers'],
      'tags': ['burger', 'zinger', 'chicken', 'crispy', 'spicy']
    },
    {
      'id': 'f21', 'res': 'r3', 'name': 'Smokey Bacon & Jalapeno Smash',
      'desc': 'Smashed beef patty layered with smokey cured strips, pickled jalapenos, and chipotle mayo.',
      'img': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
      'price': 740.0, 'cat': 'Burgers', 'rating': 4.8, 'pop': true,
      'addons': ['Extra Sauce', 'Extra Cheese'],
      'tags': ['burger', 'beef', 'bacon', 'jalapeno', 'smoky']
    },
    {
      'id': 'f22', 'res': 'r3', 'name': 'Mushroom Swiss Melt Burger',
      'desc': 'Smashed patty with grilled caramelized portobello mushrooms, Swiss cheese, and truffle mayo.',
      'img': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
      'price': 720.0, 'cat': 'Burgers', 'rating': 4.7, 'pop': false,
      'addons': ['Extra Mushrooms', 'Extra Swiss'],
      'tags': ['burger', 'mushroom', 'swiss', 'beef']
    },
    {
      'id': 'f23', 'res': 'r3', 'name': 'Peri Peri Crispy Chicken Fillet',
      'desc': 'Crispy golden fried breast fillet tossed in African peri peri dust with garlic aioli.',
      'img': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=600',
      'price': 520.0, 'cat': 'Burgers', 'rating': 4.7, 'pop': false,
      'addons': ['Cheese Slice', 'Side of Coleslaw'],
      'tags': ['burger', 'chicken', 'peri peri', 'crispy']
    },
    {
      'id': 'f24', 'res': 'r3', 'name': 'Cheesy Loaded Animal Fries',
      'desc': 'Crisp golden french fries drenched in molten liquid cheddar, grilled onions, and burger sauce.',
      'img': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
      'price': 390.0, 'cat': 'Fast Food', 'rating': 4.9, 'pop': true,
      'addons': ['Minced Beef Topping', 'Extra Cheese Dip'],
      'tags': ['fries', 'loaded', 'cheese', 'snack']
    },
    {
      'id': 'f25', 'res': 'r3', 'name': 'Crispy Onion Rings Basket',
      'desc': 'Thick cut sweet Spanish onions breaded and deep-fried to golden perfection with garlic ranch.',
      'img': 'https://images.unsplash.com/photo-1610440042657-612c34d95e9f?w=600',
      'price': 290.0, 'cat': 'Fast Food', 'rating': 4.6, 'pop': false,
      'addons': ['Extra Ranch Dip'],
      'tags': ['onion rings', 'snack', 'side']
    },
    {
      'id': 'f26', 'res': 'r3', 'name': 'Honey Mustard Chicken Wings (6 Pcs)',
      'desc': 'Crispy double fried bone-in wings glazed in sweet tangy honey mustard dressing.',
      'img': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
      'price': 460.0, 'cat': 'Fast Food', 'rating': 4.8, 'pop': false,
      'addons': ['Blue Cheese Dip', 'Celery Sticks'],
      'tags': ['wings', 'chicken', 'honey mustard', 'appetizer']
    },
    {
      'id': 'f27', 'res': 'r3', 'name': 'Thick Nutella Shake',
      'desc': 'Creamy vanilla bean gelato whipped with roasted hazelnut Nutella and crushed wafer.',
      'img': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600',
      'price': 380.0, 'cat': 'Drinks', 'rating': 4.9, 'pop': false,
      'addons': ['Whipped Cream', 'Choco Sprinkles'],
      'tags': ['shake', 'nutella', 'drink', 'sweet']
    },

    // r4: The Pizza Crust Studio
    {
      'id': 'f28', 'res': 'r4', 'name': 'Creamy Chicken Tikka Delight Pizza',
      'desc': 'Spicy chicken tikka chunks, capsicum, red onions, garlic ranch drizzle, and 100% mozzarella.',
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
      'price': 1150.0, 'cat': 'Pizza', 'rating': 4.9, 'pop': true,
      'addons': ['Stuffed Cheese Crust', 'Extra Mozzarella', 'Garlic Butter Dip', 'Jalapenos'],
      'tags': ['pizza', 'tikka', 'chicken', 'cheese', 'bestseller']
    },
    {
      'id': 'f29', 'res': 'r4', 'name': 'Pepperoni Passion Thin Crust',
      'desc': 'Crispy artisanal thin crust layered with rich tomato marinara and premium cured beef pepperoni slices.',
      'img': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600',
      'price': 1250.0, 'cat': 'Pizza', 'rating': 4.8, 'pop': true,
      'addons': ['Extra Pepperoni', 'Hot Honey Drizzle', 'Parmesan Crust'],
      'tags': ['pizza', 'pepperoni', 'beef', 'thin crust']
    },
    {
      'id': 'f30', 'res': 'r4', 'name': 'Crown Crust Fajita Fiesta',
      'desc': 'Crown shaped crust filled with spicy chicken seekh kababs, topped with fajita chicken and olives.',
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
      'price': 1390.0, 'cat': 'Pizza', 'rating': 4.9, 'pop': true,
      'addons': ['Garlic Herb Sauce', 'Extra Olives'],
      'tags': ['pizza', 'crown crust', 'fajita', 'kabab']
    },
    {
      'id': 'f31', 'res': 'r4', 'name': 'Smoky BBQ Chicken Supreme',
      'desc': 'Smoked chicken boti, sweet corn, purple onions, BBQ swirl, and melted gouda blend.',
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
      'price': 1180.0, 'cat': 'Pizza', 'rating': 4.7, 'pop': false,
      'addons': ['Extra BBQ Drizzle', 'Mushrooms'],
      'tags': ['pizza', 'bbq', 'chicken', 'cheese']
    },
    {
      'id': 'f32', 'res': 'r4', 'name': 'Four Cheese Mozzarella Melt',
      'desc': 'A decadent blend of mozzarella, cheddar, parmesan, and creamy ricotta on garlic herb base.',
      'img': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600',
      'price': 1050.0, 'cat': 'Pizza', 'rating': 4.6, 'pop': false,
      'addons': ['Chili Flakes', 'Hot Honey'],
      'tags': ['pizza', 'cheese', 'vegetarian', 'four cheese']
    },
    {
      'id': 'f33', 'res': 'r4', 'name': 'Spicy Buffalo Chicken Pizza',
      'desc': 'Fiery buffalo glazed chicken tenders with ranch drizzle, green chilies, and spring onion.',
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
      'price': 1220.0, 'cat': 'Pizza', 'rating': 4.8, 'pop': false,
      'addons': ['Extra Ranch', 'Jalapeno Slices'],
      'tags': ['pizza', 'buffalo', 'spicy', 'chicken']
    },
    {
      'id': 'f34', 'res': 'r4', 'name': 'Garlic Herb Breadsticks with Cheese Dip',
      'desc': 'Freshly baked warm breadsticks brushed with rosemary garlic butter and marinara dip.',
      'img': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600',
      'price': 340.0, 'cat': 'Fast Food', 'rating': 4.7, 'pop': false,
      'addons': ['Molten Cheddar Dip'],
      'tags': ['breadsticks', 'garlic', 'appetizer']
    },
    {
      'id': 'f35', 'res': 'r4', 'name': 'Stuffed Jalapeno Poppers (5 Pcs)',
      'desc': 'Spicy green jalapenos hollowed and stuffed with herb cream cheese, breaded and fried.',
      'img': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
      'price': 380.0, 'cat': 'Fast Food', 'rating': 4.8, 'pop': false,
      'addons': ['Ranch Dip'],
      'tags': ['jalapeno', 'snack', 'spicy']
    },
    {
      'id': 'f36', 'res': 'r4', 'name': 'Lava Chocolate Molten Cake',
      'desc': 'Warm rich chocolate sponge that bursts with liquid Belgian chocolate center.',
      'img': 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=600',
      'price': 390.0, 'cat': 'Desserts', 'rating': 4.9, 'pop': true,
      'addons': ['Vanilla Ice Cream Scoop'],
      'tags': ['dessert', 'cake', 'chocolate', 'lava']
    },

    // r5: Al-Madina Shawarma & Broast
    {
      'id': 'f37', 'res': 'r5', 'name': 'Syrian Garlic Chicken Shawarma Wrap',
      'desc': 'Shredded rotisserie spiced chicken, garlic toum, french fries, and pickled cucumbers wrapped in toasted flatbread.',
      'img': 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=600',
      'price': 280.0, 'cat': 'Shawarma', 'rating': 4.8, 'pop': true,
      'addons': ['Extra Garlic Toum', 'Cheese Melt Slice', 'Double Chicken Portion', 'Pickled Jalapenos'],
      'tags': ['shawarma', 'chicken', 'wrap', 'garlic', 'bestseller']
    },
    {
      'id': 'f38', 'res': 'r5', 'name': 'Spicy Mexican Shawarma with Jalapenos',
      'desc': 'Rotisserie chicken with spicy salsa, jalapenos, cheese sauce, and crispy lettuce.',
      'img': 'https://images.unsplash.com/photo-1561651823-34feb02250e4?w=600',
      'price': 320.0, 'cat': 'Shawarma', 'rating': 4.7, 'pop': true,
      'addons': ['Extra Cheese', 'Spicy Mayo'],
      'tags': ['shawarma', 'mexican', 'spicy', 'chicken']
    },
    {
      'id': 'f39', 'res': 'r5', 'name': 'Open Shawarma Platter with Hummus',
      'desc': 'Generous serving of spiced chicken over homemade hummus, served with 2 warm pitas and salad.',
      'img': 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=600',
      'price': 580.0, 'cat': 'Shawarma', 'rating': 4.9, 'pop': true,
      'addons': ['Extra Pita Bread', 'Extra Hummus'],
      'tags': ['shawarma', 'platter', 'hummus', 'pita']
    },
    {
      'id': 'f40', 'res': 'r5', 'name': 'Crispy Quarter Broast with Garlic Dip',
      'desc': 'Golden crispy pressure-fried chicken leg and thigh piece, served with salted fries, bun, and toum.',
      'img': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
      'price': 440.0, 'cat': 'Fast Food', 'rating': 4.8, 'pop': true,
      'addons': ['Dinner Bun', 'Garlic Mayo Cup', 'Coleslaw'],
      'tags': ['broast', 'fried chicken', 'crispy', 'fast food']
    },
    {
      'id': 'f41', 'res': 'r5', 'name': 'Full Crispy Fried Broast with Fries & Bun',
      'desc': 'Full 4-piece chicken broast with extra fries, 2 buns, garlic toum, and chili ketchup.',
      'img': 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=600',
      'price': 1250.0, 'cat': 'Fast Food', 'rating': 4.8, 'pop': false,
      'addons': ['Coleslaw Cup', 'Extra Garlic Dip'],
      'tags': ['broast', 'full', 'family', 'chicken']
    },
    {
      'id': 'f42', 'res': 'r5', 'name': 'Arabic Toum Garlic Dip & Fries Bowl',
      'desc': 'Golden crunchy french fries paired with authentic creamy whipped Lebanese garlic toum.',
      'img': 'https://images.unsplash.com/photo-1610440042657-612c34d95e9f?w=600',
      'price': 240.0, 'cat': 'Fast Food', 'rating': 4.7, 'pop': false,
      'addons': ['Extra Garlic Toum'],
      'tags': ['fries', 'garlic', 'dip', 'snack']
    },
    {
      'id': 'f43', 'res': 'r5', 'name': 'Falafel Hummus Pocket (Veg)',
      'desc': 'Crispy spiced chickpea falafels with tahini, tomatoes, and parsley in soft pita bread.',
      'img': 'https://images.unsplash.com/photo-1561651823-34feb02250e4?w=600',
      'price': 250.0, 'cat': 'Shawarma', 'rating': 4.6, 'pop': false,
      'addons': ['Extra Tahini', 'Pickled Turnips'],
      'tags': ['falafel', 'vegetarian', 'wrap', 'hummus']
    },
    {
      'id': 'f44', 'res': 'r5', 'name': 'Zesty Pickled Veggie Wrap',
      'desc': 'Lebanese pickles, fries, garlic paste, shredded salad, and spicy seasoning wrapped in pita.',
      'img': 'https://images.unsplash.com/photo-1529006557810-274b9b2fc783?w=600',
      'price': 210.0, 'cat': 'Shawarma', 'rating': 4.5, 'pop': false,
      'addons': ['Cheese Melt'],
      'tags': ['wrap', 'pickles', 'snack']
    },
    {
      'id': 'f45', 'res': 'r5', 'name': 'Fresh Mint Lemonade',
      'desc': 'Chilled refreshing slush of freshly squeezed lemons, mint leaves, and black salt.',
      'img': 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?w=600',
      'price': 180.0, 'cat': 'Drinks', 'rating': 4.8, 'pop': false,
      'addons': ['Chia Seeds'],
      'tags': ['drink', 'lemonade', 'mint', 'refreshing']
    },
  ];

  // Helper function to generate foods for restaurants r6 to r25
  final additionalFoodData = [
    // r6: Golden Dragon Chinese Bowl
    [
      {'name': 'Fiery Chicken Manchurian', 'desc': 'Crispy chicken cubes in tangy sweet and spicy red gravy with ginger and garlic.', 'cat': 'Chinese', 'price': 720.0, 'pop': true, 'tags': ['chinese', 'manchurian', 'chicken', 'gravy']},
      {'name': 'Kung Pao Chicken with Peanuts', 'desc': 'Stir-fried chicken with dried red chilies, scallions, roasted peanuts, and dark soy sauce.', 'cat': 'Chinese', 'price': 760.0, 'pop': true, 'tags': ['chinese', 'kung pao', 'chicken', 'peanuts']},
      {'name': 'Wok-Tossed Chicken Chow Mein', 'desc': 'Fresh egg noodles stir-fried in a roaring wok with julienne vegetables and chicken.', 'cat': 'Chinese', 'price': 650.0, 'pop': true, 'tags': ['chinese', 'chow mein', 'noodles', 'chicken']},
      {'name': 'Egg & Garlic Fried Rice', 'desc': 'Fluffy basmati rice tossed with farm eggs, spring onions, and roasted golden garlic.', 'cat': 'Chinese', 'price': 480.0, 'pop': false, 'tags': ['chinese', 'rice', 'fried rice', 'egg']},
      {'name': 'Szechuan Crispy Chili Dry Beef', 'desc': 'Crispy shredded beef glazed in spicy Szechuan sauce with bell peppers and toasted sesame.', 'cat': 'Chinese', 'price': 890.0, 'pop': true, 'tags': ['chinese', 'beef', 'szechuan', 'spicy']},
      {'name': 'Golden Crispy Spring Rolls (4 Pcs)', 'desc': 'Flaky hand-rolled wrappers stuffed with seasoned shredded chicken and cabbage.', 'cat': 'Chinese', 'price': 340.0, 'pop': false, 'tags': ['chinese', 'spring rolls', 'appetizer']},
      {'name': 'Hot & Sour Soup (Bowl)', 'desc': 'Classic warming Chinese soup packed with shredded chicken, wood ear mushrooms, and tofu.', 'cat': 'Chinese', 'price': 380.0, 'pop': false, 'tags': ['chinese', 'soup', 'hot and sour']},
      {'name': 'Chicken Dumplings with Chili Oil (6 Pcs)', 'desc': 'Delicate steamed wonton dumplings drizzled with housemade toasted chili oil and soy.', 'cat': 'Chinese', 'price': 520.0, 'pop': false, 'tags': ['chinese', 'dumplings', 'dimsum', 'chili oil']},
      {'name': 'Prawn Tempura with Sweet Chili', 'desc': 'Jumbo tiger prawns coated in light Japanese tempura batter, fried golden crisp.', 'cat': 'Chinese', 'price': 980.0, 'pop': false, 'tags': ['chinese', 'prawn', 'tempura', 'seafood']},
    ],
    // r7: Rooster Crispy Fried Chicken
    [
      {'name': '3 Pcs Golden Crunch Fried Chicken', 'desc': 'Pressure fried chicken pieces coated in our secret blend of 11 herbs and spices.', 'cat': 'Fast Food', 'price': 540.0, 'pop': true, 'tags': ['fast food', 'fried chicken', 'crispy']},
      {'name': 'Crispy Chicken Tenders & Fries Combo', 'desc': '5 golden hand-breaded chicken breast tenderloins served with salted french fries and dip.', 'cat': 'Fast Food', 'price': 580.0, 'pop': true, 'tags': ['tenders', 'chicken', 'fries']},
      {'name': 'Spicy Popcorn Nuggets Bucket', 'desc': 'Bite-sized seasoned chicken nuggets bursting with juicy crunch and peri seasoning.', 'cat': 'Fast Food', 'price': 420.0, 'pop': true, 'tags': ['nuggets', 'popcorn', 'snack']},
      {'name': 'Mega Crunch Fillet Burger', 'desc': 'Giant fried chicken fillet topped with melted cheese, dill pickles, and creamy mayonnaise.', 'cat': 'Burgers', 'price': 480.0, 'pop': true, 'tags': ['burger', 'chicken', 'fillet']},
      {'name': "Cheese Lover's Curly Fries", 'desc': 'Seasoned spiral curly fries smothered in warm molten cheddar cheese and bacon bits.', 'cat': 'Fast Food', 'price': 360.0, 'pop': false, 'tags': ['fries', 'curly', 'cheese']},
      {'name': 'Fiery Buffalo Crunch Wings (6 Pcs)', 'desc': 'Jumbo crispy chicken wings drenched in tangy buffalo glaze with ranch dip on the side.', 'cat': 'Fast Food', 'price': 460.0, 'pop': false, 'tags': ['wings', 'buffalo', 'spicy']},
      {'name': 'Coleslaw Salad Cup', 'desc': 'Chilled crisp shredded cabbage and carrots in sweet creamy homemade dressing.', 'cat': 'Fast Food', 'price': 120.0, 'pop': false, 'tags': ['salad', 'coleslaw', 'side']},
      {'name': 'Butter Dinner Roll & Gravy', 'desc': 'Warm freshly baked brioche dinner bun served with rich savory chicken gravy.', 'cat': 'Fast Food', 'price': 140.0, 'pop': false, 'tags': ['bun', 'gravy', 'side']},
      {'name': 'Peach Iced Tea', 'desc': 'Brewed black tea infused with sweet peach nectar and served ice cold.', 'cat': 'Drinks', 'price': 180.0, 'pop': false, 'tags': ['drink', 'tea', 'peach']},
    ],
    // r8: Chai Shai & Cafe Khana
    [
      {'name': 'Karak Doodh Patti Chai', 'desc': 'Slow-brewed thick buffalo milk tea infused with cardamom pods and saffron strands.', 'cat': 'Tea/Coffee', 'price': 120.0, 'pop': true, 'tags': ['tea', 'chai', 'karak', 'beverage']},
      {'name': 'Kashmiri Pink Tea with Pistachio', 'desc': 'Authentic slow-churned pink tea garnished with crushed almonds and pistachios.', 'cat': 'Tea/Coffee', 'price': 180.0, 'pop': true, 'tags': ['tea', 'kashmiri', 'pink tea']},
      {'name': 'Aloo Cheese Stuffed Paratha', 'desc': 'Golden tawa paratha stuffed with spiced mashed potatoes and gooey melted cheddar.', 'cat': 'Breakfast', 'price': 260.0, 'pop': true, 'tags': ['paratha', 'aloo', 'cheese', 'breakfast']},
      {'name': 'Chicken Cheese Malai Paratha Roll', 'desc': 'Charcoal malai boti, melted cheese, and green chutney rolled in flaky paratha.', 'cat': 'Fast Food', 'price': 340.0, 'pop': true, 'tags': ['roll', 'paratha roll', 'chicken', 'bestseller']},
      {'name': 'Classic Club Sandwich with Fries', 'desc': 'Triple-decker toasted bread layered with shredded chicken, fried egg, cheese, and fries.', 'cat': 'Fast Food', 'price': 480.0, 'pop': false, 'tags': ['sandwich', 'club sandwich', 'fries']},
      {'name': 'Spiced Desi Masala Omelette', 'desc': 'Two-egg fluffy omelette with finely diced onions, green chilies, coriander, and paratha.', 'cat': 'Breakfast', 'price': 220.0, 'pop': false, 'tags': ['omelette', 'breakfast', 'desi']},
      {'name': 'Nutella Paratha Delight', 'desc': 'Crisp layered tawa paratha folded with warm melted Nutella and crushed almonds.', 'cat': 'Desserts', 'price': 290.0, 'pop': false, 'tags': ['paratha', 'nutella', 'sweet']},
      {'name': 'Iced Spanish Latte', 'desc': 'Double shot rich espresso with sweetened condensed milk and cold fresh milk over ice.', 'cat': 'Tea/Coffee', 'price': 380.0, 'pop': false, 'tags': ['coffee', 'latte', 'iced coffee']},
      {'name': 'Bun Kabab (Karachi Street Style)', 'desc': 'Pan-fried daal and beef patty dipped in whipped egg foam with mint chutney in toasted bun.', 'cat': 'Fast Food', 'price': 190.0, 'pop': false, 'tags': ['bun kabab', 'street food', 'desi']},
    ],
    // r9: Royal Sweets & Bakers
    [
      {'name': 'Bahawalpuri Shahi Sohan Halwa (500g)', 'desc': 'The timeless royal specialty of Bahawalpur: rich caramelized halwa loaded with walnuts and almonds.', 'cat': 'Bakery', 'price': 650.0, 'pop': true, 'tags': ['halwa', 'sohan halwa', 'bahawalpur', 'traditional']},
      {'name': 'Warm Gulab Jamun (4 Pcs)', 'desc': 'Soft milk-solid dumplings dipped in warm cardamom and rose water sugar syrup.', 'cat': 'Desserts', 'price': 240.0, 'pop': true, 'tags': ['gulab jamun', 'sweet', 'dessert']},
      {'name': 'Rich Rasmalai Bowl (2 Pcs)', 'desc': 'Soft cottage cheese patties soaked in chilled saffron thickened cardamom milk with pistachios.', 'cat': 'Desserts', 'price': 290.0, 'pop': true, 'tags': ['rasmalai', 'sweet', 'chilled']},
      {'name': 'Fresh Chicken Patties (2 Pcs)', 'desc': 'Flaky puff pastry parcels filled with creamy spiced shredded chicken filling.', 'cat': 'Bakery', 'price': 160.0, 'pop': false, 'tags': ['patty', 'bakery', 'puff pastry']},
      {'name': 'Almond & Pista Tea Cake (Loaf)', 'desc': 'Buttery freshly baked golden sponge cake topped with slivered almonds and pistachios.', 'cat': 'Bakery', 'price': 380.0, 'pop': false, 'tags': ['cake', 'tea cake', 'bakery']},
      {'name': 'Crispy Butter Nan Khatai (Box)', 'desc': 'Traditional melt-in-the-mouth semolina and butter shortbread cookies.', 'cat': 'Bakery', 'price': 320.0, 'pop': false, 'tags': ['nan khatai', 'biscuits', 'bakery']},
      {'name': 'Black Forest Pastry Slice', 'desc': 'Chocolate sponge layered with whipped cream, sour cherries, and shaved dark chocolate.', 'cat': 'Bakery', 'price': 190.0, 'pop': false, 'tags': ['pastry', 'chocolate', 'cake']},
      {'name': 'Motichoor Ladoo Box (500g)', 'desc': 'Tender tiny gram flour pearls fried in pure desi ghee and bound into fragrant sweet balls.', 'cat': 'Desserts', 'price': 520.0, 'pop': false, 'tags': ['ladoo', 'sweet', 'desi ghee']},
      {'name': 'Zafrani Kheer Bowl', 'desc': 'Slow-cooked creamy rice pudding flavored with saffron, cardamom, and silver leaf.', 'cat': 'Desserts', 'price': 240.0, 'pop': false, 'tags': ['kheer', 'sweet', 'rice pudding']},
    ],
    // r10: Sweet Tooth Gelato & Waffles
    [
      {'name': 'Belgian Chocolate Molten Lava Cake', 'desc': 'Freshly baked chocolate cake with warm gooey liquid chocolate center, served with gelato.', 'cat': 'Desserts', 'price': 460.0, 'pop': true, 'tags': ['dessert', 'lava cake', 'chocolate']},
      {'name': 'Nutella & Fresh Strawberry Waffle', 'desc': 'Golden Belgian waffle smothered in warm Nutella and topped with fresh fruit slices.', 'cat': 'Desserts', 'price': 540.0, 'pop': true, 'tags': ['waffle', 'nutella', 'strawberry']},
      {'name': 'Lotus Biscoff Sundae Cup', 'desc': 'Layers of vanilla gelato, Biscoff cookie spread, crunchy caramel biscuits, and whipped cream.', 'cat': 'Desserts', 'price': 490.0, 'pop': true, 'tags': ['sundae', 'biscoff', 'lotus']},
      {'name': 'Double Chocolate Chunk Brownie', 'desc': 'Fudgy dark chocolate brownie loaded with chunks of milk and white chocolate.', 'cat': 'Desserts', 'price': 280.0, 'pop': false, 'tags': ['brownie', 'chocolate', 'fudge']},
      {'name': 'Artisanal Pistachio Gelato (Double Scoop)', 'desc': 'Authentic Italian style slow-churned gelato made with roasted Sicilian pistachios.', 'cat': 'Desserts', 'price': 390.0, 'pop': false, 'tags': ['gelato', 'pistachio', 'ice cream']},
      {'name': 'Oreo Crunch Monster Milkshake', 'desc': 'Creamy chocolate shake blended with whole Oreo cookies and topped with cookie dust.', 'cat': 'Drinks', 'price': 380.0, 'pop': false, 'tags': ['shake', 'oreo', 'drink']},
      {'name': 'Caramel Drizzle Churros Basket (6 Pcs)', 'desc': 'Spanish fried dough pastries tossed in cinnamon sugar with dulce de leche dip.', 'cat': 'Desserts', 'price': 380.0, 'pop': false, 'tags': ['churros', 'caramel', 'cinnamon']},
      {'name': 'Red Velvet Cheesecake Slice', 'desc': 'New York style baked cheesecake layered over rich red velvet cake base.', 'cat': 'Desserts', 'price': 440.0, 'pop': false, 'tags': ['cheesecake', 'red velvet']},
      {'name': 'Iced Mochaccino', 'desc': 'Espresso, dark chocolate syrup, and cold milk blended with ice and whipped cream.', 'cat': 'Drinks', 'price': 340.0, 'pop': false, 'tags': ['coffee', 'mocha', 'iced']},
    ],
    // r11: Green Leaf Fresh Bowls & Juices
    [
      {'name': 'Lemon Herb Grilled Chicken Salad', 'desc': 'Tender grilled chicken breast over mixed greens, cherry tomatoes, cucumbers, and herb dressing.', 'cat': 'Healthy', 'price': 580.0, 'pop': true, 'tags': ['healthy', 'salad', 'chicken', 'keto']},
      {'name': 'Quinoa & Avocado Power Bowl', 'desc': 'Organic tri-color quinoa, sliced Haas avocado, edamame, and roasted chickpeas with lime vinaigrette.', 'cat': 'Healthy', 'price': 650.0, 'pop': true, 'tags': ['healthy', 'quinoa', 'avocado', 'vegan']},
      {'name': 'Greek Feta & Cucumber Tossed Salad', 'desc': 'Crisp romaine lettuce, kalamata olives, diced cucumbers, tomatoes, and crumbled feta cheese.', 'cat': 'Healthy', 'price': 480.0, 'pop': false, 'tags': ['healthy', 'greek', 'feta', 'salad']},
      {'name': 'Cold-Pressed ABC Cleanse', 'desc': 'Pure cold-extracted apple, beetroot, and carrot juice packed with antioxidants.', 'cat': 'Drinks', 'price': 320.0, 'pop': true, 'tags': ['juice', 'healthy', 'cold pressed', 'cleanse']},
      {'name': 'Fresh Mint & Chia Lime Cooler', 'desc': 'Hydrating lime juice infused with soaked organic chia seeds and garden fresh mint.', 'cat': 'Drinks', 'price': 220.0, 'pop': false, 'tags': ['drink', 'lime', 'chia', 'detox']},
      {'name': 'Mediterranean Grilled Chicken Wrap', 'desc': 'Whole wheat tortilla stuffed with grilled chicken, hummus, spinach, and roasted peppers.', 'cat': 'Healthy', 'price': 490.0, 'pop': false, 'tags': ['wrap', 'healthy', 'chicken', 'low carb']},
      {'name': 'Protein Peanut Butter Smoothie', 'desc': 'Whey protein, natural peanut butter, ripe banana, and almond milk blended with ice.', 'cat': 'Drinks', 'price': 420.0, 'pop': false, 'tags': ['smoothie', 'protein', 'fitness']},
      {'name': 'Fresh Seasonal Fruit Platter', 'desc': 'Assortment of fresh seasonal watermelon, melon, kiwi, apples, and pomegranate.', 'cat': 'Healthy', 'price': 320.0, 'pop': false, 'tags': ['fruit', 'healthy', 'platter']},
      {'name': 'Detox Green Boost Juice', 'desc': 'Cucumber, green apple, spinach, celery, ginger, and fresh lemon juice.', 'cat': 'Drinks', 'price': 340.0, 'pop': false, 'tags': ['juice', 'green', 'detox', 'healthy']},
    ],
    // r12: Morning Glory Halwa Puri & Nashta
    [
      {'name': 'Shahi Halwa Puri Thali', 'desc': '3 piping hot crispy puris served with spiced chana masala, sweet suji halwa, and mixed pickle.', 'cat': 'Breakfast', 'price': 320.0, 'pop': true, 'tags': ['breakfast', 'halwa puri', 'chana', 'puri']},
      {'name': 'Lahori Chana Masala (Single Bowl)', 'desc': 'Slow-cooked buttery chickpeas simmered in aromatic whole spices and black pepper.', 'cat': 'Breakfast', 'price': 180.0, 'pop': true, 'tags': ['chana', 'curry', 'breakfast']},
      {'name': 'Desi Ghee Suji Ka Halwa', 'desc': 'Golden semolina halwa cooked in pure desi ghee with saffron essence and sliced almonds.', 'cat': 'Breakfast', 'price': 190.0, 'pop': false, 'tags': ['halwa', 'sweet', 'desi ghee']},
      {'name': 'Aloo Tarkari with Achar & Puris', 'desc': 'Tangy potato curry with kalonji seeds and fenugreek, served with 2 fresh puris.', 'cat': 'Breakfast', 'price': 240.0, 'pop': false, 'tags': ['aloo', 'tarkari', 'breakfast']},
      {'name': 'Meethi Dahi Lassi (Special Matka)', 'desc': 'Thick churned sweet yogurt drink served chilled in traditional clay matka with malai layer.', 'cat': 'Drinks', 'price': 180.0, 'pop': true, 'tags': ['lassi', 'drink', 'matka', 'traditional']},
      {'name': 'Namkeen Zeera Lassi', 'desc': 'Refreshing salted yogurt drink spiced with roasted ground cumin and fresh mint.', 'cat': 'Drinks', 'price': 160.0, 'pop': false, 'tags': ['lassi', 'salted', 'drink']},
      {'name': 'Fluffy Cheese & Herb Omelette with Paratha', 'desc': 'Three-egg folded omelette with spring herbs, green chilies, and melted cheddar.', 'cat': 'Breakfast', 'price': 340.0, 'pop': false, 'tags': ['omelette', 'paratha', 'breakfast']},
      {'name': 'Crispy Tandoori Paratha', 'desc': 'Clay-oven baked layered whole wheat paratha brushed with golden butter.', 'cat': 'Breakfast', 'price': 80.0, 'pop': false, 'tags': ['paratha', 'bread', 'breakfast']},
      {'name': 'Masala Chai', 'desc': 'Rich brewed milk tea infused with crushed ginger, cinnamon, and cloves.', 'cat': 'Tea/Coffee', 'price': 120.0, 'pop': false, 'tags': ['tea', 'masala chai', 'drink']},
    ],
    // r13: Mama's Secret Home Kitchen
    [
      {'name': 'Home-Style Daal Chawal with Achar & Salad', 'desc': 'Comforting yellow lentil tarka curry served over fragrant steamed basmati rice with pickle.', 'cat': 'Home Kitchen', 'price': 350.0, 'pop': true, 'tags': ['daal', 'rice', 'home kitchen', 'comfort']},
      {'name': 'Palak Gosht (Tender Mutton in Spinach)', 'desc': 'Tender bone-in mutton slow-cooked with fresh garden spinach and whole spices.', 'cat': 'Home Kitchen', 'price': 780.0, 'pop': true, 'tags': ['mutton', 'palak', 'home food', 'desi']},
      {'name': 'Aloo Keema Dum Fry', 'desc': 'Minced beef slow cooked with tender potato cubes, green peas, and fresh ginger julienne.', 'cat': 'Home Kitchen', 'price': 580.0, 'pop': true, 'tags': ['keema', 'beef', 'aloo', 'desi']},
      {'name': 'Kadhi Pakora with Steamed Rice', 'desc': 'Gram flour and yogurt tangy curry with crispy spiced onion pakoras over rice.', 'cat': 'Home Kitchen', 'price': 390.0, 'pop': false, 'tags': ['kadhi', 'pakora', 'home food']},
      {'name': 'Chicken Korma with Roghni Naan', 'desc': 'Traditional rich yogurt and fried onion chicken korma served with fresh roghni naan.', 'cat': 'Pakistani', 'price': 620.0, 'pop': false, 'tags': ['korma', 'chicken', 'curry']},
      {'name': 'Mix Vegetable Bhujia', 'desc': 'Seasonal carrots, potatoes, peas, and cauliflower lightly spiced and sauteed with cumin.', 'cat': 'Home Kitchen', 'price': 320.0, 'pop': false, 'tags': ['veg', 'sabzi', 'healthy']},
      {'name': 'Soft Whole Wheat Tawa Phulkas (3 Pcs)', 'desc': 'Puffed oil-free soft round rotis made from 100% whole wheat chakki flour.', 'cat': 'Home Kitchen', 'price': 90.0, 'pop': false, 'tags': ['roti', 'phulka', 'bread']},
      {'name': 'Mint Kachumber Salad', 'desc': 'Finely diced cucumbers, tomatoes, red onions, lemon juice, and fresh garden mint.', 'cat': 'Home Kitchen', 'price': 110.0, 'pop': false, 'tags': ['salad', 'side']},
      {'name': 'Home-Style Shahi Kheer', 'desc': 'Traditional slow simmered rice and milk dessert topped with roasted almonds.', 'cat': 'Desserts', 'price': 220.0, 'pop': false, 'tags': ['kheer', 'sweet', 'dessert']},
    ],
    // r14: Shinwari Dera & Karahi
    [
      {'name': 'Namkeen Shinwari Mutton Karahi (Half kg)', 'desc': 'Cooked exclusively in lamb fat with ripe tomatoes, green chilies, and salt without heavy red chili.', 'cat': 'Pakistani', 'price': 1850.0, 'pop': true, 'tags': ['shinwari', 'karahi', 'mutton', 'authentic', 'bestseller']},
      {'name': 'White Makhni Chicken Karahi', 'desc': 'Boneless chicken cubes cooked in fresh cream, butter, yogurt, and crushed white pepper.', 'cat': 'Pakistani', 'price': 1250.0, 'pop': true, 'tags': ['karahi', 'white karahi', 'chicken', 'makhni']},
      {'name': 'Namkeen Dumbah Karahi (Lamb Fat)', 'desc': 'Authentic succulent dumbah meat slow fried in its own fat with garlic and rock salt.', 'cat': 'Pakistani', 'price': 2100.0, 'pop': true, 'tags': ['dumbah', 'lamb', 'shinwari', 'premium']},
      {'name': 'Charcoal Shinwari Tikka (1 Skewer)', 'desc': 'Tender mutton cubes seasoned only with coarse sea salt and grilled over smoking coal.', 'cat': 'BBQ', 'price': 580.0, 'pop': false, 'tags': ['tikka', 'mutton', 'bbq', 'shinwari']},
      {'name': 'Peshawari Chapli Kabab (Large 2 Pcs)', 'desc': 'Pan-fried minced beef patties infused with pomegranate seeds, coriander, and tomato slices.', 'cat': 'Pakistani', 'price': 650.0, 'pop': true, 'tags': ['chapli kabab', 'beef', 'peshawari']},
      {'name': 'Kabuli Pulao with Raisins & Carrots', 'desc': 'Aromatic mild rice topped with tender mutton shank, sweet caramelized carrots, and raisins.', 'cat': 'Pakistani', 'price': 850.0, 'pop': false, 'tags': ['pulao', 'kabuli', 'mutton', 'rice']},
      {'name': 'Special Khameeri Kulcha / Naan', 'desc': 'Fluffy yeast-leavened tandoor bread baked to a light golden blister.', 'cat': 'Pakistani', 'price': 60.0, 'pop': false, 'tags': ['naan', 'kulcha', 'bread']},
      {'name': 'Shinwari Green Kahwa Tea', 'desc': 'Peshawari green tea brewed with cardamom pods and served with lemon and crystal sugar.', 'cat': 'Tea/Coffee', 'price': 100.0, 'pop': false, 'tags': ['tea', 'kahwa', 'green tea']},
      {'name': 'Podina Raita & Salad', 'desc': 'Hand-crushed wild mint yogurt dip and freshly sliced onion rings.', 'cat': 'Pakistani', 'price': 120.0, 'pop': false, 'tags': ['raita', 'salad', 'side']},
    ],
    // r15: Karachi Student Biryani Hub
    [
      {'name': 'Karachi Double Potato Chicken Biryani', 'desc': 'Spicy Karachi-style layered biryani with tender chicken and soft marinated potatoes.', 'cat': 'Biryani', 'price': 420.0, 'pop': true, 'tags': ['biryani', 'karachi', 'chicken', 'aloo', 'spicy']},
      {'name': 'Spicy Beef Nalli Biryani', 'desc': 'Long basmati rice served with marrow shank beef, brown onions, and fiery Sindhi spices.', 'cat': 'Biryani', 'price': 720.0, 'pop': true, 'tags': ['biryani', 'beef', 'nalli', 'spicy']},
      {'name': 'Karachi Student Special Pulao', 'desc': 'Aromatic beef broth pulao with soft meat pieces and mild whole spices.', 'cat': 'Biryani', 'price': 480.0, 'pop': false, 'tags': ['pulao', 'beef', 'rice']},
      {'name': 'Chicken Shami Kabab (2 Pcs)', 'desc': 'Hand-pounded chicken and lentil patties with fresh herbs, pan-fried crisp.', 'cat': 'Pakistani', 'price': 180.0, 'pop': false, 'tags': ['kabab', 'shami', 'chicken']},
      {'name': 'Raita & Onion Salad Set', 'desc': 'Thin spicy cumin yogurt dip and sliced red onions with fresh lemon.', 'cat': 'Biryani', 'price': 90.0, 'pop': false, 'tags': ['raita', 'side']},
      {'name': 'Karachi Special Chicken Biryani with Cold Drink', 'desc': 'Full biryani plate served with chilled 345ml soft drink and raita.', 'cat': 'Biryani', 'price': 520.0, 'pop': true, 'tags': ['biryani', 'deal', 'combo']},
      {'name': 'Traditional Shahi Firni', 'desc': 'Fine ground rice pudding cooked with condensed milk and served in chilled clay pot.', 'cat': 'Desserts', 'price': 180.0, 'pop': false, 'tags': ['firni', 'sweet', 'dessert']},
      {'name': 'Extra Biryani Aloo (2 Pcs)', 'desc': 'Two additional spicy marinated yellow potatoes for biryani lovers.', 'cat': 'Biryani', 'price': 90.0, 'pop': false, 'tags': ['aloo', 'extra']},
      {'name': 'Spicy Tikka Boti add-on', 'desc': 'Four boneless chicken tikka boti pieces to top your biryani.', 'cat': 'BBQ', 'price': 240.0, 'pop': false, 'tags': ['tikka', 'addon']},
    ],
    // r16: Bahaar-e-Kabab Smokey BBQ
    [
      {'name': 'Mughlai Beef Gola Kabab (4 Pcs)', 'desc': 'Melt-in-mouth spiced round beef kababs smoked over burning coal and thread-wrapped.', 'cat': 'BBQ', 'price': 640.0, 'pop': true, 'tags': ['bbq', 'gola kabab', 'beef']},
      {'name': 'Chicken Reshmi Malai Seekh', 'desc': 'Minced chicken blended with dairy cream, butter, and mild green herbs on skewers.', 'cat': 'BBQ', 'price': 580.0, 'pop': true, 'tags': ['bbq', 'reshmi', 'seekh', 'chicken']},
      {'name': 'Spicy Beef Seekh Kabab (4 Pcs)', 'desc': 'Traditional juicy beef mince skewers seasoned with crushed coriander, chili, and cumin.', 'cat': 'BBQ', 'price': 560.0, 'pop': false, 'tags': ['bbq', 'seekh kabab', 'beef', 'spicy']},
      {'name': 'Charcoal Grilled Fish Tikka', 'desc': 'Boneless river fish cubes marinated in ajwain, turmeric, and lemon juice, grilled on skewers.', 'cat': 'BBQ', 'price': 890.0, 'pop': true, 'tags': ['fish', 'bbq', 'seafood']},
      {'name': 'Smoked Chicken Chargha (Full)', 'desc': 'Whole deep-cut chicken marinated in Lahori spices, steamed and deep fried with chaat masala.', 'cat': 'BBQ', 'price': 1150.0, 'pop': true, 'tags': ['chargha', 'chicken', 'whole chicken']},
      {'name': 'Sesame Seed Roghni Naan', 'desc': 'Clay oven naan topped with white sesame seeds and glazed with butter.', 'cat': 'Pakistani', 'price': 80.0, 'pop': false, 'tags': ['naan', 'roghni', 'bread']},
      {'name': 'Garlic Butter Naan', 'desc': 'Tandoori naan topped with chopped roasted garlic and melted butter.', 'cat': 'Pakistani', 'price': 90.0, 'pop': false, 'tags': ['naan', 'garlic', 'bread']},
      {'name': 'Special Bahaar Mixed Grill', 'desc': 'Combination of 2 Gola Kababs, 2 Malai Seekh, Fish Tikka, and 2 Roghni Naans.', 'cat': 'BBQ', 'price': 1750.0, 'pop': false, 'tags': ['bbq', 'mixed grill', 'platter']},
      {'name': 'Zeera Dahi Chutney', 'desc': 'Thick whipped yogurt with crushed roasted cumin and dried mint.', 'cat': 'Pakistani', 'price': 90.0, 'pop': false, 'tags': ['chutney', 'side']},
    ],
    // r17: Burger District 6
    [
      {'name': 'District Crunchy Zinger', 'desc': 'Crispy golden spiced fried breast fillet, spicy mayo, and iceberg lettuce on seeded bun.', 'cat': 'Burgers', 'price': 420.0, 'pop': true, 'tags': ['burger', 'zinger', 'crispy', 'chicken']},
      {'name': 'Double Patty Jalapeno Pepperjack', 'desc': 'Two smashed beef patties with fiery pepperjack cheese, grilled jalapenos, and chipotle dip.', 'cat': 'Burgers', 'price': 690.0, 'pop': true, 'tags': ['burger', 'beef', 'jalapeno', 'double']},
      {'name': 'Smoky BBQ Glazed Beef Burger', 'desc': 'Chargrilled beef patty basted with sweet hickory barbecue sauce and crispy onion strings.', 'cat': 'Burgers', 'price': 620.0, 'pop': false, 'tags': ['burger', 'bbq', 'beef']},
      {'name': 'Crispy Fillet Burger with Herb Mayo', 'desc': 'Mild crunchy chicken fillet with garden herb mayonnaise and fresh tomato slices.', 'cat': 'Burgers', 'price': 410.0, 'pop': false, 'tags': ['burger', 'chicken', 'fillet']},
      {'name': 'Pizza Fries (Loaded Pepperoni & Cheese)', 'desc': 'Crispy fries topped with pizza marinara, melted mozzarella, and beef pepperoni.', 'cat': 'Fast Food', 'price': 450.0, 'pop': true, 'tags': ['fries', 'pizza fries', 'loaded']},
      {'name': 'Seasoned Curly Fries', 'desc': 'Crispy spiral potatoes tossed in paprika, garlic, and sea salt seasoning.', 'cat': 'Fast Food', 'price': 280.0, 'pop': false, 'tags': ['fries', 'curly', 'snack']},
      {'name': 'Crispy Mozzarella Sticks with Marinara (5 Pcs)', 'desc': 'Stretchy mozzarella cheese battered in Italian herb breadcrumbs.', 'cat': 'Fast Food', 'price': 380.0, 'pop': false, 'tags': ['mozzarella', 'cheese', 'snack']},
      {'name': 'Spicy Wings in Buffalo Sauce (6 Pcs)', 'desc': 'Crispy wings tossed in fiery red hot pepper sauce with creamy ranch.', 'cat': 'Fast Food', 'price': 420.0, 'pop': false, 'tags': ['wings', 'buffalo', 'chicken']},
      {'name': 'Blue Lagoon Chiller', 'desc': 'Sparkling citrus soda with blue curacao flavor and fresh lemon wedge.', 'cat': 'Drinks', 'price': 220.0, 'pop': false, 'tags': ['drink', 'soda', 'blue lagoon']},
    ],
    // r18: Napoli Stone-Oven Pizza
    [
      {'name': 'Neapolitan Margherita Pizza', 'desc': 'San Marzano tomato sauce, fresh buffalo mozzarella, fragrant basil leaves, and extra virgin olive oil.', 'cat': 'Pizza', 'price': 980.0, 'pop': true, 'tags': ['pizza', 'margherita', 'neapolitan', 'vegetarian']},
      {'name': 'Charred Beef Pepperoni & Hot Honey', 'desc': 'Wood fired crust topped with crispy beef pepperoni cups and infused spicy honey drizzle.', 'cat': 'Pizza', 'price': 1350.0, 'pop': true, 'tags': ['pizza', 'pepperoni', 'hot honey', 'beef']},
      {'name': 'Smoked BBQ Chicken & Red Onion', 'desc': 'Stone-baked pizza with smoked pulled chicken, sliced purple onions, and gouda cheese.', 'cat': 'Pizza', 'price': 1190.0, 'pop': false, 'tags': ['pizza', 'bbq', 'chicken']},
      {'name': 'White Truffle & Mushroom Pizza', 'desc': 'Creamy garlic white sauce base with wild sautéed mushrooms, truffle oil, and parmesan.', 'cat': 'Pizza', 'price': 1390.0, 'pop': true, 'tags': ['pizza', 'truffle', 'mushroom']},
      {'name': 'Spicy Jalapeno & Sausage Pizza', 'desc': 'Spicy Italian beef sausage chunks, pickled jalapenos, and crushed chili flakes on mozzarella.', 'cat': 'Pizza', 'price': 1250.0, 'pop': false, 'tags': ['pizza', 'sausage', 'spicy']},
      {'name': 'Cheesy Garlic Focaccia Bread', 'desc': 'Thick airy Italian focaccia bread baked with fresh rosemary, garlic confit, and mozzarella.', 'cat': 'Pizza', 'price': 390.0, 'pop': false, 'tags': ['focaccia', 'bread', 'garlic']},
      {'name': 'Burrata & Arugula Salad', 'desc': 'Creamy whole Italian burrata ball surrounded by baby arugula, cherry tomatoes, and balsamic.', 'cat': 'Healthy', 'price': 690.0, 'pop': false, 'tags': ['burrata', 'salad', 'italian']},
      {'name': 'San Pellegrino Lemon Soda', 'desc': 'Sparkling Italian mineral water soda with Sicilian sun-ripened lemons.', 'cat': 'Drinks', 'price': 260.0, 'pop': false, 'tags': ['drink', 'soda', 'sparkling']},
      {'name': 'Classic Tiramisu Cup', 'desc': 'Coffee-soaked ladyfingers layered with sweet mascarpone cream and dusted with Dutch cocoa.', 'cat': 'Desserts', 'price': 420.0, 'pop': false, 'tags': ['tiramisu', 'dessert', 'italian']},
    ],
    // r19: Damascus Pita & Shawarma
    [
      {'name': 'Damascus Spiced Chicken Pita Wrap', 'desc': 'Thinly sliced chicken cooked with Syrian spices, pickles, fries, and garlic toum in flat pita.', 'cat': 'Shawarma', 'price': 290.0, 'pop': true, 'tags': ['shawarma', 'pita', 'chicken', 'syrian']},
      {'name': 'Beef Shawarma Roll with Tahini', 'desc': 'Marinated beef strips with sumac onions, fresh parsley, and sesame tahini dressing.', 'cat': 'Shawarma', 'price': 360.0, 'pop': true, 'tags': ['shawarma', 'beef', 'tahini']},
      {'name': 'Hummus Bil Lahmeh', 'desc': 'Creamy chickpea hummus topped with warm spiced minced beef, pine nuts, and olive oil.', 'cat': 'Shawarma', 'price': 580.0, 'pop': true, 'tags': ['hummus', 'beef', 'appetizer']},
      {'name': 'Crispy Falafel Bowl with Tahini (6 Pcs)', 'desc': 'Golden crispy falafel balls made from ground chickpeas, cumin, and coriander with tahini dip.', 'cat': 'Shawarma', 'price': 290.0, 'pop': false, 'tags': ['falafel', 'vegetarian', 'snack']},
      {'name': 'Garlic Toum Dip with Warm Pita', 'desc': 'Whipped garlic emulsion dip served with fresh toasted Arabic flatbread.', 'cat': 'Shawarma', 'price': 180.0, 'pop': false, 'tags': ['toum', 'dip', 'garlic', 'pita']},
      {'name': 'Arabic Fattoush Salad with Pomegranate', 'desc': 'Crisp romaine, radishes, cucumbers, fried pita chips, and tangy sumac pomegranate dressing.', 'cat': 'Healthy', 'price': 340.0, 'pop': false, 'tags': ['salad', 'fattoush', 'healthy']},
      {'name': 'Damascus Mixed Grill Platter', 'desc': 'Chicken and beef shawarma cuts served over aromatic yellow rice with hummus and pita.', 'cat': 'Shawarma', 'price': 890.0, 'pop': false, 'tags': ['platter', 'mixed grill', 'rice']},
      {'name': 'Fresh Baked Pita Bread (3 Pcs)', 'desc': 'Soft warm clay-oven flatbread fresh from the fire.', 'cat': 'Shawarma', 'price': 90.0, 'pop': false, 'tags': ['pita', 'bread']},
      {'name': 'Turkish Laban Drink', 'desc': 'Chilled lightly salted yogurt beverage whipped smooth.', 'cat': 'Drinks', 'price': 160.0, 'pop': false, 'tags': ['laban', 'drink', 'yogurt']},
    ],
    // r20: Mandarin Wok & Dimsum
    [
      {'name': 'Steamed Chicken Dimsum Basket (6 Pcs)', 'desc': 'Handmade wonton wrappers filled with minced chicken and scallions, served with chili soy dip.', 'cat': 'Chinese', 'price': 490.0, 'pop': true, 'tags': ['dimsum', 'dumplings', 'chinese']},
      {'name': 'Crispy Beef with Szechuan Chili', 'desc': 'Crispy fried beef slivers tossed in spicy sweet garlic chili sauce and bell peppers.', 'cat': 'Chinese', 'price': 860.0, 'pop': true, 'tags': ['chinese', 'beef', 'szechuan']},
      {'name': 'Chicken with Cashew Nuts & Veggies', 'desc': 'Stir-fried chicken breast with toasted golden cashews, celery, and savory brown sauce.', 'cat': 'Chinese', 'price': 780.0, 'pop': false, 'tags': ['chinese', 'cashew', 'chicken']},
      {'name': 'Singaporean Curried Rice Noodles', 'desc': 'Thin vermicelli noodles wok-fried with shrimp, chicken, bell peppers, and mild curry powder.', 'cat': 'Chinese', 'price': 690.0, 'pop': true, 'tags': ['noodles', 'singaporean', 'chinese']},
      {'name': 'Golden Crispy Wontons (6 Pcs)', 'desc': 'Deep-fried golden wonton pockets filled with minced chicken and served with sweet sour sauce.', 'cat': 'Chinese', 'price': 380.0, 'pop': false, 'tags': ['wonton', 'appetizer', 'crispy']},
      {'name': 'Crab Corn Soup (Bowl)', 'desc': 'Thick comforting sweet corn soup with egg ribbons and delicate crab meat.', 'cat': 'Chinese', 'price': 390.0, 'pop': false, 'tags': ['soup', 'corn', 'chinese']},
      {'name': 'Sticky Honey Garlic Chicken Wings', 'desc': 'Crispy wings coated in glossy garlic honey sauce and toasted sesame seeds.', 'cat': 'Chinese', 'price': 480.0, 'pop': false, 'tags': ['wings', 'honey garlic', 'chinese']},
      {'name': 'Vegetable Fried Rice', 'desc': 'Stir-fried long grain rice with carrots, peas, spring onions, and toasted sesame oil.', 'cat': 'Chinese', 'price': 420.0, 'pop': false, 'tags': ['rice', 'fried rice', 'vegetarian']},
      {'name': 'Jasmine Green Tea Pot', 'desc': 'Fragrant brewed whole leaf jasmine blossom green tea.', 'cat': 'Tea/Coffee', 'price': 180.0, 'pop': false, 'tags': ['tea', 'jasmine', 'chinese']},
    ],
    // r21: The Crave Yard Fast Food
    [
      {'name': 'Crave Loaded Cheesy Chicken Burger', 'desc': 'Double fried chicken patties, double cheese, fried onion rings, and spicy cocktail sauce.', 'cat': 'Burgers', 'price': 520.0, 'pop': true, 'tags': ['burger', 'chicken', 'loaded', 'fast food']},
      {'name': 'Double Chapli Fusion Burger', 'desc': 'Spicy beef chapli patties placed inside soft sesame burger bun with mint mayo and onions.', 'cat': 'Burgers', 'price': 480.0, 'pop': true, 'tags': ['burger', 'chapli', 'fusion', 'beef']},
      {'name': 'Overloaded Pizza Fries Box', 'desc': 'Crinkle cut french fries covered with marinara, spicy chicken chunks, and melted mozzarella.', 'cat': 'Fast Food', 'price': 440.0, 'pop': true, 'tags': ['fries', 'pizza fries', 'loaded']},
      {'name': 'Crispy Strips Basket with Honey Mustard', 'desc': '5 golden seasoned chicken breast strips served with dipping sauce and fries.', 'cat': 'Fast Food', 'price': 460.0, 'pop': false, 'tags': ['tenders', 'strips', 'chicken']},
      {'name': 'Golden Chicken Corn Dogs (2 Pcs)', 'desc': 'Frankfurter sausage skewers coated in sweet cornmeal batter and fried crisp with mustard.', 'cat': 'Fast Food', 'price': 320.0, 'pop': false, 'tags': ['corn dog', 'snack', 'fast food']},
      {'name': 'Cheesy Jalapeno Bites (6 Pcs)', 'desc': 'Molten cheddar cheese nuggets with diced jalapenos in crispy potato crust.', 'cat': 'Fast Food', 'price': 340.0, 'pop': false, 'tags': ['jalapeno', 'cheese', 'snack']},
      {'name': 'Salted Caramel Frappe', 'desc': 'Ice blended coffee with buttery caramel syrup, whipped cream, and sea salt flakes.', 'cat': 'Drinks', 'price': 360.0, 'pop': false, 'tags': ['frappe', 'coffee', 'caramel']},
      {'name': 'Electric Blue Lemonade', 'desc': 'Chilled sparkling citrus cooler with blue berry syrup and mint leaves.', 'cat': 'Drinks', 'price': 190.0, 'pop': false, 'tags': ['lemonade', 'drink', 'chiller']},
      {'name': 'Chocolate Fudge Brownie Shake', 'desc': 'Dense chocolate milkshake blended with real fudge brownie squares.', 'cat': 'Drinks', 'price': 380.0, 'pop': false, 'tags': ['shake', 'brownie', 'chocolate']},
    ],
    // r22: Coffee Lounge & Roastery
    [
      {'name': 'Signature Flat White', 'desc': 'Velvety microfoam milk poured over double shot espresso made from house-roasted beans.', 'cat': 'Tea/Coffee', 'price': 340.0, 'pop': true, 'tags': ['coffee', 'flat white', 'espresso']},
      {'name': 'Iced Spanish Latte', 'desc': 'Sweetened condensed milk, whole milk, and dark espresso over crystal ice cubes.', 'cat': 'Tea/Coffee', 'price': 390.0, 'pop': true, 'tags': ['coffee', 'spanish latte', 'iced']},
      {'name': 'Caramel Macchiato', 'desc': 'Steamed milk marked with espresso and finished with ribbons of buttery salted caramel.', 'cat': 'Tea/Coffee', 'price': 380.0, 'pop': false, 'tags': ['coffee', 'macchiato', 'caramel']},
      {'name': 'Vanilla Cold Brew on Ice', 'desc': '16-hour slow steeped cold brew coffee lightly sweetened with Madagascar vanilla syrup.', 'cat': 'Tea/Coffee', 'price': 360.0, 'pop': false, 'tags': ['coffee', 'cold brew', 'iced']},
      {'name': 'Butter Flaky Croissant', 'desc': 'Golden French style croissant with 27 delicate buttery layers baked fresh each morning.', 'cat': 'Bakery', 'price': 240.0, 'pop': true, 'tags': ['croissant', 'bakery', 'french']},
      {'name': 'Almond Cream Croissant', 'desc': 'Twice-baked croissant filled with frangipane almond cream and dusted with powdered sugar.', 'cat': 'Bakery', 'price': 320.0, 'pop': false, 'tags': ['croissant', 'almond', 'bakery']},
      {'name': 'Grilled Chicken Pesto Panini', 'desc': 'Toasted sourdough panini with grilled chicken, basil pesto, sundried tomatoes, and mozzarella.', 'cat': 'Fast Food', 'price': 520.0, 'pop': false, 'tags': ['panini', 'pesto', 'sandwich']},
      {'name': 'Smoked Turkey & Cheese Bagel', 'desc': 'Toasted sesame bagel spread with cream cheese, smoked turkey slices, and arugula.', 'cat': 'Breakfast', 'price': 480.0, 'pop': false, 'tags': ['bagel', 'turkey', 'breakfast']},
      {'name': 'Lotus Cream Cheese Slice', 'desc': 'Creamy chilled cheesecake topped with rich Biscoff spread and cookie crumbs.', 'cat': 'Desserts', 'price': 420.0, 'pop': false, 'tags': ['cheesecake', 'lotus', 'dessert']},
    ],
    // r23: Bake O' Clock Artisan Patisserie
    [
      {'name': 'Fresh Sourdough Bread Loaf', 'desc': 'Naturally fermented artisanal sourdough loaf with blistered crust and chewy airy crumb.', 'cat': 'Bakery', 'price': 380.0, 'pop': true, 'tags': ['bread', 'sourdough', 'bakery']},
      {'name': 'Red Velvet Cupcake (2 Pcs)', 'desc': 'Moist cocoa red velvet sponge crowned with smooth Madagascar vanilla cream cheese frosting.', 'cat': 'Bakery', 'price': 280.0, 'pop': true, 'tags': ['cupcake', 'red velvet', 'bakery']},
      {'name': 'Lotus Biscoff Cheesecake', 'desc': 'Smooth baked cheesecake with speculoos crust and warm cookie butter glaze.', 'cat': 'Desserts', 'price': 460.0, 'pop': true, 'tags': ['cheesecake', 'lotus', 'dessert']},
      {'name': 'Chicken & Mushroom Savory Pie', 'desc': 'Golden puff pastry pot pie stuffed with tender chicken cubes and mushrooms in white sauce.', 'cat': 'Bakery', 'price': 340.0, 'pop': false, 'tags': ['pie', 'savory', 'chicken']},
      {'name': 'Crispy Golden Chicken Patties (2 Pcs)', 'desc': 'Buttery flaky pastry shells filled with mild black pepper chicken filling.', 'cat': 'Bakery', 'price': 180.0, 'pop': false, 'tags': ['patty', 'bakery', 'snack']},
      {'name': 'Nutella Hazelnut Donut', 'desc': 'Fluffy yeast-risen brioche donut injected with pure Nutella and topped with crushed hazelnuts.', 'cat': 'Bakery', 'price': 220.0, 'pop': false, 'tags': ['donut', 'nutella', 'sweet']},
      {'name': 'Cream Cheese Danish Pastry', 'desc': 'Sweet laminated pastry filled with sweet lemon cream cheese and berry preserve.', 'cat': 'Bakery', 'price': 260.0, 'pop': false, 'tags': ['danish', 'pastry', 'bakery']},
      {'name': 'Chocolate Ganache Eclair', 'desc': 'Choux pastry filled with French vanilla custard and dipped in rich dark chocolate ganache.', 'cat': 'Bakery', 'price': 240.0, 'pop': false, 'tags': ['eclair', 'chocolate', 'french']},
      {'name': 'Artisan Macarons Box (4 Pcs)', 'desc': 'Delicate French almond meringue cookies in pistachio, raspberry, chocolate, and salted caramel.', 'cat': 'Desserts', 'price': 420.0, 'pop': false, 'tags': ['macarons', 'french', 'sweet']},
    ],
    // r24: Fit & Fine Healthy Kitchen
    [
      {'name': 'Grilled Lemon Herb Chicken & Veggies', 'desc': 'Marinated chicken breast served with steamed broccoli, carrots, and sweet potato wedges.', 'cat': 'Healthy', 'price': 590.0, 'pop': true, 'tags': ['healthy', 'chicken', 'clean', 'fitness']},
      {'name': 'High-Protein Egg White & Spinach Wrap', 'desc': 'Three egg whites scrambled with baby spinach, tomatoes, and low-fat cottage cheese in whole wheat.', 'cat': 'Healthy', 'price': 420.0, 'pop': true, 'tags': ['healthy', 'egg', 'wrap', 'protein']},
      {'name': 'Sweet Potato & Grilled Salmon Bowl', 'desc': 'Norwegian salmon fillet over baked sweet potato mash, edamame, and cucumber ribbons.', 'cat': 'Healthy', 'price': 890.0, 'pop': true, 'tags': ['salmon', 'healthy', 'fish', 'omega3']},
      {'name': 'Keto Avocado & Feta Salad', 'desc': 'Ripe Hass avocado cubes, Greek feta cheese, cucumber, walnuts, and extra virgin olive oil.', 'cat': 'Healthy', 'price': 520.0, 'pop': false, 'tags': ['keto', 'avocado', 'salad', 'healthy']},
      {'name': 'Peanut Butter Banana Protein Smoothie', 'desc': 'Natural roasted peanut butter, banana, oats, almond milk, and whey protein powder.', 'cat': 'Drinks', 'price': 380.0, 'pop': false, 'tags': ['smoothie', 'protein', 'fitness']},
      {'name': 'Overnight Oats with Berries & Chia', 'desc': 'Rolled oats soaked in almond milk with chia seeds, organic honey, and blueberries.', 'cat': 'Healthy', 'price': 340.0, 'pop': false, 'tags': ['oats', 'healthy', 'breakfast']},
      {'name': 'Grilled Turkey Breast Sandwich', 'desc': 'Whole grain multigrain bread layered with smoked turkey, avocado, and dijon mustard.', 'cat': 'Healthy', 'price': 490.0, 'pop': false, 'tags': ['sandwich', 'turkey', 'healthy']},
      {'name': 'Celery & Green Apple Detox Drink', 'desc': 'Cold-pressed fresh celery stalks, crisp green apples, ginger root, and lemon.', 'cat': 'Drinks', 'price': 290.0, 'pop': false, 'tags': ['detox', 'juice', 'healthy']},
      {'name': 'Sugar-Free Protein Brownie', 'desc': 'Guilt-free dark chocolate brownie made with almond flour, dates, and whey protein.', 'cat': 'Healthy', 'price': 260.0, 'pop': false, 'tags': ['brownie', 'sugar free', 'keto']},
    ],
    // r25: Desi Dastarkhwan Handi & Karahi
    [
      {'name': 'Special Chicken Makhni Handi (Boneless)', 'desc': 'Boneless chicken cubes cooked in creamy butter, roasted cumin, and velvety tomato gravy in clay pot.', 'cat': 'Pakistani', 'price': 1350.0, 'pop': true, 'tags': ['handi', 'makhni', 'chicken', 'desi', 'bestseller']},
      {'name': 'Mutton Brain Masala (Maghaz Fry)', 'desc': 'Fresh mutton brain sauteed with chopped onions, green chilies, ginger, and desi ghee.', 'cat': 'Pakistani', 'price': 850.0, 'pop': true, 'tags': ['maghaz', 'brain masala', 'mutton', 'desi']},
      {'name': 'Daal Mash Fry with Desi Ghee Tarka', 'desc': 'Dry white lentils cooked with golden garlic cloves, button red chilies, and pure desi ghee.', 'cat': 'Pakistani', 'price': 480.0, 'pop': true, 'tags': ['daal', 'daal mash', 'desi ghee', 'tarka']},
      {'name': 'Chicken White Karahi (Cream & Green Chili)', 'desc': 'Rich chicken karahi cooked without red chili in thick spiced yogurt and whipping cream.', 'cat': 'Pakistani', 'price': 1280.0, 'pop': false, 'tags': ['karahi', 'white karahi', 'chicken']},
      {'name': 'Mutton Roghni Handi (Clay Pot)', 'desc': 'Succulent bone-in mutton simmered slowly with whole spices and saffron infused gravy.', 'cat': 'Pakistani', 'price': 1650.0, 'pop': true, 'tags': ['mutton', 'handi', 'clay pot', 'desi']},
      {'name': 'Garlic Butter Naan (Tandoori)', 'desc': 'Puffy hot tandoor naan topped with finely minced garlic, fresh coriander, and melted butter.', 'cat': 'Pakistani', 'price': 90.0, 'pop': false, 'tags': ['naan', 'garlic naan', 'bread']},
      {'name': 'Kalonji Naan', 'desc': 'Crisp tandoori flatbread sprinkled with aromatic black nigella seeds and butter.', 'cat': 'Pakistani', 'price': 80.0, 'pop': false, 'tags': ['naan', 'kalonji', 'bread']},
      {'name': 'Special Dastarkhwan Kheer in Clay Cup', 'desc': 'Slow-reduced milk and rice dessert flavored with green cardamom and crushed pistachios.', 'cat': 'Desserts', 'price': 210.0, 'pop': false, 'tags': ['kheer', 'sweet', 'clay cup']},
      {'name': 'Podina Zeera Raita & Fresh Salad Platter', 'desc': 'Chilled spiced yogurt and crisp garden salad with lemons and green chilies.', 'cat': 'Pakistani', 'price': 140.0, 'pop': false, 'tags': ['raita', 'salad', 'side']},
    ],
  ];

  // Write r1 - r5 foods
  int foodCounter = 1;
  for (final f in foods) {
    buffer.writeln("    FoodItem(");
    buffer.writeln("      id: 'f$foodCounter',");
    buffer.writeln("      restaurantId: '${f['res']}',");
    buffer.writeln("      name: '${f['name'].toString().replaceAll("'", "\\'")}',");
    buffer.writeln("      description: '${f['desc'].toString().replaceAll("'", "\\'")}',");
    buffer.writeln("      image: '${f['img']}',");
    buffer.writeln("      price: ${f['price']},");
    buffer.writeln("      category: '${f['cat']}',");
    buffer.writeln("      rating: ${f['rating']},");
    buffer.writeln("      popular: ${f['pop']},");
    buffer.writeln("      available: true,");
    buffer.writeln("      reviewCount: 45,");
    buffer.writeln("      addOns: [${(f['addons'] as List).map((a) => "'$a'").join(', ')}],");
    buffer.writeln("      tags: [${(f['tags'] as List).map((t) => "'$t'").join(', ')}],");
    buffer.writeln("    ),");
    foodCounter++;
  }

  // Write r6 - r25 foods
  for (int rIdx = 0; rIdx < additionalFoodData.length; rIdx++) {
    final resId = 'r${rIdx + 6}';
    final items = additionalFoodData[rIdx];
    final resObj = restaurants.firstWhere((r) => r['id'] == resId);

    for (final item in items) {
      final img = resObj['image'];
      final tags = (item['tags'] as List).map((t) => "'$t'").join(', ');

      buffer.writeln("    FoodItem(");
      buffer.writeln("      id: 'f$foodCounter',");
      buffer.writeln("      restaurantId: '$resId',");
      buffer.writeln("      name: '${item['name'].toString().replaceAll("'", "\\'")}',");
      buffer.writeln("      description: '${item['desc'].toString().replaceAll("'", "\\'")}',");
      buffer.writeln("      image: '$img',");
      buffer.writeln("      price: ${item['price']},");
      buffer.writeln("      category: '${item['cat']}',");
      buffer.writeln("      rating: 4.8,");
      buffer.writeln("      popular: ${item['pop']},");
      buffer.writeln("      available: true,");
      buffer.writeln("      reviewCount: 65,");
      buffer.writeln("      addOns: ['Extra Sauce', 'Side Salad', 'Extra Portion'],");
      buffer.writeln("      tags: [$tags],");
      buffer.writeln("    ),");
      foodCounter++;
    }
  }

  buffer.writeln("  ];");
  buffer.writeln("");

  // Coupons
  buffer.writeln("  static final List<Coupon> coupons = [");
  final coupons = [
    {
      'code': 'WELCOME50',
      'discount': 50.0,
      'isPercent': true,
      'min': 350.0,
      'title': '50% OFF Welcome Deal',
      'desc': 'Get 50% discount up to Rs. 200 on your first food order in Bahawalpur.',
    },
    {
      'code': 'FOOD100',
      'discount': 100.0,
      'isPercent': false,
      'min': 500.0,
      'title': 'Flat Rs. 100 OFF',
      'desc': 'Save flat Rs. 100 on all orders above Rs. 500.',
    },
    {
      'code': 'FREEDELIVERY',
      'discount': 120.0,
      'isPercent': false,
      'min': 500.0,
      'title': 'Free Delivery Pass',
      'desc': 'Zero delivery fees on all restaurant orders above Rs. 500.',
    },
    {
      'code': 'WELCOME10',
      'discount': 10.0,
      'isPercent': true,
      'min': 400.0,
      'title': '10% OFF Welcome Bonus',
      'desc': 'Get 10% discount on orders across all 25 restaurants in Bahawalpur.',
    },
    {
      'code': 'FEAST20',
      'discount': 20.0,
      'isPercent': true,
      'min': 1000.0,
      'title': '20% OFF Desi & BBQ Feast',
      'desc': 'Special 20% discount on orders of Rs. 1,000 or more on Handi and BBQ.',
    },
    {
      'code': 'FREESHIP',
      'discount': 120.0,
      'isPercent': false,
      'min': 600.0,
      'title': 'Free Delivery Express',
      'desc': 'Enjoy zero delivery fees on orders above Rs. 600 from nearby spots.',
    },
    {
      'code': 'BIRYANI15',
      'discount': 15.0,
      'isPercent': true,
      'min': 600.0,
      'title': '15% OFF Biryani & Rice',
      'desc': 'Save 15% on all your favorite Dum Biryani and Pulao cravings.',
    },
    {
      'code': 'BURGER20',
      'discount': 20.0,
      'isPercent': true,
      'min': 500.0,
      'title': '20% OFF Burgers & Broast',
      'desc': 'Get 20% discount on gourmet smashed burgers, fried chicken and loaded wraps.',
    },
    {
      'code': 'FLAT300',
      'discount': 300.0,
      'isPercent': false,
      'min': 1500.0,
      'title': 'Rs. 300 FLAT OFF',
      'desc': 'Save big with Rs. 300 flat reduction on family gatherings and group orders.',
    },
    {
      'code': 'WEEKEND25',
      'discount': 25.0,
      'isPercent': true,
      'min': 1200.0,
      'title': '25% OFF Weekend Special',
      'desc': 'Exclusive 25% discount for weekend family feasts and party platters.',
    },
    {
      'code': 'FAMILY500',
      'discount': 500.0,
      'isPercent': false,
      'min': 2500.0,
      'title': 'Rs. 500 Family Feast Deal',
      'desc': 'Flat Rs. 500 off on large family gatherings, platters and dinner parties.',
    },
  ];

  for (final c in coupons) {
    buffer.writeln("    Coupon(");
    buffer.writeln("      code: '${c['code']}',");
    buffer.writeln("      discountValue: ${c['discount']},");
    buffer.writeln("      isPercentage: ${c['isPercent']},");
    buffer.writeln("      minOrderAmount: ${c['min']},");
    buffer.writeln("      title: '${c['title']}',");
    buffer.writeln("      description: '${c['desc']}',");
    buffer.writeln("    ),");
  }
  buffer.writeln("  ];");
  buffer.writeln("");

  // Helper query methods
  buffer.writeln(r'''
  static List<Restaurant> getRestaurantsForCategory(String category) {
    if (category == 'All') return List<Restaurant>.from(restaurants);
    final catLower = category.toLowerCase().trim();
    return restaurants.where((r) {
      if (r.cuisine.toLowerCase() == catLower || r.cuisine.toLowerCase().contains(catLower)) return true;
      if (catLower == 'desi' || catLower == 'karahi') {
        if (r.cuisine.toLowerCase().contains('pakistani') || r.cuisine.toLowerCase().contains('biryani')) return true;
      }
      return foods.any((f) =>
          f.restaurantId == r.id &&
          (f.category.toLowerCase() == catLower ||
              f.category.toLowerCase().contains(catLower) ||
              f.name.toLowerCase().contains(catLower) ||
              f.tags.any((t) => t.toLowerCase() == catLower)));
    }).toList();
  }

  static List<FoodItem> getFoodsForCategory(String category) {
    if (category == 'All') return List<FoodItem>.from(foods);
    final catLower = category.toLowerCase().trim();
    return foods.where((f) {
      if (catLower == 'desi' || catLower == 'karahi') {
        return f.category.toLowerCase().contains('pakistani') ||
            f.category.toLowerCase().contains('biryani') ||
            f.name.toLowerCase().contains('karahi') ||
            f.name.toLowerCase().contains('handi') ||
            f.tags.contains('desi') ||
            f.tags.contains('karahi');
      }
      return f.category.toLowerCase() == catLower ||
          f.category.toLowerCase().contains(catLower) ||
          f.name.toLowerCase().contains(catLower) ||
          f.tags.any((t) => t.toLowerCase() == catLower);
    }).toList();
  }

  static List<Restaurant> getRestaurantsForArea(String area) {
    if (area.isEmpty || area == 'All' || area == 'All Areas') {
      return List<Restaurant>.from(restaurants);
    }
    final areaLower = area.toLowerCase().trim();
    return restaurants.where((r) =>
        r.area.toLowerCase().contains(areaLower) ||
        r.address.toLowerCase().contains(areaLower)).toList();
  }

  static List<FoodItem> getPopularDishes() {
    return foods.where((f) => f.popular).toList();
  }

  static Restaurant? getRestaurantById(String id) {
    try {
      return restaurants.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  static FoodItem? getFoodById(String id) {
    try {
      return foods.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  // Curated diverse subsets to eliminate duplicate restaurants in adjacent Home sections
  static List<Restaurant> getPopularRestaurants() {
    const popularIds = {'r3', 'r7', 'r13', 'r15', 'r21', 'r25'};
    final list = restaurants.where((r) => popularIds.contains(r.id)).toList();
    return list.isNotEmpty ? list : restaurants.where((r) => r.isPopular).toList();
  }

  static List<Restaurant> getTopRatedRestaurants() {
    const topRatedIds = {'r2', 'r8', 'r10', 'r14', 'r18', 'r22'};
    final list = restaurants.where((r) => topRatedIds.contains(r.id)).toList();
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list.isNotEmpty ? list : restaurants.where((r) => r.rating >= 4.8).toList();
  }

  static List<Restaurant> getFastDeliveryRestaurants() {
    const fastIds = {'r5', 'r12', 'r17', 'r19', 'r23', 'r1'};
    final list = restaurants.where((r) => fastIds.contains(r.id)).toList();
    list.sort((a, b) => a.distance.compareTo(b.distance));
    return list.isNotEmpty ? list : restaurants.where((r) => r.deliveryTime.contains('15')).toList();
  }

  static List<Restaurant> getDealRestaurants() {
    const dealIds = {'r4', 'r6', 'r9', 'r11', 'r20', 'r24'};
    final list = restaurants.where((r) => dealIds.contains(r.id)).toList();
    return list.isNotEmpty ? list : restaurants.where((r) => r.offer != null).toList();
  }

  static List<Restaurant> getNearbyRestaurants() {
    final list = List<Restaurant>.from(restaurants);
    list.sort((a, b) => a.distance.compareTo(b.distance));
    return list;
  }

  static List<Restaurant> getRecommendedRestaurants() {
    final list = List<Restaurant>.from(restaurants);
    return list;
  }
}
''');

  final file = File(r'c:\Users\umair\Desktop\food_delivery_app\lib\core\sample_data.dart');
  file.writeAsStringSync(buffer.toString());
}
