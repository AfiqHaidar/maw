import 'package:flutter/material.dart';
import 'package:mb/features/collection/collection_screen.dart';
import 'package:mb/features/scaffold/widgets/tab_template.dart';
import 'package:mb/features/vertical/vertical_screen.dart';

class Week3 extends StatelessWidget {
  const Week3({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabTemplate(
      screens: [
        VerticalScreen(),
        CollectionScreen(),
      ],
      tabs: [
        NavigationDestination(
          selectedIcon: Icon(Icons.vertical_shades),
          icon: Icon(Icons.vertical_shades_outlined),
          label: 'Vertical',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.collections),
          icon: Icon(Icons.collections_outlined),
          label: 'Collection',
        ),
      ],
    );
  }
}
