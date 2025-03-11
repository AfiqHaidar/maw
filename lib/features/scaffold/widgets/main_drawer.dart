import 'package:flutter/material.dart';
import 'package:mb/data/enums/drawer_identifier.dart';
import 'package:mb/features/color/color_poppin_screen.dart';
import 'package:mb/features/home/home_screen.dart';
import 'package:mb/features/scaffold/week1.dart';
import 'package:mb/features/scaffold/week3.dart';
import 'package:mb/features/scaffold/widgets/drawer_item.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  void _onSelectScreen(BuildContext context, DrawerIdentifier identifier) {
    switch (identifier) {
      case DrawerIdentifier.home:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const HomeScreen()),
        );
        break;
      case DrawerIdentifier.week1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const Week1()),
        );
        break;
      case DrawerIdentifier.week2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const ColorPoppinScreen()),
        );
        break;
      case DrawerIdentifier.week3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const Week3()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_android,
                  size: 48,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Mobile Dev Course',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            identifier: DrawerIdentifier.home,
            onTap: _onSelectScreen,
          ),
          DrawerItem(
            icon: Icons.flutter_dash,
            title: 'Intro to Flutter',
            identifier: DrawerIdentifier.week1,
            onTap: _onSelectScreen,
          ),
          DrawerItem(
            icon: Icons.color_lens,
            title: 'Button-Color-Font',
            identifier: DrawerIdentifier.week2,
            onTap: _onSelectScreen,
          ),
          DrawerItem(
            icon: Icons.image,
            title: 'Images',
            identifier: DrawerIdentifier.week3,
            onTap: _onSelectScreen,
          ),
        ],
      ),
    );
  }
}
