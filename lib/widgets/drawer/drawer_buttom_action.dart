import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerBottomActions extends ConsumerWidget {
  final VoidCallback onLogout;

  const DrawerBottomActions({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            onPressed: onLogout,
            icon: Icon(
              Icons.logout_rounded,
              color: colorScheme.onSurfaceVariant,
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
