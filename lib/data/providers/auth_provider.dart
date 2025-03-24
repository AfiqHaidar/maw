import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/providers/user_provider.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/features/auth/controller/auth_controller.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authProvider = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref.read(authRepositoryProvider),
  );
});

final usernamesStreamProvider = StreamProvider<List<String>>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return repo.watchAllUsernames();
});
