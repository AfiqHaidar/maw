import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/core/utils/helpers/color_helper.dart';
import 'package:mb/core/utils/helpers/random_helper.dart';
import 'package:mb/core/services/sound_service.dart';
import 'package:mb/data/enums/sound_identifier.dart';
import 'package:mb/widgets/rounded_icon_button.dart';
import 'package:mb/widgets/drawer/main_drawer.dart';

class ColorPoppinScreen extends StatefulWidget {
  const ColorPoppinScreen({super.key});

  @override
  State<ColorPoppinScreen> createState() => _ColorPoppinScreenState();
}

class _ColorPoppinScreenState extends State<ColorPoppinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _popController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  Color _backgroundColor = AppColors.primary;
  Offset _buttonPosition = const Offset(100, 100);
  String _randomFont = "Poppins";

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _popController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _popController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _popController, curve: Curves.easeInOut),
    );
  }

  void _changeColorAndPosition() {
    SoundService().playSound(SoundIdentifier.POP);

    _popController.forward().then((_) {
      setState(() {
        _backgroundColor = RandomHelper.generateRandomColor();
        _randomFont = RandomHelper.getRandomFont();
        _buttonPosition = RandomHelper.generateRandomPosition(
          MediaQuery.of(context).size,
          56,
        );
      });

      _popController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: _backgroundColor,
          child: AppBar(
            backgroundColor: AppColors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(
              color: ColorHelper.getContrastColor(_backgroundColor),
            ),
          ),
        ),
      ),
      drawer: const MainDrawer(),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _backgroundColor,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                "POP!",
                style: GoogleFonts.getFont(
                  _randomFont,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: ColorHelper.getContrastColor(_backgroundColor),
                ),
              ),
            ),
            Positioned(
              left: _buttonPosition.dx,
              top: _buttonPosition.dy,
              child: AnimatedBuilder(
                animation: _popController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: RoundedButton(
                  onPressed: _changeColorAndPosition,
                  icon: Icons.color_lens,
                  color: ColorHelper.getContrastColor(_backgroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
