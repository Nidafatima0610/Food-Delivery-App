import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import 'offers_screen.dart';
import 'notifications_screen.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;
    final notifications = settings['notifications'] ?? true;
    final user = ref.watch(authProvider);
    final unreadNotifs = ref.watch(notificationsProvider).where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                if (unreadNotifs > 0)
                  Positioned(
                    right: -2, top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  )
              ],
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
            },
          )
        ],
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text(user?.name ?? 'Guest', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          Center(child: Text(user?.email ?? 'Please log in', style: const TextStyle(color: AppColors.textLight))),
          const SizedBox(height: 32),
          
          ListTile(
            leading: const Icon(Icons.local_offer_outlined),
            title: const Text('Offers & Deals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
            },
          ),
          const Divider(),
          const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).toggleSetting('darkMode');
            },
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            value: notifications,
            onChanged: (val) {
              ref.read(settingsProvider.notifier).toggleSetting('notifications');
            },
          ),
          const Divider(),
          if (user != null)
            TextButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16)),
            )
        ],
      ),
    );
  }
}
