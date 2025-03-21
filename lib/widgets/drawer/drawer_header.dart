import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawerHeader extends StatelessWidget {
  const MainDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 80, 16, 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.onPrimaryContainer,
            colorScheme.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              FontAwesomeIcons.shieldCat,
              size: 32,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Welcome to Maw App',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
