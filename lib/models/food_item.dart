class FoodItem {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String image;
  final double price;
  final String category;
  final double rating;
  final bool popular;
  final bool available;
  final int reviewCount;
  final List<String> addOns;

  FoodItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.rating,
    this.popular = false,
    this.available = true,
    this.reviewCount = 45,
    this.addOns = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'restaurantId': restaurantId, 'name': name, 'description': description,
    'image': image, 'price': price, 'category': category, 'rating': rating,
    'popular': popular, 'available': available,
    'reviewCount': reviewCount, 'addOns': addOns,
  };

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
    id: json['id'], restaurantId: json['restaurantId'], name: json['name'], description: json['description'],
    image: json['image'], price: (json['price'] ?? 0.0).toDouble(), category: json['category'], rating: (json['rating'] ?? 0.0).toDouble(),
    popular: json['popular'] ?? false, available: json['available'] ?? true,
    reviewCount: json['reviewCount'] ?? 45,
    addOns: List<String>.from(json['addOns'] ?? []),
  );
}
