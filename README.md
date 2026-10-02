# Food Delivery Application

A robust, professional, and full-featured Food Delivery App built with Flutter.

## 📱 Purpose
This application simulates a complete food delivery experience, allowing users to browse restaurants, search for specific food items, customize their orders, apply coupons, and checkout seamlessly. It demonstrates modern Flutter UI/UX, responsive design, and solid local state management.

## ✨ Main Features
- **Discovery & Search:** Browse popular categories, find restaurants, and search for specific meals or eateries.
- **Detailed Restaurant Views:** View restaurant menus grouped by categories, ratings, delivery times, and more.
- **Food Customization:** Add items to cart with specific quantity and add-ons (extra cheese, sauce, etc.).
- **Smart Cart:** Features a single-restaurant cart rule. Prevents accidental loss of cart items with a smart replacement confirmation.
- **Checkout & Offers:** Apply coupon codes (e.g., `WELCOME10`), select addresses and payment methods, and see real-time price calculation (subtotal, delivery fee, discount).
- **Order Tracking & History:** View past orders, reorder favorites, and see order success screens.
- **Favorites:** Bookmark favorite restaurants/foods.
- **Persistent Data:** Carts, orders, favorites, and settings are saved locally and persist across app restarts using `shared_preferences`.

## 🛠 Technologies & Architecture
- **Framework:** Flutter (Dart)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Persistence:** Local Storage (`shared_preferences`)
- **Design:** Custom theming, carefully picked typography (`google_fonts`), and micro-animations.

## 📍 Screens Included
- Home Screen
- Search Screen
- Category Views
- Restaurant Details
- Food Customization Modal/Screen
- Cart
- Checkout
- Order Success
- Order History
- Profile & Settings (Dark mode toggle, notifications)

## 🚀 How to Run
1. Ensure you have Flutter SDK installed (`>=3.13.1`).
2. Clone this repository or open the project folder.
3. Run `flutter pub get` to install dependencies.
4. Run the app on an emulator or physical device using `flutter run`.

## 🔮 Future Improvements
- Integrate backend APIs (Firebase or custom Node.js/Python backend).
- Add real-time GPS tracking for delivery drivers.
- Implement live push notifications.
- Integrate real payment gateways (Stripe, PayPal).

---
*Ready for internship demonstration and submission.*
