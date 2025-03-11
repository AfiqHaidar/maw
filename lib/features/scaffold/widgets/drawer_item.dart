import 'package:flutter/material.dart';
import 'package:mb/data/enums/drawer_identifier.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final DrawerIdentifier identifier;
  final void Function(BuildContext, DrawerIdentifier) onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.identifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: colorScheme
            .onBackground, // Icon color using 'onBackground' from ColorScheme
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: colorScheme
              .onBackground, // Text color using 'onBackground' from ColorScheme
        ),
      ),
      onTap: () => onTap(context, identifier),
      contentPadding: EdgeInsets.symmetric(
          vertical: 10, horizontal: 15), // Consistent padding
    );
  }
}
