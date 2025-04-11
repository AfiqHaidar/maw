// lib/features/upsert_project/widgets/upsert_project_banner.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mb/features/upsert_project/widgets/color_picker_dialog.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class UpsertProjectBanner extends StatelessWidget {
  final Color selectedColor;
  final String? selectedLogoPath;
  final VoidCallback onPickLogo;
  final VoidCallback onRemoveLogo;
  final Function(Color) onColorChange;
  final String projectId;

  const UpsertProjectBanner({
    Key? key,
    required this.selectedColor,
    this.selectedLogoPath,
    required this.onPickLogo,
    required this.onRemoveLogo,
    required this.onColorChange,
    required this.projectId,
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
          Stack(
            children: [
              GestureDetector(
                onTap: onPickLogo,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    shape: BoxShape.circle,
                  ),
                  // Simple logic: If user has selected a logo, show it.
                  // Otherwise, show the "Add Logo" placeholder.
                  child: hasLogo
                      ? ClipOval(
                          child: _buildLogoImage(),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add_photo_alternate,
                              color: Colors.white,
                              size: 32,
                            ),
                          ],
                        ),
                ),
              ),
              // Show remove button only if there's a logo
              if (hasLogo)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: onRemoveLogo,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red.shade100,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
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
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.color_lens,
                    size: 16,
                    color: Colors.white,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Change Theme Color",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoImage() {
    if (selectedLogoPath == null || selectedLogoPath!.isEmpty) {
      return const SizedBox();
    }

    if (selectedLogoPath!.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        selectedLogoPath!,
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else if (!selectedLogoPath!.startsWith('http')) {
      // image picker
      return Image.file(
        File(selectedLogoPath!),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      //  cached image
      return CachedImageWidget(
        imageUrl: selectedLogoPath!,
        projectId: projectId,
        imageType: 'logo',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        placeholder: Container(
          color: Colors.white.withOpacity(0.1),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        errorWidget: Container(
          color: Colors.white.withOpacity(0.1),
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.white,
            size: 32,
          ),
        ),
      );
    }
  }
}
