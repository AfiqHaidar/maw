import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mb/features/auth/controller/auth_animation_controller.dart';
import 'package:mb/features/home/screens/home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AuthAnimatedOpacityController _anim;
  late Timer _navTimer;

  void _startNavigationTimer() {
    _navTimer = Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _anim = AuthAnimatedOpacityController(vsync: this);
    _startNavigationTimer();
  }

  @override
  void dispose() {
    _anim.dispose();
    _navTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _anim.controller,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(_anim.opacityAnim.value),
                  primary.withOpacity(_anim.lowOpacityAnim.value),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.shieldCat,
                  size: 50,
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
