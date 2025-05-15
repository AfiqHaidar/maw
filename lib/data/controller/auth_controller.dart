// lib/data/controller/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/controller/user_controller.dart';
import 'package:mb/data/repository/auth_repository.dart';

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final UserController _userController;

  AuthController(this._authRepository, this._userController) : super(false);

  Future<void> signIn(String email, String password) async {
    state = true;
    try {
      final user = await _authRepository.login(email, password);
      if (user != null) {
        await _userController.fetchUser();
      }
    } finally {
      state = false;
    }
  }

  Future<UserCredential> register(String email, String password) async {
    state = true;
    try {
      final userCredential = await _authRepository.register(email, password);
      if (userCredential.user != null) {
        await _userController.fetchUser();
      }
      return userCredential;
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    state = true;
    try {
      _authRepository.logout();
      await _userController.clearUser();
    } finally {
      state = false;
    }
  }
}
