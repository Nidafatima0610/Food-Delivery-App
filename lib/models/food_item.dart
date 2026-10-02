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
  });
}
