import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String text;

  const AuthButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color.onPrimaryContainer,
          minimumSize: Size(size.width, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          elevation: 9,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
