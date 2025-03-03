import 'package:flutter/material.dart';
import 'package:mb/features/color/color_poppin_screen.dart';
import 'package:mb/features/home/home.dart';
import 'package:mb/features/scaffold/widgets/tab_template.dart';

class Week2 extends StatelessWidget {
  const Week2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabTemplate(
      screens: [
        ColorPoppinScreen(),
        HomeScreen(),
      ],
      tabs: [
        NavigationDestination(
          selectedIcon: Icon(Icons.color_lens),
          icon: Icon(Icons.color_lens_outlined),
          label: 'Pop',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.people_alt),
          icon: Icon(Icons.people_alt_outlined),
          label: 'People',
        ),
      ],
    );
  }
}
