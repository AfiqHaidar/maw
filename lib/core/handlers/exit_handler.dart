// lib/core/handlers/exit_handler.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class ExitHandler {
  static Future<void> exitApp() async {
    exit(0);
  }

  static void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return const ConfirmationDialog(
          title: "Exit App",
          description: "Are you sure you want to exit?",
          icon: Icons.exit_to_app_outlined,
          confirmButtonText: "Exit",
          cancelButtonText: "Cancel",
          onConfirm: exitApp,
        );
      },
    );
  }
}
