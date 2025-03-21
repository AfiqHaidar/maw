import 'package:flutter/material.dart';

class PasswordVisibilityToggle extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onToggle;

  const PasswordVisibilityToggle(
      {super.key, required this.isVisible, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
      onPressed: onToggle,
    );
  }
}
