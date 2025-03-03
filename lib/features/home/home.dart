import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/features/home/widgets/lets_start_box.dart';
import 'package:mb/features/scaffold/widgets/main_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/widgets/confirmation_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeLottieAnimation();
  }

  void _initializeLottieAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutSine),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        );
      },
    );
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
        drawer: const MainDrawer(),
        body: Column(
          children: [
            Expanded(child: _buildAnimatedLottie()),
            const StartedBox(
              title: "Mobile Development Course Using Flutter <3.",
              subtitle: "Mari menguli 💀",
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLottie() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Lottie.asset(
          'assets/animations/hanging_cat.json',
        ),
      ),
    );
  }
}
