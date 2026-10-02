import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../core/constants.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(restaurant.image, height: 180, width: double.infinity, fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.grey[300], child: const Icon(Icons.broken_image)),),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.name, style: AppStyles.subtitle),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text('${restaurant.rating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(' (${restaurant.reviewCount}) • ${restaurant.cuisine}', style: AppStyles.body, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(restaurant.deliveryTime, style: AppStyles.body),
                      const SizedBox(width: 16),
                      const Icon(Icons.delivery_dining, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Expanded(child: Text('\$${restaurant.deliveryFee}', style: AppStyles.body, overflow: TextOverflow.ellipsis)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
