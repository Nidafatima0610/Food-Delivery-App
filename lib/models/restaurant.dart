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
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'image': image, 'cuisine': cuisine,
    'rating': rating, 'reviewCount': reviewCount, 'deliveryTime': deliveryTime,
    'deliveryFee': deliveryFee, 'minimumOrder': minimumOrder, 'distance': distance,
    'featured': featured, 'isOpen': isOpen,
  };

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'], name: json['name'], image: json['image'], cuisine: json['cuisine'],
    rating: (json['rating'] ?? 0.0).toDouble(), reviewCount: json['reviewCount'], deliveryTime: json['deliveryTime'],
    deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(), minimumOrder: (json['minimumOrder'] ?? 0.0).toDouble(), distance: (json['distance'] ?? 0.0).toDouble(),
    featured: json['featured'], isOpen: json['isOpen'],
  );
}
