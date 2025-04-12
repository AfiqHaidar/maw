import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/debuggers/cache/cache.dart';
import 'package:mb/data/enums/drawer_identifier.dart';
import 'package:mb/data/providers/selected_drawer_provider.dart';
import 'package:mb/core/debuggers/seeder/seeder.dart';
import 'package:mb/widgets/confirmation_dialog.dart';
import 'package:mb/widgets/drawer/drawer_header.dart';
import 'package:mb/widgets/drawer/drawer_item.dart';
import 'package:mb/widgets/drawer/drawer_buttom_action.dart';
import 'package:mb/widgets/drawer/drawer_section_header.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/widgets/tabs.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({
    super.key,
  });

  void _onSelectScreen(
      BuildContext context, WidgetRef ref, DrawerIdentifier identifier) {
    Navigator.of(context).pop();
    ref.read(selectedDrawerProvider.notifier).state = identifier;

    switch (identifier) {
      case DrawerIdentifier.home:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => TabsWrapper()),
        );
        break;
      case DrawerIdentifier.cache:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => CacheManagementScreen()),
        );
        break;

      case DrawerIdentifier.seeder:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => AdminSeederScreen()),
        );
        break;
    }
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        header: "Logout Confirmation",
        subheader: "Are you sure you want to log out of the account?",
        confirmButtonText: "Logout",
        cancelButtonText: "Cancel",
        onConfirm: () async {
          Navigator.of(context).pop();
          await ref.read(authProvider.notifier).logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const MainDrawerHeader(),
            const SizedBox(height: 16),
            const DrawerSectionHeader(title: 'MAIN'),
            DrawerItem(
              icon: Icons.home_rounded,
              title: 'Home',
              identifier: DrawerIdentifier.home,
              onTap: () => _onSelectScreen(context, ref, DrawerIdentifier.home),
            ),
            const DrawerSectionHeader(title: 'CONFIGURATION'),
            DrawerItem(
              icon: Icons.data_object,
              title: 'Seeder',
              identifier: DrawerIdentifier.seeder,
              onTap: () =>
                  _onSelectScreen(context, ref, DrawerIdentifier.seeder),
            ),
            DrawerItem(
              icon: Icons.cached_rounded,
              title: 'Cache',
              identifier: DrawerIdentifier.cache,
              onTap: () =>
                  _onSelectScreen(context, ref, DrawerIdentifier.cache),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            DrawerBottomActions(
              onLogout: () => _showLogoutConfirmation(context, ref),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
