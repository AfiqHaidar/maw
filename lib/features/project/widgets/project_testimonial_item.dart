// lib/features/project/widgets/project_testimonial_item.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/testimonial_model.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ProjectTestimonialItem extends StatelessWidget {
  final Testimonial testimonial;
  final Color themeColor;
  final String projectId;

  const ProjectTestimonialItem({
    Key? key,
    required this.testimonial,
    required this.themeColor,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.format_quote,
            size: 24,
            color: themeColor,
          ),
          const SizedBox(height: 8),
          Text(
            testimonial.quote,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade800,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildAvatar(),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    testimonial.role,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (testimonial.avatarPath.isEmpty) {
      return Icon(
        Icons.person,
        color: themeColor,
        size: 20,
      );
    }

    if (testimonial.avatarPath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        testimonial.avatarPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: themeColor,
            size: 20,
          );
        },
      );
    } else if (testimonial.avatarPath.startsWith('http')) {
      // Remote URL - use cached image
      return CachedImageWidget(
        imageUrl: testimonial.avatarPath,
        projectId: projectId,
        imageType: 'testimonial_avatar',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        placeholder: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
            ),
          ),
        ),
        errorWidget: Icon(
          Icons.person,
          color: themeColor,
          size: 20,
        ),
      );
    } else {
      // Fallback
      return Icon(
        Icons.person,
        color: themeColor,
        size: 20,
      );
    }
  }
}
