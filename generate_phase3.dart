import 'dart:io';

void main() {
  final baseDir = r'c:\Users\umair\Desktop\food_delivery_app\lib';

  final files = {
    'models/user.dart': r'''
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  
  UserModel({required this.id, required this.name, required this.email, required this.phone});
  
  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email, 'phone': phone};
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(id: json['id'], name: json['name'], email: json['email'], phone: json['phone']);
}
''',
    'models/notification.dart': r'''
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime date;
  final bool isRead;

  AppNotification({required this.id, required this.title, required this.message, required this.date, this.isRead = false});
}
''',
    'models/cart_item.dart': r'''
import 'food_item.dart';

class CartItem {
  final FoodItem food;
  int quantity;
  final List<String> customizations;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.customizations = const [],
  });
  
  // Example: flat $1.00 per customization
  double get totalPrice => (food.price + (customizations.length * 1.0)) * quantity;
}
''',
    'providers/auth_provider.dart': r'''
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import 'app_providers.dart';

class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    final storage = ref.watch(storageServiceProvider);
    final userJson = storage.getString('current_user');
    if (userJson != null) return UserModel.fromJson(jsonDecode(userJson));
    return null;
  }

  Future<void> login(String email, String password) async {
    // Mock authentication
    final user = UserModel(id: 'u1', name: 'John Doe', email: email, phone: '+1234567890');
    state = user;
    await ref.read(storageServiceProvider).setString('current_user', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    state = null;
    await ref.read(storageServiceProvider).remove('current_user');
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());
''',
    'screens/auth/login_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../main_navigation.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  void doLogin() {
    if (emailController.text.isNotEmpty && passController.text.isNotEmpty) {
      ref.read(authProvider.notifier).login(emailController.text, passController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid details')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welcome Back', style: AppStyles.title, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: doLogin,
                child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              TextButton(onPressed: () {}, child: const Text('Forgot Password?')),
            ],
          ),
        ),
      ),
    );
  }
}
''',
    'screens/order_tracking_screen.dart': r'''
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../core/constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;
  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order', style: TextStyle(color: AppColors.textDark)), backgroundColor: AppColors.white, iconTheme: const IconThemeData(color: AppColors.textDark)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text('Order #${order.id.substring(0,8)}', style: AppStyles.title),
            const SizedBox(height: 32),
            _buildTimelineItem('Order Placed', true),
            _buildTimelineItem('Confirmed', order.status.index >= 1),
            _buildTimelineItem('Preparing', order.status.index >= 2),
            _buildTimelineItem('Out for Delivery', order.status.index >= 3),
            _buildTimelineItem('Delivered', order.status.index >= 4, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isDone ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isDone ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: isDone ? Colors.green : Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 16),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: isDone ? FontWeight.bold : FontWeight.normal, color: isDone ? AppColors.textDark : AppColors.textLight)),
      ],
    );
  }
}
''',
    'screens/food_details_screen.dart': r'''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class FoodDetailsScreen extends ConsumerStatefulWidget {
  final FoodItem food;
  const FoodDetailsScreen({super.key, required this.food});

  @override
  ConsumerState<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends ConsumerState<FoodDetailsScreen> {
  int quantity = 1;
  final List<String> selectedAddons = [];
  final addons = ['Extra Cheese', 'Extra Sauce', 'Bacon'];

  void toggleAddon(String addon) {
    setState(() {
      if (selectedAddons.contains(addon)) selectedAddons.remove(addon);
      else selectedAddons.add(addon);
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = (widget.food.price + (selectedAddons.length * 1.0)) * quantity;
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.food.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(widget.food.image, height: 200, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, e, s) => Container(height: 200, color: Colors.grey))),
            const SizedBox(height: 16),
            Text(widget.food.name, style: AppStyles.title),
            Text('\$${widget.food.price}', style: TextStyle(fontSize: 20, color: AppColors.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.food.description, style: AppStyles.body),
            const SizedBox(height: 24),
            const Text('Add-ons (+$1.00 each)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...addons.map((a) => CheckboxListTile(
              title: Text(a),
              value: selectedAddons.contains(a),
              onChanged: (val) => toggleAddon(a),
            )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline, size: 32), onPressed: () => setState(() => quantity > 1 ? quantity-- : null)),
                Text('$quantity', style: const TextStyle(fontSize: 24)),
                IconButton(icon: const Icon(Icons.add_circle_outline, size: 32), onPressed: () => setState(() => quantity++)),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  final cartNotifier = ref.read(cartProvider.notifier);
                  final item = CartItem(food: widget.food, quantity: quantity, customizations: selectedAddons);
                  if (!cartNotifier.canAddItem(widget.food.restaurantId)) {
                     // trigger replacement logic
                     cartNotifier.replaceCart(item);
                  } else {
                     cartNotifier.addItem(item);
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart!')));
                },
                child: Text('Add to Cart - \$${total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      )
    );
  }
}
'''
  };

  files.forEach((path, content) {
    final file = File('$baseDir\\$path');
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    file.writeAsStringSync(content);
  });
}
