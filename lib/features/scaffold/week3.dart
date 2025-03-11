import 'package:flutter/material.dart';
import 'package:mb/features/collection/collection_screen.dart';
import 'package:mb/features/image_challange/image_challage_screen.dart';
import 'package:mb/features/scaffold/widgets/tab_template.dart';
import 'package:mb/features/vertical/vertical_screen.dart';

class Week3 extends StatelessWidget {
  const Week3({super.key});

  @override
  Widget build(BuildContext context) {
    return TabTemplate(
      screens: [
        VerticalScreen(),
        CollectionScreen(),
        ImageChallengeScreen(),
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
        NavigationDestination(
          selectedIcon: Icon(Icons.swap_calls),
          icon: Icon(Icons.swap_calls_outlined),
          label: 'Challange',
        ),
      ],
    );
  }
}
