// lib/data/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/data/controller.dart/auth_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(userProvider.notifier),
  );
});

final usernamesStreamProvider = StreamProvider<List<String>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchAllUsernames();
});
