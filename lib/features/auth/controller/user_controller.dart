import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/models/user_model.dart';
import 'package:mb/data/repository/user_repository.dart';

class UserController extends StateNotifier<UserModel?> {
  final UserRepository _repository;

  UserController(this._repository) : super(null);

  Future<void> fetchUser(String userId) async {
    state = await _repository.getUser(userId);
  }

  Future<void> upsertUser(UserModel user) async {
    await _repository.saveUser(user);
    state = user;
  }

  Future<void> clearUser() async {
    state = null;
  }
}
