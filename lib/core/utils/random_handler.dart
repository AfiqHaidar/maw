import 'dart:math';
import 'package:flutter/material.dart';

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

class RandomHandler {
  static Offset generateRandomPosition(Size screenSize, double buttonSize) {
    final random = Random();

    double paddingY = screenSize.height * (2 / 8);
    double paddingX = screenSize.width * 0.1;

    double maxX = screenSize.width - buttonSize - paddingX;
    double maxY = screenSize.height - buttonSize - paddingY;

    double randomX = paddingX + random.nextDouble() * (maxX - paddingX);
    double randomY = paddingY + random.nextDouble() * (maxY - paddingY);

    return Offset(randomX, randomY);
  }

  static Color generateRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
        255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  static String getRandomFont() {
    final Random random = Random();
    return _fontList[random.nextInt(_fontList.length)];
  }
}
