// lib/features/upsert_project/widgets/project_tech_stack_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/upsert_project/widgets/chip_list.dart';

class ProjectTechStackSection extends StatefulWidget {
  final List<String> techStack;
  final Color themeColor;
  final Function(List<String>) onTechStackChanged;

  const ProjectTechStackSection({
    Key? key,
    required this.techStack,
    required this.themeColor,
    required this.onTechStackChanged,
  }) : super(key: key);

  @override
  State<ProjectTechStackSection> createState() =>
      _ProjectTechStackSectionState();
}

class _ProjectTechStackSectionState extends State<ProjectTechStackSection> {
  final TextEditingController _techController = TextEditingController();
  late List<String> _techStack;

  @override
  void initState() {
    super.initState();
    _techStack = List.from(widget.techStack);
  }

  @override
  void dispose() {
    _techController.dispose();
    super.dispose();
  }

  void _addTechStack() {
    if (_techController.text.isNotEmpty) {
      setState(() {
        _techStack.add(_techController.text);
        _techController.clear();
      });
      widget.onTechStackChanged(_techStack);
    }
  }

  void _removeTech(int index) {
    setState(() {
      _techStack.removeAt(index);
    });
    widget.onTechStackChanged(_techStack);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.code_rounded,
          title: "Tech Stack",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _techController,
                decoration: InputDecoration(
                  hintText: "Add technology",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addTechStack,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: widget.themeColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Add"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Display tech stack chips
        ChipList(
          items: _techStack,
          chipColor: Colors.grey.shade100,
          textColor: Colors.grey.shade800,
          borderColor: Colors.grey.shade200,
          onDelete: _removeTech,
        ),
      ],
    );
  }
}
