// lib/features/upsert_project/widgets/upsert_project_links_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/upsert_project/validators/project_links_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

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
  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState!.validate()) {
      if (_additionalLinkController.text.isNotEmpty) {
        final formattedUrl =
            ProjectLinksValidator.formatUrl(_additionalLinkController.text);
        setState(() {
          _additionalLinks.add(formattedUrl);
          _additionalLinkController.clear();
        });
        widget.onAdditionalLinksChanged(_additionalLinks);
      }
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
    return CollapsibleSectionHeader(
      icon: Icons.category_outlined,
      title: "Project Links",
      themeColor: widget.themeColor,
      initiallyExpanded: true,
      headerPadding: const EdgeInsets.only(top: 8),
      contentPadding: const EdgeInsets.only(top: 16, left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description text
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Add links to your project to make it accessible to visitors.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

          TextFormField(
            controller: widget.linkController,
            decoration: InputDecoration(
              labelText: "Project Link",
              hintText: "https://...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.link),
              helperText: "Main link to your project",
              helperStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              errorStyle: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: ProjectLinksValidator.validateMainLink,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: widget.githubLinkController,
            decoration: InputDecoration(
              labelText: "GitHub Link",
              hintText: "https://github.com/...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.code),
              helperText:
                  "Optional, link to the project's source code repository",
              helperStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
              errorStyle: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            validator: ProjectLinksValidator.validateGithubLink,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),

          const SizedBox(height: 24),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Additional links section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add_link,
                            color: widget.themeColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Additional Links",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Add more links to documentation, demos, or related resources.",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),

                // Add additional link
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          errorStyle: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return ProjectLinksValidator.validateAdditionalLink(
                                value);
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addAdditionalLink,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: widget.themeColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 18),
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
                          color: widget.themeColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: widget.themeColor.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: widget.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.link,
                              color: widget.themeColor,
                              size: 18,
                            ),
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
                            vertical: 8,
                          ),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // Empty state for additional links
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: widget.themeColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.link_off,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No additional links added",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Add links to documentation or related resources",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
