import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mb/data/models/user_model.dart';
import 'package:mb/data/repository/user_repository.dart';
import 'package:mb/features/auth/controller/user_controller.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProvider = StateNotifierProvider<UserController, UserModel?>((ref) {
  return UserController(ref.read(userRepositoryProvider));
});

final userStreamProvider = StreamProvider<UserModel>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not logged in');

  final repo = ref.read(userRepositoryProvider);
  return repo.watchUser(user.uid);
});
