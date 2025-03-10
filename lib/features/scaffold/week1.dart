import 'package:flutter/material.dart';
import 'package:mb/features/color/color_poppin_screen.dart';
import 'package:mb/features/home/home_screen.dart';
import 'package:mb/features/scaffold/widgets/tab_template.dart';

class Week1 extends StatelessWidget {
  const Week1({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabTemplate(
      screens: [
        ColorPoppinScreen(),
        HomeScreen(),
      ],
      tabs: [
        NavigationDestination(
          selectedIcon: Icon(Icons.flutter_dash),
          icon: Icon(Icons.flutter_dash_outlined),
          label: 'Flutter',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.code),
          icon: Icon(Icons.code_off_outlined),
          label: 'Dart',
        ),
      ],
    );
  }
}
