import 'package:flutter/material.dart';
import 'package:mb/core/handlers/exit_handler.dart';

class TabTemplate extends StatefulWidget {
  final List<Widget> screens;
  final List<NavigationDestination> tabs;

  const TabTemplate({
    super.key,
    required this.screens,
    required this.tabs,
  });

  @override
  State<TabTemplate> createState() => _TabTemplateState();
}

class _TabTemplateState extends State<TabTemplate> {
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        ExitHandler.showExitConfirmationDialog(context);
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          elevation: 0,
          selectedIndex: selectedPageIndex,
          destinations: widget.tabs,
        ),
        body: widget.screens[selectedPageIndex],
      ),
    );
  }
}
