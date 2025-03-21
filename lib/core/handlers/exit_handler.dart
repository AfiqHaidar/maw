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
          header: "Konfirmasi Keluar",
          subheader: "Apakah Anda yakin ingin keluar dari aplikasi?",
          confirmButtonText: "Keluar",
          cancelButtonText: "Batal",
          onConfirm: exitApp,
        );
      },
    );
  }
}
