// lib/features/upsert_project/widgets/project_links_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

class ProjectLinksSection extends StatefulWidget {
  final TextEditingController linkController;
  final TextEditingController githubLinkController;
  final List<String> additionalLinks;
  final Color themeColor;
  final Function(List<String>) onAdditionalLinksChanged;

  const ProjectLinksSection({
    Key? key,
    required this.linkController,
    required this.githubLinkController,
    required this.additionalLinks,
    required this.themeColor,
    required this.onAdditionalLinksChanged,
  }) : super(key: key);

  @override
  State<ProjectLinksSection> createState() => _ProjectLinksSectionState();
}

class _ProjectLinksSectionState extends State<ProjectLinksSection> {
  final TextEditingController _additionalLinkController =
      TextEditingController();
  late List<String> _additionalLinks;

  @override
  void initState() {
    super.initState();
    _additionalLinks = List.from(widget.additionalLinks);
  }

  @override
  void dispose() {
    _additionalLinkController.dispose();
    super.dispose();
  }

  void _addAdditionalLink() {
    if (_additionalLinkController.text.isNotEmpty) {
      setState(() {
        _additionalLinks.add(_additionalLinkController.text);
        _additionalLinkController.clear();
      });
      widget.onAdditionalLinksChanged(_additionalLinks);
    }
  }

  void _removeAdditionalLink(int index) {
    setState(() {
      _additionalLinks.removeAt(index);
    });
    widget.onAdditionalLinksChanged(_additionalLinks);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.link_rounded,
          title: "Project Links",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        // Link field
        TextFormField(
          controller: widget.linkController,
          decoration: InputDecoration(
            labelText: "Project Link",
            hintText: "https://...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.link),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a project link';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // GitHub link field
        TextFormField(
          controller: widget.githubLinkController,
          decoration: InputDecoration(
            labelText: "GitHub Link (optional)",
            hintText: "https://github.com/...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.code),
          ),
        ),

        const SizedBox(height: 24),

        // Additional links section
        const Text(
          "Additional Links",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),

        // Add additional link
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _additionalLinkController,
                decoration: InputDecoration(
                  hintText: "Add another link",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.add_link),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addAdditionalLink,
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

        const SizedBox(height: 16),

        // Display additional links
        if (_additionalLinks.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _additionalLinks.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.link,
                    color: widget.themeColor,
                  ),
                  title: Text(
                    _additionalLinks[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade700,
                      size: 18,
                    ),
                    onPressed: () => _removeAdditionalLink(index),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                ),
              );
            },
          ),
        ] else ...[
          // Empty state for additional links (optional)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "No additional links added",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
