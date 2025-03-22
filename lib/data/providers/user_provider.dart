import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/models/user_model.dart';
import 'package:mb/data/repository/user_repository.dart';
import 'package:mb/features/auth/controller/user_controller.dart';

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository());

final userProvider = StateNotifierProvider<UserController, UserModel?>((ref) {
  return UserController(ref.read(userRepositoryProvider));
});
