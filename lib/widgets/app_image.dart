import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData? fallbackIcon;
  final String? category;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon,
    this.category,
  });

  IconData _getIconForCategory(String? cat) {
    if (fallbackIcon != null) return fallbackIcon!;
    if (cat == null) return Icons.restaurant;
    final lower = cat.toLowerCase();
    if (lower.contains('pizza')) return Icons.local_pizza;
    if (lower.contains('burger')) return Icons.lunch_dining;
    if (lower.contains('biryani') || lower.contains('rice') || lower.contains('pakistani')) return Icons.rice_bowl;
    if (lower.contains('bbq') || lower.contains('grill') || lower.contains('tikka')) return Icons.outdoor_grill;
    if (lower.contains('chinese') || lower.contains('noodle')) return Icons.ramen_dining;
    if (lower.contains('dessert') || lower.contains('cake') || lower.contains('sweet')) return Icons.cake;
    if (lower.contains('drink') || lower.contains('coffee') || lower.contains('latte') || lower.contains('tea')) return Icons.local_cafe;
    if (lower.contains('breakfast')) return Icons.breakfast_dining;
    if (lower.contains('healthy') || lower.contains('salad')) return Icons.eco;
    if (lower.contains('fast food')) return Icons.fastfood;
    return Icons.restaurant_menu;
  }

  LinearGradient _getGradientForCategory(String? cat) {
    final lower = (cat ?? '').toLowerCase();
    if (lower.contains('pizza') || lower.contains('burger') || lower.contains('bbq')) {
      return const LinearGradient(
        colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('biryani') || lower.contains('pakistani')) {
      return const LinearGradient(
        colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('chinese')) {
      return const LinearGradient(
        colors: [Color(0xFFE52D27), Color(0xFFB31217)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('dessert') || lower.contains('sweet')) {
      return const LinearGradient(
        colors: [Color(0xFFDA4453), Color(0xFF89216B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('drink') || lower.contains('coffee')) {
      return const LinearGradient(
        colors: [Color(0xFF3E2723), Color(0xFF795548)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (lower.contains('healthy')) {
      return const LinearGradient(
        colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFFF5722), Color(0xFFFF8A65)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Widget _buildFallback() {
    final icon = _getIconForCategory(category);
    final gradient = _getGradientForCategory(category);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          icon,
          size: (height != null && height! < 70) ? 28 : 42,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(
          Icons.fastfood_outlined,
          size: (height != null && height! < 70) ? 20 : 32,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildFallback();
    }

    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildFallback();
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
