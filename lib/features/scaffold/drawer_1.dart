import 'package:flutter/material.dart';
import 'package:mb/features/home/home.dart';
import 'package:mb/features/scaffold/widgets/tab_template.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabTemplate(
      screens: [
        HomeScreen(),
        HomeScreen(),
      ],
      tabs: [
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
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
