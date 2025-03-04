import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/widgets/fade_slide_wrapper.dart';
import 'package:mb/widgets/rounded_icon_button.dart';

class StartedBox extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final VoidCallback? onButtonPressed;

  const StartedBox({
    super.key,
    required this.title,
    required this.subtitle,
    this.backgroundColor = AppColors.white,
    this.titleStyle,
    this.subtitleStyle,
    this.onButtonPressed,
  });

  @override
  State<StartedBox> createState() => _StartedBoxState();
}

class _StartedBoxState extends State<StartedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _boxController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _boxController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      _boxController.forward();
    });
  }

  @override
  void dispose() {
    _boxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeAndSlideWrapper(
        animationController: _boxController,
        slideOffset: const Offset(0.0, 1.0),
        fadeCurve: const Interval(0.0, 0.2),
        slideCurve: const Interval(0.0, 1.0, curve: Curves.easeOutCirc),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.30,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Animation
              FadeAndSlideWrapper(
                animationController: _boxController,
                fadeCurve: const Interval(0.3, 1.0),
                slideCurve: const Interval(0.0, 1.0),
                slideOffset: const Offset(0.0, 1.0),
                child: Text(
                  widget.title,
                  textAlign: TextAlign.left,
                  style: widget.titleStyle ??
                      Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            letterSpacing: 2.0,
                          ),
                ),
              ),
              const SizedBox(height: 24),

              // Subtitle Animation
              FadeAndSlideWrapper(
                animationController: _boxController,
                fadeCurve: const Interval(0.4, 1.0),
                slideCurve: const Interval(0.0, 1.0),
                slideOffset: const Offset(0.0, 2.0),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.left,
                  style: widget.subtitleStyle ??
                      Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.white70,
                            fontSize: 14,
                            letterSpacing: 2.0,
                          ),
                ),
              ),
              const Spacer(),

              // Button Animation
              Align(
                alignment: Alignment.bottomRight,
                child: FadeAndSlideWrapper(
                  animationController: _boxController,
                  fadeCurve: const Interval(0.5, 1.0),
                  slideCurve: const Interval(0.0, 1.0),
                  slideOffset: const Offset(0.0, 1.0),
                  child: Builder(
                    builder: (context) => RoundedButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icons.arrow_forward_ios,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
