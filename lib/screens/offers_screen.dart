import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../core/sample_data.dart';
import '../providers/app_providers.dart';
import 'checkout_screen.dart';
import 'restaurant_list_screen.dart';

class OffersScreen extends ConsumerWidget {
  const OffersScreen({super.key});

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text('Promo code "$code" copied to clipboard!')),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _applyCouponAction(BuildContext context, WidgetRef ref, String code) {
    final cart = ref.read(cartProvider);
    if (cart.items.isNotEmpty) {
      _copyCode(context, code);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CheckoutScreen(initialCouponCode: code)),
      );
    } else {
      _copyCode(context, code);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 22),
              const SizedBox(width: 8),
              Expanded(child: Text('Code "$code" Copied!')),
            ],
          ),
          content: const Text(
            'Your cart is currently empty. Would you like to explore top Bahawalpur restaurants to use this deal?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Later'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RestaurantListScreen(title: 'All Restaurants')),
                );
              },
              child: const Text('Browse Restaurants', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coupons = SampleData.coupons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Deals', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          final discountBadge = coupon.isPercentage
              ? '${coupon.discountValue.toInt()}% OFF'
              : 'FLAT ${AppFormatters.currency(coupon.discountValue)} OFF';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Icon, Title & Badge (Responsive)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.local_offer, color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    coupon.title.isNotEmpty ? coupon.title : discountBadge,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.green.shade200),
                                  ),
                                  child: Text(
                                    discountBadge,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Min. order: ${AppFormatters.currency(coupon.minOrderAmount)}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if (coupon.description.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      coupon.description,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Bottom Action Bar: Code Pill & Buttons (Responsive Wrap Layout to guarantee ZERO overflow)
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Coupon Code Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300, style: BorderStyle.solid),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.vpn_key_outlined, size: 14, color: Colors.amber.shade900),
                            const SizedBox(width: 6),
                            Text(
                              coupon.code,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.amber.shade900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action Buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              visualDensity: VisualDensity.compact,
                            ),
                            icon: const Icon(Icons.copy, size: 14),
                            label: const Text('Copy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            onPressed: () => _copyCode(context, coupon.code),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () => _applyCouponAction(context, ref, coupon.code),
                            child: const Text(
                              'Apply',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
