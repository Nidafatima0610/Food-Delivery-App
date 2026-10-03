class Restaurant {
  final String id;
  final String name;
  final String image;
  final String cuisine;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final double distance;
  final bool featured;
  final bool isOpen;
  final String description;
  final String address;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.distance,
    this.featured = false,
    this.isOpen = true,
    this.description = 'Authentic food made fresh with quality ingredients.',
    this.address = 'Main Boulevard, Gulberg, Lahore',
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'image': image, 'cuisine': cuisine,
    'rating': rating, 'reviewCount': reviewCount, 'deliveryTime': deliveryTime,
    'deliveryFee': deliveryFee, 'minimumOrder': minimumOrder, 'distance': distance,
    'featured': featured, 'isOpen': isOpen,
    'description': description, 'address': address,
  };

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'], name: json['name'], image: json['image'], cuisine: json['cuisine'],
    rating: (json['rating'] ?? 0.0).toDouble(), reviewCount: json['reviewCount'] ?? 100, deliveryTime: json['deliveryTime'] ?? '25-35 min',
    deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(), minimumOrder: (json['minimumOrder'] ?? 0.0).toDouble(), distance: (json['distance'] ?? 0.0).toDouble(),
    featured: json['featured'] ?? false, isOpen: json['isOpen'] ?? true,
    description: json['description'] ?? 'Authentic food made fresh with quality ingredients.',
    address: json['address'] ?? 'Main Boulevard, Gulberg, Lahore',
  );
}
