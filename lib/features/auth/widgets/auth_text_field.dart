import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType? textInputType;

  const AuthTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    required this.validator,
    required this.onSaved,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.white70, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.white70, width: 1.0),
        ),
      ),
      style: const TextStyle(color: AppColors.white),
      obscureText: obscureText,
      validator: validator,
      onSaved: onSaved,
      keyboardType: textInputType ?? TextInputType.text,
    );
  }
}
