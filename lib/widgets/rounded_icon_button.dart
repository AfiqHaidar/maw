import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final double size;

  const RoundedButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.arrow_forward,
    this.color = AppColors.secondary,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        splashColor: color.withOpacity(0.3),
        child: Padding(
          padding: EdgeInsets.all(size * 0.2),
          child: Icon(
            icon,
            color: color,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
