import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/repository/auth_repository.dart';

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(false);

  Future<void> signIn(String email, String password) async {
    state = true;
    try {
      await _authRepository.login(email, password);
    } finally {
      state = false;
    }
  }

  Future<UserCredential> register(String email, String password) async {
    state = true;
    try {
      return await _authRepository.register(email, password);
    } finally {
      state = false;
    }
  }

  Future<void> logout() async {
    state = true;
    try {
      await _authRepository.logout();
    } finally {
      state = false;
    }
  }
}
