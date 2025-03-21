import 'package:flutter/material.dart';
import 'package:mb/core/theme/colors.dart';

class HomeBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onButtonPressed;

  const HomeBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.35,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Glassy card section

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGlowIcon(
                      icon: Icons.menu_open_rounded,
                      onPressed: onButtonPressed,
                      tooltip: "Open Drawer",
                    ),
                    const SizedBox(width: 24),
                    _buildGlowIcon(
                      icon: Icons.favorite_outline,
                      onPressed: () {},
                      tooltip: "Meow Power",
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Add this helper method inside the same class
  Widget _buildGlowIcon({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 28,
        tooltip: tooltip,
        color: Colors.white,
      ),
    );
  }
}
