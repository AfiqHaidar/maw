// lib/features/upsert_project/widgets/upsert_project_tech_stack_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

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
    final tech = _techController.text.trim();
    if (tech.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a technology name";
      });
      return;
    }

    // Check for duplicates
    if (_techStack.contains(tech)) {
      setState(() {
        _errorMessage = "$tech is already in your tech stack";
      });
      return;
    }

    setState(() {
      _techStack.add(tech);
      _techController.clear();
      _errorMessage = null;
    });
    widget.onTechStackChanged(_techStack);
  }

  void _removeTech(int index) {
    setState(() {
      _techStack.removeAt(index);
    });
    widget.onTechStackChanged(_techStack);
  }

  void _editTech(int index) {
    final currentTech = _techStack[index];
    _techController.text = currentTech;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit,
                color: widget.themeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Edit Technology",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: TextField(
          controller: _techController,
          decoration: InputDecoration(
            labelText: "Technology Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "e.g., Flutter, React, Java",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_techController.text.trim().isNotEmpty) {
                setState(() {
                  _techStack[index] = _techController.text.trim();
                  _techController.clear();
                });
                widget.onTechStackChanged(_techStack);
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: widget.themeColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
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

        // Description text
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Add the technologies, frameworks, and languages used in your project.",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),

        // Add tech stack form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        prefixIcon: Icon(
                          Icons.code,
                          color: widget.themeColor,
                        ),
                        errorText: _errorMessage,
                      ),
                      onFieldSubmitted: (_) => _addTechStack(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addTechStack,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: widget.themeColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Add"),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Display tech stack
        if (_techStack.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          "${_techStack.length} ${_techStack.length == 1 ? 'technology' : 'technologies'}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 14,
                  children: _techStack.asMap().entries.map((entry) {
                    final index = entry.key;
                    final tech = entry.value;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.code,
                              size: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tech,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _editTech(index),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _removeTech(index),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ] else ...[
          // Empty state
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.code_rounded,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No technologies added yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add the programming languages and frameworks used",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            "Highlight technologies to showcase your technical expertise",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
