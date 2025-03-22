import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class AuthFooter extends StatelessWidget {
  final VoidCallback onRegister;

  const AuthFooter({
    super.key,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(
              color: AppColors.white54,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: onRegister,
            child: const Text(
              'Create One',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
