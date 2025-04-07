// lib/features/upsert_project/widgets/project_tags_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/upsert_project/widgets/chip_list.dart';

class ProjectTagsSection extends StatefulWidget {
  final List<String> tags;
  final Color themeColor;
  final Function(List<String>) onTagsChanged;

  const ProjectTagsSection({
    Key? key,
    required this.tags,
    required this.themeColor,
    required this.onTagsChanged,
  }) : super(key: key);

  @override
  State<ProjectTagsSection> createState() => _ProjectTagsSectionState();
}

class _ProjectTagsSectionState extends State<ProjectTagsSection> {
  final TextEditingController _tagController = TextEditingController();
  late List<String> _tags;

  @override
  void initState() {
    super.initState();
    _tags = List.from(widget.tags);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
      widget.onTagsChanged(_tags);
    }
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
    });
    widget.onTagsChanged(_tags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.tag_rounded,
          title: "Tags",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: "Add tag",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addTag,
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

        // Display tag chips
        ChipList(
          items: _tags,
          chipColor: widget.themeColor.withOpacity(0.1),
          textColor: widget.themeColor,
          showHashtag: true,
          onDelete: _removeTag,
        ),
      ],
    );
  }
}
