// lib/features/project/widgets/project_feature_item.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/feature_model.dart';
import 'package:mb/features/portofolio/utils/project_icon_mapper.dart';

class ProjectFeatureItem extends StatelessWidget {
  final Feature feature;
  final Color themeColor;

  const ProjectFeatureItem({
    Key? key,
    required this.feature,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.check_circle_outline;
    iconData = ProjectIconMapper.getIconFromName(feature.iconName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              iconData,
              size: 18,
              color: themeColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
