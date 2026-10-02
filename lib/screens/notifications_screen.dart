import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      backgroundColor: AppColors.background,
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications', style: AppStyles.subtitle))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return ListTile(
                  title: Text(notif.title, style: TextStyle(fontWeight: notif.isRead ? FontWeight.normal : FontWeight.bold)),
                  subtitle: Text(notif.message),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: notif.isRead ? Colors.transparent : Colors.blue.withValues(alpha: 0.05),
                  onTap: () {
                    ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                  },
                );
              },
            ),
    );
  }
}
