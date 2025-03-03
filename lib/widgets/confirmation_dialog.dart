import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String header;
  final String subheader;
  final String confirmButtonText;
  final String? cancelButtonText;
  final Color? confirmButtonColor;
  final FutureOr<void> Function() onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.header,
    required this.subheader,
    required this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    this.onCancel,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        header,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        subheader,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        OutlinedButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary),
          ),
          child: Text(
            cancelButtonText ?? 'Batalkan',
            style: const TextStyle(
              color: AppColors.primary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmButtonColor ?? AppColors.primary,
            foregroundColor: AppColors.white,
          ),
          child: Text(
            confirmButtonText,
          ),
        ),
      ],
    );
  }
}
