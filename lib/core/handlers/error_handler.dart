// lib/core/handlers/error_handler.dart
import 'package:flutter/material.dart';

class ErrorHandler {
  static void showError(BuildContext context, String message,
      {bool useDialog = false}) {
    if (useDialog) {
      _showErrorDialog(context, message);
    } else {
      _showSnackbar(context, message);
    }
  }

  static void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
