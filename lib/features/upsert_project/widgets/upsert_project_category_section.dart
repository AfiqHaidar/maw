// lib/features/upsert_project/widgets/project_category_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

class ProjectCategorySection extends StatelessWidget {
  final String? selectedCategory;
  final Color themeColor;
  final List<String> categories;
  final Function(String?) onCategoryChanged;

  const ProjectCategorySection({
    Key? key,
    required this.selectedCategory,
    required this.themeColor,
    required this.categories,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.category_outlined,
          title: "Category",
          themeColor: themeColor,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            hintText: "Select Category",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: categories
              .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
              .toList(),
          onChanged: onCategoryChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
        ),
      ],
    );
  }
}
