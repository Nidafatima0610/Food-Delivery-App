import 'package:flutter/material.dart';
import '../core/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About App', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // App Logo & Branding
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF4B3A), Color(0xFFFF7A59)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'BiteNow Bahawalpur',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Your local food, delivered.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.2.0 • Build 2026.10',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // Description Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About the Application', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'BiteNow is crafted to celebrate and deliver the finest authentic flavors of Bahawalpur. From famous Dum Biryani at Farid Gate to sizzling charcoal BBQ on Circular Road and gourmet cafes in Cantt and Model Town, we bring your neighborhood kitchen directly to your doorstep.',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Key Capabilities Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Key Capabilities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 14),
                  _buildCapabilityTile(
                    Icons.explore_outlined,
                    'Curated Local Discovery',
                    'Explore over 25+ unique Bahawalpur restaurants, home kitchens, and hidden street gems.',
                  ),
                  const Divider(height: 20),
                  _buildCapabilityTile(
                    Icons.local_offer_outlined,
                    'Exclusive Deals & Coupons',
                    'Save with percentage discounts, free delivery promos, and weekend family deals.',
                  ),
                  const Divider(height: 20),
                  _buildCapabilityTile(
                    Icons.delivery_dining_outlined,
                    'Real-Time Order Tracking',
                    'Follow your meal step-by-step from kitchen preparation to out for delivery.',
                  ),
                  const Divider(height: 20),
                  _buildCapabilityTile(
                    Icons.refresh_rounded,
                    'One-Tap Reordering',
                    'Quickly reorder your favorite meals from past orders without searching again.',
                  ),
                  const Divider(height: 20),
                  _buildCapabilityTile(
                    Icons.location_on_outlined,
                    'Hyperlocal Neighborhood Support',
                    'Tailored delivery for Model Town, Cantt, Farid Gate, Dubai Chowk, Satellite Town, and more.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Footer
            Text(
              'Made with ❤️ for food lovers in Bahawalpur',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(
              '© 2026 BiteNow Delivery. All rights reserved.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilityTile(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
