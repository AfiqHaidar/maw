// lib/features/portfolio/widgets/portfolio_header.dart
import 'package:flutter/material.dart';

class PortofolioHeader extends StatelessWidget {
  final Color themeColor;
  final VoidCallback onAddProject;
  final VoidCallback onMenuPressed;

  const PortofolioHeader({
    Key? key,
    required this.themeColor,
    required this.onAddProject,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 30),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: themeColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Projects",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              // Drawer menu button
              IconButton(
                icon: Icon(Icons.menu, color: Colors.grey[800]),
                onPressed: onMenuPressed,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "A collection of your recent work and personal projects.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: onAddProject,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Add New Project",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
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
}
