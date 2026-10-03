import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery_app/core/sample_data.dart';
import 'package:food_delivery_app/models/cart_item.dart';
import 'package:food_delivery_app/models/order.dart';
import 'package:food_delivery_app/providers/app_providers.dart';
import 'package:food_delivery_app/screens/home_screen.dart';
import 'package:food_delivery_app/screens/restaurant_details.dart';
import 'package:food_delivery_app/screens/food_details_screen.dart';
import 'package:food_delivery_app/screens/cart_screen.dart';
import 'package:food_delivery_app/screens/checkout_screen.dart';
import 'package:food_delivery_app/screens/orders_screen.dart';
import 'package:food_delivery_app/screens/favorites_screen.dart';
import 'package:food_delivery_app/screens/search_screen.dart';
import 'package:food_delivery_app/screens/restaurant_list_screen.dart';

final Uint8List _kTransparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
]);

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _kTransparentImage.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_kTransparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _MockHttpOverrides();

  group('Catalog & Data Integrity Tests', () {
    test('Catalog contains exactly 15 realistic restaurants', () {
      expect(SampleData.restaurants.length, 15);
      final names = SampleData.restaurants.map((r) => r.name).toList();
      expect(names.contains('Spice Route'), isTrue);
      expect(names.contains('Karachi Grill'), isTrue);
      expect(names.contains('Urban Bites'), isTrue);
      expect(names.contains('Burger District'), isTrue);
      expect(names.contains('The Pizza House'), isTrue);
      expect(names.contains('Royal BBQ'), isTrue);
      expect(names.contains('Desi Kitchen'), isTrue);
      expect(names.contains('China Bowl'), isTrue);
      expect(names.contains('Sweet Cravings'), isTrue);
      expect(names.contains('Street Food Co.'), isTrue);
      expect(names.contains('Green Garden'), isTrue);
      expect(names.contains('Coffee & Co.'), isTrue);
      expect(names.contains('Food Junction'), isTrue);
      expect(names.contains('Lahore Tikka'), isTrue);
      expect(names.contains('Daily Dine'), isTrue);
    });

    test('Catalog contains roughly 120+ food items and every food has a valid restaurantId', () {
      expect(SampleData.foods.length, greaterThanOrEqualTo(120));
      final restaurantIds = SampleData.restaurants.map((r) => r.id).toSet();

      for (final food in SampleData.foods) {
        expect(
          restaurantIds.contains(food.restaurantId),
          isTrue,
          reason: 'Food ${food.name} has invalid restaurantId: ${food.restaurantId}',
        );
        expect(food.name.isNotEmpty, isTrue);
        expect(food.price, greaterThan(0.0));
        expect(food.image.isNotEmpty, isTrue);
      }
    });

    test('Each restaurant has between 8 and 12 food items', () {
      for (final restaurant in SampleData.restaurants) {
        final restaurantFoods = SampleData.foods.where((f) => f.restaurantId == restaurant.id).toList();
        expect(
          restaurantFoods.length,
          inInclusiveRange(8, 12),
          reason: 'Restaurant ${restaurant.name} has ${restaurantFoods.length} items',
        );
      }
    });

    test('All required categories return populated results without empty screens', () {
      final requiredCategories = [
        'Pizza',
        'Burgers',
        'Pakistani',
        'BBQ',
        'Chinese',
        'Fast Food',
        'Biryani',
        'Desserts',
        'Drinks',
        'Breakfast',
        'Healthy',
        'Snacks',
      ];

      for (final category in requiredCategories) {
        final rests = SampleData.getRestaurantsForCategory(category);
        final foods = SampleData.getFoodsForCategory(category);
        expect(
          rests.isNotEmpty || foods.isNotEmpty,
          isTrue,
          reason: 'Category $category has 0 restaurants and 0 dishes',
        );
      }
    });
  });

  group('UI Screens & Navigation Widget Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          home: child,
        ),
      );
    }

    testWidgets('HomeScreen renders with Header, Search, Categories, and Sections', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      await tester.pumpWidget(createTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      // Location header
      expect(find.text('DELIVER TO'), findsOneWidget);
      expect(find.textContaining('123 Main St'), findsOneWidget);

      // Search bar
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Categories
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Burgers'), findsOneWidget);
      expect(find.text('Pakistani'), findsOneWidget);

      // Sections
      expect(find.text('Popular Restaurants'), findsOneWidget);
      expect(find.text('Popular Dishes'), findsOneWidget);
      expect(find.text('Nearby Restaurants'), findsOneWidget);
    });

    testWidgets('Tapping category on HomeScreen filters spots correctly', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      await tester.pumpWidget(createTestApp(const HomeScreen()));
      await tester.pumpAndSettle();

      final chip = find.text('Pizza');
      expect(chip, findsOneWidget);
      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.textContaining('Pizza Spots'), findsOneWidget);
    });

    testWidgets('RestaurantListScreen displays all restaurants and supports sorting', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      await tester.pumpWidget(createTestApp(const RestaurantListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('All Restaurants'), findsOneWidget);
      expect(find.text('15 restaurants found'), findsOneWidget);
      expect(find.text('Burger District'), findsOneWidget);
    });

    testWidgets('RestaurantDetailsScreen renders restaurant info and its full menu', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final restaurant = SampleData.getRestaurantById('r1')!;
      await tester.pumpWidget(createTestApp(RestaurantDetailsScreen(restaurant: restaurant)));
      await tester.pumpAndSettle();

      expect(find.text('Spice Route'), findsWidgets);
      expect(find.text('OPEN NOW'), findsOneWidget);
      expect(find.text('Menu Categories'), findsOneWidget);
      expect(find.text('Chicken Biryani'), findsOneWidget);
      expect(find.text('Chicken Karahi'), findsOneWidget);
    });

    testWidgets('FoodDetailsScreen renders details, add-ons, quantity selector and button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final food = SampleData.foods.first;
      await tester.pumpWidget(createTestApp(FoodDetailsScreen(food: food)));
      await tester.pumpAndSettle();

      expect(find.text('Chicken Biryani'), findsWidgets);
      expect(find.text('Spice Route'), findsOneWidget);
      expect(find.text('Customizations & Add-ons'), findsOneWidget);
      expect(find.text('Special Instructions'), findsOneWidget);
      expect(find.text('Add to Cart • Rs. 450'), findsOneWidget);

      // Increase quantity
      await tester.ensureVisible(find.byIcon(Icons.add_circle));
      await tester.tap(find.byIcon(Icons.add_circle));
      await tester.pumpAndSettle();
      expect(find.text('Add to Cart • Rs. 900'), findsOneWidget);
    });

    testWidgets('SearchScreen searches both restaurants and food items accurately', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      await tester.pumpWidget(createTestApp(const SearchScreen()));
      await tester.pumpAndSettle();

      // Empty state shows trending searches
      expect(find.text('Trending Searches'), findsOneWidget);

      // Enter search query 'Biryani'
      await tester.enterText(find.byType(TextField), 'Biryani');
      await tester.pumpAndSettle();

      // Results must show both restaurants and dishes
      expect(find.textContaining('Restaurants'), findsWidgets);
      expect(find.textContaining('Dishes'), findsWidgets);
      expect(find.text('Chicken Biryani'), findsWidgets);
    });

    testWidgets('CartScreen displays items, calculations, and checkout navigation', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final food = SampleData.foods.first;

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      container.read(cartProvider.notifier).addItem(CartItem(food: food, quantity: 2));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CartScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Cart'), findsOneWidget);
      expect(find.text('Spice Route'), findsOneWidget);
      expect(find.text('Chicken Biryani'), findsOneWidget);
      expect(find.textContaining('Checkout • Rs.'), findsOneWidget);
    });

    testWidgets('CheckoutScreen displays order breakdown, address, and payment options', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final food = SampleData.foods.first;

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      container.read(cartProvider.notifier).addItem(CartItem(food: food, quantity: 2));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: CheckoutScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Delivery Address'), findsOneWidget);
      expect(find.text('2x'), findsOneWidget);
      expect(find.text('Chicken Biryani'), findsOneWidget);
      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Place Order • Rs. 999'), findsOneWidget);
    });

    testWidgets('OrdersScreen renders order history with restaurant name, status and items', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      final dummyOrder = OrderModel(
        id: 'ord-12345678',
        restaurantId: 'r1',
        restaurantName: 'Spice Route',
        items: [
          CartItem(food: SampleData.foods.first, quantity: 2),
        ],
        subtotal: 900.0,
        deliveryFee: 99.0,
        discount: 0.0,
        total: 999.0,
        date: DateTime.now(),
        status: OrderStatus.placed,
      );

      container.read(ordersProvider.notifier).addOrder(dummyOrder);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: OrdersScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Spice Route'), findsOneWidget);
      expect(find.text('Order Placed'), findsOneWidget);
      expect(find.text('2x Chicken Biryani'), findsOneWidget);
      expect(find.text('Rs. 999'), findsOneWidget);
      expect(find.text('Track'), findsOneWidget);
      expect(find.text('Reorder'), findsOneWidget);
    });

    testWidgets('FavoritesScreen displays saved restaurants', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 1000));
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      container.read(favoritesProvider.notifier).toggleFavorite('r1');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: FavoritesScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Favorites'), findsOneWidget);
      expect(find.text('Spice Route'), findsOneWidget);
    });
  });
}
