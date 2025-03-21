import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/enums/drawer_identifier.dart';
import 'package:mb/data/providers/selected_drawer_provider.dart';

class DrawerItem extends ConsumerWidget {
  final IconData icon;
  final String title;
  final DrawerIdentifier identifier;
  final void Function() onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.identifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIdentifier = ref.watch(selectedDrawerProvider);

    final isSelected = selectedIdentifier == identifier;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: isSelected
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.primary,
              ),
            )
          : Icon(
              icon,
              color: colorScheme.onSurfaceVariant,
            ),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(
          color: isSelected ? colorScheme.primary : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      dense: true,
    );
  }
}
