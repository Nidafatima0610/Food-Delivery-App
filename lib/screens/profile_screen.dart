import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../models/address.dart';
import 'offers_screen.dart';
import 'notifications_screen.dart';
import 'orders_screen.dart';
import 'about_screen.dart';
import 'auth/login_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedLanguage = 'English';
  String selectedArea = 'Model Town, Bahawalpur';

  void _showEditProfileDialog(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user?.name ?? 'Guest User');
    final phoneController = TextEditingController(text: user?.phone ?? '+92 300 1234567');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              final newName = nameController.text.trim();
              final newPhone = phoneController.text.trim();
              if (newName.isNotEmpty) {
                ref.read(authProvider.notifier).updateProfile(newName, newPhone);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile information updated successfully!'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSavedAddressesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final addresses = ref.watch(addressesProvider);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saved Addresses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const SizedBox(height: 10),
                if (addresses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.location_off_outlined, size: 40, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          const Text('No saved addresses yet', style: TextStyle(color: AppColors.textLight)),
                        ],
                      ),
                    ),
                  )
                else
                  ...addresses.map((a) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                    ),
                    title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(a.addressLine),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (a.isDefault)
                          const Chip(
                            label: Text('Default', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
                            backgroundColor: Color(0xFFE8F5E9),
                          )
                        else
                          TextButton(
                            onPressed: () {
                              ref.read(addressesProvider.notifier).setDefault(a.id);
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${a.label} set as default address!'), backgroundColor: AppColors.primary),
                              );
                            },
                            child: const Text('Set Default', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          onPressed: () {
                            ref.read(addressesProvider.notifier).removeAddress(a.id);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Removed ${a.label}'), backgroundColor: Colors.red),
                            );
                          },
                        ),
                      ],
                    ),
                  )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Add New Address', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _showAddNewAddressDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddNewAddressDialog(BuildContext context) {
    final labelCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Address', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: labelCtrl, decoration: const InputDecoration(labelText: 'Label (e.g. Home, Office)')),
            TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Street Address, Bahawalpur')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Contact Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              if (labelCtrl.text.isNotEmpty && addressCtrl.text.isNotEmpty) {
                ref.read(addressesProvider.notifier).addAddress(
                  Address(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    label: labelCtrl.text.trim(),
                    addressLine: addressCtrl.text.trim(),
                    contactNumber: phoneCtrl.text.trim(),
                    isDefault: true,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address added successfully!'), backgroundColor: AppColors.primary),
                );
              }
            },
            child: const Text('Save Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                selectedLanguage == 'English' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selectedLanguage == 'English' ? AppColors.primary : Colors.grey,
              ),
              title: const Text('English (Default)'),
              subtitle: const Text('App interface in English'),
              onTap: () {
                setState(() => selectedLanguage = 'English');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(
                selectedLanguage == 'Urdu' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selectedLanguage == 'Urdu' ? AppColors.primary : Colors.grey,
              ),
              title: const Text('Urdu (اردو)'),
              subtitle: const Text('جلد آرہا ہے (Coming Soon)'),
              onTap: () {
                setState(() => selectedLanguage = 'Urdu');
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اردو ترجمہ کا آغاز جلد کیا جائے گا (English currently active).')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPreferencesDialog(BuildContext context) {
    final areas = [
      'Model Town, Bahawalpur',
      'Cantt, Bahawalpur',
      'Farid Gate, Bahawalpur',
      'Circular Road, Bahawalpur',
      'Dubai Chowk, Bahawalpur',
      'Commercial Area, Bahawalpur',
      'University Road, Bahawalpur',
      'Satellite Town, Bahawalpur',
      'Islamia Colony, Bahawalpur',
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Preferred Bahawalpur Area', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: areas.length,
            itemBuilder: (c, i) {
              final area = areas[i];
              final isSel = selectedArea == area;
              return ListTile(
                title: Text(area, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                trailing: isSel ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setPreferredArea(area);
                  setState(() => selectedArea = area);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Delivery area set to $area!'), backgroundColor: AppColors.primary),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPaymentMethodsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 10),
              _buildPaymentTile(Icons.money, 'Cash on Delivery (COD)', 'Available on all orders in Bahawalpur', true),
              const Divider(height: 16),
              _buildPaymentTile(Icons.account_balance_wallet_outlined, 'JazzCash Mobile Wallet', 'Instant digital payment via JazzCash', false),
              const Divider(height: 16),
              _buildPaymentTile(Icons.phone_android_outlined, 'EasyPaisa Wallet', 'Instant digital payment via EasyPaisa', false),
              const Divider(height: 16),
              _buildPaymentTile(Icons.credit_card_outlined, 'Debit / Credit Card', 'Visa & Mastercard supported', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentTile(IconData icon, String title, String subtitle, bool isDefault) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
            ],
          ),
        ),
        if (isDefault)
          const Chip(
            label: Text('Active', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFFE8F5E9),
          ),
      ],
    );
  }

  void _showFAQsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFAQItem('How do I track my order?', 'You can tap on the "Orders" tab in the bottom bar to follow live preparation and delivery status.'),
                _buildFAQItem('What are typical delivery times?', 'Most orders in Bahawalpur are delivered within 20 to 35 minutes depending on distance and kitchen prep time.'),
                _buildFAQItem('Can I cancel an order?', 'Orders can be cancelled before the restaurant begins cooking. Please contact support immediately if needed.'),
                _buildFAQItem('What payment options are available?', 'We support Cash on Delivery (COD), JazzCash, EasyPaisa, and debit/credit cards.'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textDark)),
          const SizedBox(height: 4),
          Text(answer, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Contact Support', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need assistance with an ongoing order or question? Our Bahawalpur support team is available 24/7.', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text('Helpline Hotline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('+92 62 111 248 366'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.chat_bubble_outline, color: Colors.teal),
              title: const Text('WhatsApp Assistance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('+92 300 8654321'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined, color: AppColors.primary),
              title: const Text('Support Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('support@bitenow-bwp.pk'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showReportProblemDialog(BuildContext context) {
    final reportController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Report a Problem', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please describe the issue you experienced. Our quality team reviews every report.', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: reportController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'e.g. Missing sauce, late delivery, app glitch...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you! Your report has been submitted to support.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLegalDialog(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(body, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings['darkMode'] ?? false;
    final notifications = settings['notifications'] ?? true;
    final currentArea = settings['preferredArea'] ?? 'Model Town, Bahawalpur';
    final currentLanguage = settings['language'] ?? 'English';
    selectedArea = currentArea;
    selectedLanguage = currentLanguage;
    final user = ref.watch(authProvider);
    final unreadNotifs = ref.watch(notificationsProvider).where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                if (unreadNotifs > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$unreadNotifs', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        children: [
          // User Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Umair Raza',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? 'umair.bahawalpur@gmail.com',
                        style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Text('Verified Member', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: () => _showEditProfileDialog(context, user),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // SECTION 1: ACCOUNT
          _buildSectionHeader('ACCOUNT'),
          _buildCard([
            _buildTile(
              icon: Icons.person_outline,
              title: 'Profile Details',
              subtitle: 'Name, phone, and account credentials',
              onTap: () => _showEditProfileDialog(context, user),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              subtitle: 'Manage home, work, and family addresses',
              onTap: () => _showSavedAddressesSheet(context),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.favorite_border,
              title: 'Favorites',
              subtitle: 'Saved restaurants and favorite dishes',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.local_offer_outlined,
              title: 'Offers & Coupons',
              subtitle: 'Active discounts and promotions',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen())),
            ),
          ]),

          const SizedBox(height: 20),

          // SECTION 2: APP PREFERENCES
          _buildSectionHeader('APP PREFERENCES'),
          _buildCard([
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
              title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Order updates, promotions & deals', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              value: notifications,
              activeThumbColor: AppColors.primary,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).toggleSetting('notifications');
              },
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Reduce glare and adjust brightness', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              value: isDark,
              activeThumbColor: AppColors.primary,
              onChanged: (val) {
                ref.read(settingsProvider.notifier).toggleSetting('darkMode');
              },
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: selectedLanguage,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.my_location_outlined,
              title: 'Delivery Area Preference',
              subtitle: selectedArea,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLocationPreferencesDialog(context),
            ),
          ]),

          const SizedBox(height: 20),

          // SECTION 3: ORDERS & DELIVERY
          _buildSectionHeader('ORDERS & DELIVERY'),
          _buildCard([
            _buildTile(
              icon: Icons.receipt_long_outlined,
              title: 'Order History',
              subtitle: 'Past orders, receipts & quick reorders',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen())),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              subtitle: 'Cash on Delivery, JazzCash, EasyPaisa',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showPaymentMethodsSheet(context),
            ),
          ]),

          const SizedBox(height: 20),

          // SECTION 4: SUPPORT
          _buildSectionHeader('SUPPORT & HELP'),
          _buildCard([
            _buildTile(
              icon: Icons.help_outline,
              title: 'Help Center & FAQs',
              subtitle: 'Common questions and instant answers',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showFAQsDialog(context),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.support_agent_outlined,
              title: 'Contact Support',
              subtitle: 'Call helpline, WhatsApp or email',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showContactSupportDialog(context),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.report_problem_outlined,
              title: 'Report a Problem',
              subtitle: 'Let us know if something went wrong',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showReportProblemDialog(context),
            ),
          ]),

          const SizedBox(height: 20),

          // SECTION 5: ABOUT
          _buildSectionHeader('ABOUT'),
          _buildCard([
            _buildTile(
              icon: Icons.info_outline,
              title: 'About BiteNow',
              subtitle: 'Capabilities, mission, and version info',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How we respect and protect your data',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLegalDialog(
                context,
                'Privacy Policy',
                'Your privacy is very important to us at BiteNow. We only collect the minimal personal data required to process orders, deliver your meals accurately in Bahawalpur, and maintain high food quality. We never sell or share your contact numbers or location data with unauthorized third parties.',
              ),
            ),
            const Divider(height: 1),
            _buildTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Delivery policies, refunds, and terms',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLegalDialog(
                context,
                'Terms & Conditions',
                'By ordering through BiteNow, you agree to our standard terms of food delivery. Prices and promotions are locally verified. Delivery times may fluctuate slightly during peak hours or heavy weather in Bahawalpur. For defective orders, please notify support within 30 minutes of receipt.',
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.verified_outlined, color: AppColors.primary),
              title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              trailing: const Text('v1.2.0 (Build 2026.10)', style: TextStyle(color: AppColors.textLight, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ]),

          const SizedBox(height: 24),

          // Authentication Action
          if (user != null)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 18),
                  SizedBox(width: 8),
                  Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            )
          else
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: const Text('Log In / Register', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 0.8),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
