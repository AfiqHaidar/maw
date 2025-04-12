// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:mb/core/theme/colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 0, 36, 90),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
