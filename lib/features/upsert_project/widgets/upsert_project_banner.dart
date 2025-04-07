// lib/features/upsert_project/widgets/upsert_project_banner.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb/features/upsert_project/widgets/color_picker_dialog.dart';

class UpsertProjectBanner extends StatelessWidget {
  final Color selectedColor;
  final String? selectedLogoPath;
  final VoidCallback onPickLogo;
  final Function(Color) onColorChange;

  const UpsertProjectBanner({
    Key? key,
    required this.selectedColor,
    this.selectedLogoPath,
    required this.onPickLogo,
    required this.onColorChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasLogo =
        selectedLogoPath != null && selectedLogoPath!.isNotEmpty;

    return Container(
      width: double.infinity,
      color: selectedColor,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onPickLogo,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
                image: hasLogo
                    ? DecorationImage(
                        image: selectedLogoPath!.startsWith('assets/')
                            ? AssetImage(selectedLogoPath!) as ImageProvider
                            : FileImage(File(selectedLogoPath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: !hasLogo
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Add Logo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          // Color picker button
          InkWell(
            onTap: () {
              // Show color picker dialog
              showDialog(
                context: context,
                builder: (context) => ColorPickerDialog(
                  selectedColor: selectedColor,
                  onColorSelected: onColorChange,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Change Theme Color",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
