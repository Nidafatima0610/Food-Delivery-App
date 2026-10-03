import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _getIconForTitle(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('deal') || lower.contains('discount') || lower.contains('off') || lower.contains('voucher')) {
      return Icons.local_offer_outlined;
    }
    if (lower.contains('order') || lower.contains('delivered') || lower.contains('cooking')) {
      return Icons.delivery_dining_outlined;
    }
    if (lower.contains('welcome') || lower.contains('account')) {
      return Icons.verified_user_outlined;
    }
    return Icons.notifications_active_outlined;
  }

  Color _getColorForTitle(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('deal') || lower.contains('discount') || lower.contains('off')) {
      return Colors.orange;
    }
    if (lower.contains('order') || lower.contains('delivered')) {
      return Colors.green;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        actions: [
          if (notifications.isNotEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textDark),
              onSelected: (action) {
                if (action == 'read') {
                  ref.read(notificationsProvider.notifier).markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications marked as read.')),
                  );
                } else if (action == 'clear') {
                  ref.read(notificationsProvider.notifier).clearAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications cleared.')),
                  );
                }
              },
              itemBuilder: (context) => [
                if (unreadCount > 0)
                  const PopupMenuItem(
                    value: 'read',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 18, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text('Mark all as read'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_outlined, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Clear all', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: notifications.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.notifications_none_outlined, size: 64, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    const Text('No notifications yet', style: AppStyles.title),
                    const SizedBox(height: 8),
                    const Text(
                      'You are all caught up! Order status updates and special Bahawalpur food deals will appear here.',
                      style: AppStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              itemCount: notifications.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final color = _getColorForTitle(notif.title);
                final icon = _getIconForTitle(notif.title);

                return Container(
                  decoration: BoxDecoration(
                    color: notif.isRead ? Colors.white : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: notif.isRead
                        ? Border.all(color: Colors.grey.shade200)
                        : Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        notif.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: notif.isRead ? AppColors.textLight : AppColors.textDark,
                          height: 1.35,
                        ),
                      ),
                    ),
                    onTap: () {
                      if (!notif.isRead) {
                        ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
