import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/user_entity.dart';
import 'package:mb/data/repository/auth_repository.dart';
import 'package:mb/data/repository/user_repository.dart';

class UserController extends StateNotifier<UserEntity?> {
  final UserRepository _repository;
  final AuthRepository _authRepository;

  UserController(this._repository, this._authRepository) : super(null);

  Future<void> fetchUser() async {
    state = await _repository.getUser(_authRepository.auth.currentUser!.uid);
  }

  Future<void> upsertUser(UserEntity user) async {
    await _repository.saveUser(user);
    state = user;
  }

  Future<void> clearUser() async {
    state = null;
  }
}
