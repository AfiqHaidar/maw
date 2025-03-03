import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/core/utils/contrast_color.dart';
import 'package:mb/core/utils/random_position.dart';
import 'package:mb/widgets/rounded_icon_button.dart';
import 'package:mb/features/scaffold/widgets/main_drawer.dart';

class ColorPoppinScreen extends StatefulWidget {
  const ColorPoppinScreen({super.key});

  @override
  State<ColorPoppinScreen> createState() => _ColorPoppinScreenState();
}

class _ColorPoppinScreenState extends State<ColorPoppinScreen> {
  Color _backgroundColor = AppColors.primary;
  Offset _buttonPosition = const Offset(100, 100);
  String _randomFont = "Poppins";

  final List<String> _fontList = [
    // Modern & Clean
    "Poppins",
    "Roboto",
    "Inter",
    "Lato",
    "Montserrat",
    "Nunito",
    "Open Sans",
    "Raleway",
    "Work Sans",

    // Playful & Fun
    "Lobster",
    "Pacifico",
    "Bungee",
    "Fredoka One",
    "Concert One",
    "Chewy",
    "Baloo Bhai 2",
    "Indie Flower",
    "Caveat",
    "Shadows Into Light",

    // Bold & Impactful
    "Oswald",
    "Anton",
    "Bebas Neue",
    "Bungee Inline",
    "Ultra",
    "Julius Sans One",
    "Fjalla One",
    "Racing Sans One",

    // Elegant & Classic
    "Playfair Display",
    "Merriweather",
    "Cinzel",
    "EB Garamond",
    "Cormorant Garamond",
    "Libre Baskerville",
    "DM Serif Display",
    "PT Serif",

    // Futuristic & Techy
    "Orbitron",
    "Press Start 2P",
    "Audiowide",
    "Exo",
    "Oxanium",
    "Teko",
    "Russo One",

    // Handwritten & Script
    "Dancing Script",
    "Satisfy",
    "Parisienne",
    "Great Vibes",
    "Sacramento",
    "Cookie",
    "Tangerine",

    // Unique & Decorative
    "Bungee Outline",
    "Bungee Shade",
    "Titan One",
    "Black Ops One",
    "Rubik Wet Paint",
    "Metal Mania",
    "Press Start 2P"
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setRandomPosition();
  }

  void _setRandomPosition() {
    Size screenSize = MediaQuery.of(context).size;
    setState(() {
      _buttonPosition = RandomPositionUtil.generateRandomPosition(
        screenSize,
        56,
      );
    });
  }

  void _changeColorAndPosition() {
    setState(() {
      _backgroundColor = _generateRandomColor();
      _randomFont = _getRandomFont();
      _setRandomPosition();
    });
  }

  Color _generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  String _getRandomFont() {
    final Random random = Random();
    return _fontList[random.nextInt(_fontList.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  color: ContrastColorUtil.getContrastColor(_backgroundColor),
                ),
              ),
            ),
            Positioned(
              left: _buttonPosition.dx,
              top: _buttonPosition.dy,
              child: RoundedButton(
                onPressed: _changeColorAndPosition,
                icon: Icons.color_lens,
                color: ContrastColorUtil.getContrastColor(_backgroundColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
