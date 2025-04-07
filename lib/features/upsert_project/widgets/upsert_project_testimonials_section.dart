// lib/features/upsert_project/widgets/upsert_project_testimonials_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/data/models/testimonial_model.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

class ProjectTestimonialsSection extends StatefulWidget {
  final List<Testimonial> initialTestimonials;
  final Color themeColor;
  final Function(List<Testimonial>) onTestimonialsChanged;

  const ProjectTestimonialsSection({
    Key? key,
    required this.initialTestimonials,
    required this.themeColor,
    required this.onTestimonialsChanged,
  }) : super(key: key);

  @override
  State<ProjectTestimonialsSection> createState() =>
      _ProjectTestimonialsSectionState();
}

class _ProjectTestimonialsSectionState
    extends State<ProjectTestimonialsSection> {
  late List<Testimonial> _testimonials;

  @override
  void initState() {
    super.initState();
    _testimonials = List.from(widget.initialTestimonials);
  }

  void _openAddTestimonialDialog() async {
    final Testimonial? newTestimonial = await showDialog<Testimonial>(
      context: context,
      builder: (context) => TestimonialFormDialog(
        themeColor: widget.themeColor,
      ),
    );

    if (newTestimonial != null) {
      setState(() {
        _testimonials.add(newTestimonial);
      });
      widget.onTestimonialsChanged(_testimonials);
    }
  }

  void _openEditTestimonialDialog(int index) async {
    final Testimonial? updatedTestimonial = await showDialog<Testimonial>(
      context: context,
      builder: (context) => TestimonialFormDialog(
        themeColor: widget.themeColor,
        testimonial: _testimonials[index],
      ),
    );

    if (updatedTestimonial != null) {
      setState(() {
        _testimonials[index] = updatedTestimonial;
      });
      widget.onTestimonialsChanged(_testimonials);
    }
  }

  void _removeTestimonial(int index) {
    setState(() {
      _testimonials.removeAt(index);
    });
    widget.onTestimonialsChanged(_testimonials);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.format_quote,
          title: "User Testimonials",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        // Add Testimonial button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openAddTestimonialDialog,
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text("Add Testimonial"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: widget.themeColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Display testimonials
        if (_testimonials.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              final testimonial = _testimonials[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quote icon
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.format_quote,
                            color: widget.themeColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Quote text
                        Expanded(
                          child: Text(
                            testimonial.quote,
                            style: TextStyle(
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Author info
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: testimonial.avatarPath.isNotEmpty
                              ? testimonial.avatarPath.startsWith('assets/')
                                  ? Image.asset(
                                      testimonial.avatarPath,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(testimonial.avatarPath),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.person);
                                      },
                                    )
                              : const Icon(Icons.person),
                        ),
                        const SizedBox(width: 12),
                        // Author name and role
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                testimonial.author,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
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
                        ),
                        // Action buttons
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: widget.themeColor,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _openEditTestimonialDialog(index),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red.shade400,
                                size: 20,
                              ),
                              onPressed: () => _removeTestimonial(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
                  Icons.format_quote,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No testimonials added yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add feedback from users of your project",
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
    );
  }
}

// Dialog for adding/editing testimonials
class TestimonialFormDialog extends StatefulWidget {
  final Color themeColor;
  final Testimonial? testimonial;

  const TestimonialFormDialog({
    Key? key,
    required this.themeColor,
    this.testimonial,
  }) : super(key: key);

  @override
  State<TestimonialFormDialog> createState() => _TestimonialFormDialogState();
}

class _TestimonialFormDialogState extends State<TestimonialFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quoteController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String _avatarPath = '';

  @override
  void initState() {
    super.initState();
    if (widget.testimonial != null) {
      _quoteController.text = widget.testimonial!.quote;
      _authorController.text = widget.testimonial!.author;
      _roleController.text = widget.testimonial!.role;
      _avatarPath = widget.testimonial!.avatarPath;
    }
  }

  @override
  void dispose() {
    _quoteController.dispose();
    _authorController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _avatarPath = image.path;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final testimonial = Testimonial(
        quote: _quoteController.text,
        author: _authorController.text,
        role: _roleController.text,
        avatarPath: _avatarPath,
      );
      Navigator.of(context).pop(testimonial);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialog header
                Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      color: widget.themeColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.testimonial == null
                          ? "Add Testimonial"
                          : "Edit Testimonial",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Center avatar picker
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickAvatar,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.themeColor.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _avatarPath.isNotEmpty
                              ? _avatarPath.startsWith('assets/')
                                  ? Image.asset(
                                      _avatarPath,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(_avatarPath),
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_add,
                                              color: widget.themeColor,
                                              size: 32,
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Add Photo",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_add,
                                      color: widget.themeColor,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      "Add Photo",
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tap to change",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Quote field
                TextFormField(
                  controller: _quoteController,
                  decoration: InputDecoration(
                    labelText: "Testimonial Quote",
                    hintText: "What the user said about your project",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.format_quote),
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quote';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Author name field
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: "Author Name",
                    hintText: "Who provided this testimonial",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Role field
                TextFormField(
                  controller: _roleController,
                  decoration: InputDecoration(
                    labelText: "Author Role",
                    hintText: "e.g., Product Manager, User, Client",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.work_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an author role';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // Submit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel button
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 12),
                    // Save button
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: widget.themeColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.testimonial == null
                            ? "Add Testimonial"
                            : "Save Changes",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
