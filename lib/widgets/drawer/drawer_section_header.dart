import 'package:flutter/material.dart';

class DrawerSectionHeader extends StatelessWidget {
  final String title;

  const DrawerSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}
