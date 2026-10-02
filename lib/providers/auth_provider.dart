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
    return null;
  }

  Future<void> login(String email, String password) async {
    // Mock authentication
    final user = UserModel(id: 'u1', name: 'John Doe', email: email, phone: '+1234567890');
    state = user;
    await ref.read(storageServiceProvider).setString('current_user', jsonEncode(user.toJson()));
  }

  Future<void> logout() async {
    state = null;
    await ref.read(storageServiceProvider).remove('current_user');
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserModel?>(() => AuthNotifier());
