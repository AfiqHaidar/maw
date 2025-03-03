import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/enums/drawer_identifier.dart';
import 'package:mb/features/scaffold/drawer_1.dart';
import 'package:mb/features/scaffold/drawer_2.dart';
import 'dart:io';
import 'package:mb/widgets/confirmation_dialog.dart';

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

  Future<void> _exitApp() async {
    exit(0);
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          header: "Konfirmasi Keluar",
          subheader: "Apakah Anda yakin ingin keluar dari aplikasi?",
          confirmButtonText: "Keluar",
          cancelButtonText: "Batal",
          onConfirm: _exitApp,
          confirmButtonColor: AppColors.red,
        );
      },
    );
  }

  void _onSelectScreen(DrawerIdentifier identifier) {
    switch (identifier) {
      case DrawerIdentifier.week1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MyScreen()),
        );
        break;
      case DrawerIdentifier.week2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const MyScreen2()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        _showExitConfirmationDialog();
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
