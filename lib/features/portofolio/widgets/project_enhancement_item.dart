// lib/features/portofolio/widgets/project_enhancement_item.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_model.dart';

class ProjectEnhancementItem extends StatelessWidget {
  final FutureEnhancement enhancement;
  final Color themeColor;

  const ProjectEnhancementItem({
    Key? key,
    required this.enhancement,
    required this.themeColor,
  }) : super(key: key);

  Color _getStatusColor(String status, Color defaultColor) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'planned':
        return defaultColor;
      default:
        return defaultColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    String statusText = enhancement.status ?? "Planned";
    Color statusColor = _getStatusColor(statusText, themeColor);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.upcoming_outlined,
                size: 18,
                color: themeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  enhancement.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            enhancement.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
