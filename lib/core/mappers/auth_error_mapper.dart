// lib/core/mappers/auth_error_mapper.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorMapper {
  static String map(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-email':
        return "The email address is badly formatted.";
      case 'user-disabled':
        return "This account has been disabled.";
      case 'too-many-requests':
        return "Too many requests. Try again later.";
      default:
        return "Authentication failed. Please try again.";
    }
  }
}
