// lib/features/profile/widgets/profile_logout_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class ProfileLogoutButton extends ConsumerWidget {
  const ProfileLogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showLogoutConfirmation(context, ref),
        icon: const Icon(Icons.logout_rounded, size: 20),
        label: const Text("Log Out"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: colorScheme.error,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Logout Confirmation",
        description: "Are you sure you want to log out of the account?",
        confirmButtonText: "Logout",
        cancelButtonText: "Cancel",
        icon: Icons.logout_outlined,
        onConfirm: () async {
          await ref.read(authProvider.notifier).logout();
        },
      ),
    );
  }
}
