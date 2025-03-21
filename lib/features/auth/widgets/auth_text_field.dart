import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const AuthTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    required this.validator,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
