import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;
    final notifications = settings['notifications'] ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.textDark)),
        backgroundColor: AppColors.white,
        elevation: 0,
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
          const Center(child: Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          const Center(child: Text('john.doe@example.com', style: TextStyle(color: AppColors.textLight))),
          const SizedBox(height: 32),
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
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Delivery Addresses'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Payment Methods'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            child: const Text('Log Out', style: TextStyle(color: Colors.red, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
