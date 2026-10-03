import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import 'app_providers.dart';

class AuthNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    final storage = ref.watch(storageServiceProvider);
    final userJson = storage.getString('current_user');
    if (userJson != null) return UserModel.fromJson(jsonDecode(userJson));
    return UserModel(
      id: 'u1',
      name: 'Umair Raza',
      email: 'umair.bahawalpur@gmail.com',
      phone: '+92 300 8654321',
    );
  }

  Future<void> login(String email, String password) async {
    final user = UserModel(
      id: 'u1',
      name: 'Umair Raza',
      email: email,
      phone: '+92 300 8654321',
    );
    state = user;
    await ref.read(storageServiceProvider).setString('current_user', jsonEncode(user.toJson()));
  }

  Future<void> updateProfile(String name, String phone) async {
    final current = state;
    final updated = UserModel(
      id: current?.id ?? 'u1',
      name: name,
      email: current?.email ?? 'umair.bahawalpur@gmail.com',
      phone: phone,
    );
    state = updated;
    await ref.read(storageServiceProvider).setString('current_user', jsonEncode(updated.toJson()));
  }

  Future<void> logout() async {
    state = null;
    await ref.read(storageServiceProvider).remove('current_user');
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());
