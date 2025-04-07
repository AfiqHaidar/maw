import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/repository/user_repository.dart';
import 'package:mb/data/controller.dart/user_controller.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProvider = StateNotifierProvider<UserController, UserEntity?>((ref) {
  return UserController(ref.watch(userRepositoryProvider));
});

final userStreamProvider = StreamProvider<UserEntity>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('User not logged in');

  final repo = ref.watch(userRepositoryProvider);
  return repo.watchUser(user.uid);
});

final allUsersProvider = StreamProvider<List<UserEntity>>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return repo.watchAllUsers();
});
