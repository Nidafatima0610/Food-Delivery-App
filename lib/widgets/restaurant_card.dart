import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'app_image.dart';

class RestaurantCard extends ConsumerWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AppImage(
                    imageUrl: restaurant.image,
                    height: 170,
                    width: double.infinity,
                    category: restaurant.cuisine,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  Builder(builder: (context) {
                    final badge = _buildSmartBadge(restaurant);
                    if (badge != null) {
                      return Positioned(
                        top: 12,
                        left: 12,
                        child: badge,
                      );
                    }
                    return const SizedBox();
                  }),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        iconSize: 22,
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : AppColors.textDark,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: AppStyles.subtitle.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                restaurant.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF8A5300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${restaurant.cuisine} • ${restaurant.address}',
                      style: AppStyles.body.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 15, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.deliveryTime,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.delivery_dining, size: 17, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.deliveryFee == 0 ? 'Free' : AppFormatters.currency(restaurant.deliveryFee),
                          style: TextStyle(
                            fontSize: 12,
                            color: restaurant.deliveryFee == 0 ? Colors.green.shade700 : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.near_me, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${restaurant.distance.toStringAsFixed(1)} km',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget? _buildSmartBadge(Restaurant restaurant) {
    String? label;
    Color color = AppColors.primary;

    if (restaurant.rating >= 4.8) {
      label = '★ Top Rated';
      color = const Color(0xFFD97706);
    } else if (restaurant.deliveryFee == 0) {
      label = 'Free Delivery';
      color = const Color(0xFF16A34A);
    } else if (restaurant.deliveryTime.contains('15') || restaurant.deliveryTime.contains('20')) {
      label = '⚡ Fast Delivery';
      color = const Color(0xFF2563EB);
    } else if (restaurant.id == 'r1' || restaurant.id == 'r5') {
      label = '20% OFF';
      color = const Color(0xFFE11D48);
    } else if (restaurant.featured) {
      label = 'Popular';
      color = AppColors.primary;
    }

    if (label == null) return null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class RestaurantHorizontalCard extends ConsumerWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantHorizontalCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(restaurant.id);

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AppImage(
                    imageUrl: restaurant.image,
                    height: 105,
                    width: 220,
                    category: restaurant.cuisine,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  Builder(builder: (context) {
                    final badge = RestaurantCard._buildSmartBadge(restaurant);
                    if (badge != null) {
                      return Positioned(
                        top: 6,
                        left: 6,
                        child: badge,
                      );
                    }
                    return const SizedBox();
                  }),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 18,
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : AppColors.textDark,
                        ),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(restaurant.id);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${restaurant.cuisine} • ${restaurant.deliveryTime}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 3),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const Spacer(),
                        Text(
                          restaurant.deliveryFee == 0 ? 'Free Delivery' : '${AppFormatters.currency(restaurant.deliveryFee)} fee',
                          style: TextStyle(
                            fontSize: 11,
                            color: restaurant.deliveryFee == 0 ? Colors.green.shade700 : AppColors.textLight,
                            fontWeight: restaurant.deliveryFee == 0 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
