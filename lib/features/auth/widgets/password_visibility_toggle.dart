import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  const PasswordVisibilityToggle(
      {super.key, required this.isVisible, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: AppColors.white70,
      ),
      onPressed: onToggle,
    );
  }
}
