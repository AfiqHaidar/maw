import 'package:flutter/material.dart';
import 'package:mb/core/handlers/exit_handler.dart';
import 'package:mb/features/home/screens/home_screen.dart';
import 'package:mb/features/portofolio/screens/portofolio_screen.dart';
import 'package:mb/features/profile/screens/profile_screen.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';

class TabsWrapper extends StatefulWidget {
  const TabsWrapper({super.key});

  @override
  State<TabsWrapper> createState() => TabsWrapperState();
}

class TabsWrapperState extends State<TabsWrapper> {
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
        drawer: const MainDrawer(),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          // backgroundColor: AppColors.white,
          elevation: 0,
          selectedIndex: selectedPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.business_center),
              icon: Icon(Icons.business_center_outlined),
              label: 'Portofolio',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
        body: Builder(
          builder: (context) => <Widget>[
            HomeScreen(
              onMenuPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            const PortofolioScreen(),
            const ProfileScreen(),
          ][selectedPageIndex],
        ),
      ),
    );
  }
}
