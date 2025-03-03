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
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: Theme.of(context).colorScheme.onBackground,
      ),
      title: Text(
        title,
      ),
      onTap: () => onTap(context, identifier),
    );
  }
}
