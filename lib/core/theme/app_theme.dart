// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:mb/core/theme/colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 193, 212, 241),
    primary: Color.fromARGB(255, 0, 0, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
