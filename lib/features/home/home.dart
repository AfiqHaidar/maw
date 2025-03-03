import 'package:flutter/material.dart';
import 'package:mb/features/scaffold/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const MainDrawer(),
      body: const Center(child: Text("Home Screen")),
    );
  }
}
