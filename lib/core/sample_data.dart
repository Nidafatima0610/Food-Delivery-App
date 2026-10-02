import '../models/restaurant.dart';
import '../models/food_item.dart';
import '../models/coupon.dart';

class SampleData {
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: 'r1',
      name: 'Burger King',
      image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500',
      cuisine: 'Fast Food',
      rating: 4.5,
      reviewCount: 120,
      deliveryTime: '20-30 min',
      deliveryFee: 2.99,
      minimumOrder: 10.0,
      distance: 1.2,
      featured: true,
    ),
    Restaurant(
      id: 'r2',
      name: 'Pizza Hut',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
      cuisine: 'Italian',
      rating: 4.2,
      reviewCount: 85,
      deliveryTime: '30-40 min',
      deliveryFee: 3.99,
      minimumOrder: 15.0,
      distance: 2.5,
    ),
    Restaurant(
      id: 'r3',
      name: 'Spice of India',
      image: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500',
      cuisine: 'Indian',
      rating: 4.8,
      reviewCount: 200,
      deliveryTime: '40-50 min',
      deliveryFee: 0.0,
      minimumOrder: 20.0,
      distance: 3.1,
      featured: true,
    )
  ];

  static final List<FoodItem> foods = [
    FoodItem(
      id: 'f1',
      restaurantId: 'r1',
      name: 'Whopper',
      description: 'Classic flame-grilled beef burger',
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
      price: 6.99,
      category: 'Burgers',
      rating: 4.6,
      popular: true,
    ),
    FoodItem(
      id: 'f2',
      restaurantId: 'r1',
      name: 'Fries',
      description: 'Crispy golden fries',
      image: 'https://images.unsplash.com/photo-1576107232684-1279f390859f?w=500',
      price: 2.99,
      category: 'Fast Food',
      rating: 4.2,
    ),
    FoodItem(
      id: 'f3',
      restaurantId: 'r2',
      name: 'Pepperoni Pizza',
      description: 'Large pizza with pepperoni and extra cheese',
      image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500',
      price: 14.99,
      category: 'Pizza',
      rating: 4.7,
      popular: true,
    ),
  ];

  static final List<String> categories = [
    'All', 'Burgers', 'Pizza', 'Fast Food', 'Chinese', 'Healthy', 'Desserts', 'Drinks'
  ];

  static final List<Coupon> coupons = [
    Coupon(code: 'WELCOME10', discountValue: 10, isPercentage: true, minOrderAmount: 20),
    Coupon(code: 'FLAT5', discountValue: 5, isPercentage: false, minOrderAmount: 15),
  ];
}
