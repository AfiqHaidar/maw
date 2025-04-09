// lib/features/upsert_project/widgets/upsert_project_details_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/upsert_project/validators/project_details_validator.dart';

class ProjectDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController shortDescriptionController;
  final TextEditingController detailsController;
  final Color themeColor;

  const ProjectDetailsSection({
    Key? key,
    required this.nameController,
    required this.shortDescriptionController,
    required this.detailsController,
    required this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.description_outlined,
          title: "Project Details",
          themeColor: themeColor,
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Describe your project's purpose, core functionality, and what makes it unique. ",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),

        TextFormField(
          controller: nameController,
          style: const TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Project Name",
            hintText: "Enter project name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorStyle: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: ProjectDetailsValidator.validateName,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        const SizedBox(height: 16),

        // Short description field
        TextFormField(
          controller: shortDescriptionController,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            labelText: "Short Description",
            hintText: "Brief overview of your project",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorStyle: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          maxLines: 2,
          validator: ProjectDetailsValidator.validateShortDescription,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),

        const SizedBox(height: 16),

        // Project description
        TextFormField(
          controller: detailsController,
          decoration: InputDecoration(
            labelText: "Full Description",
            hintText: "Write a detailed description of your project...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.all(16),
            errorStyle: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w500,
            ),
            helperText: "Minimum 50 characters required",
            helperStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            counterText: "${detailsController.text.length} characters",
            counterStyle: TextStyle(
              color: detailsController.text.length < 50
                  ? Colors.red.shade400
                  : Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          maxLines: 8,
          validator: ProjectDetailsValidator.validateDetails,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            // Force rebuild to update character count
            (context as Element).markNeedsBuild();
          },
        )
      ],
    );
  }
}
