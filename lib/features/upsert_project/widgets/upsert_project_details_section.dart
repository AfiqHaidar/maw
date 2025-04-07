// lib/features/upsert_project/widgets/project_details_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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

        // Project name field
        TextFormField(
          controller: nameController,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            labelText: "Project Name",
            hintText: "Enter project name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a project name';
            }
            return null;
          },
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
          ),
          maxLines: 2,
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
          ),
          maxLines: 8,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a project description';
            }
            return null;
          },
        ),
      ],
    );
  }
}
