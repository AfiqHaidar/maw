import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/core/services/sound_service.dart';
import 'package:mb/data/enums/sound_identifier.dart';
import 'package:mb/data/providers/auth_provider.dart';
import 'package:mb/features/home/widgets/home_buttom_sheet.dart';
import 'package:mb/core/handlers/exit_handler.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                    child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        SoundService().playSound(SoundIdentifier.MEOW);
                        await ref.read(authProvider.notifier).logout();
                      },
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      child: Lottie.asset(
                        'assets/animations/stare_cat.json',
                      ),
                    ),
                  ),
                )),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Builder(
                  builder: (context) => HomeBottomSheet(
                    title: "Meow meow meow meow Flutter meow meow.",
                    subtitle: "Meow meow nya meow 💀",
                    onButtonPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
