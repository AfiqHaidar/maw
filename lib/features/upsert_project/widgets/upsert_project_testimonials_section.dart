// lib/features/upsert_project/widgets/upsert_project_testimonials_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/data/models/testimonial_model.dart';
import 'package:mb/features/upsert_project/validators/project_testimonials_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ProjectTestimonialsSection extends StatefulWidget {
  final List<Testimonial> initialTestimonials;
  final Color themeColor;
  final Function(List<Testimonial>) onTestimonialsChanged;
  // Add projectId parameter for cached images
  final String projectId;

  const ProjectTestimonialsSection({
    Key? key,
    required this.initialTestimonials,
    required this.themeColor,
    required this.onTestimonialsChanged,
    required this.projectId,
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
        projectId: widget.projectId,
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
        projectId: widget.projectId,
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
    return CollapsibleSectionHeader(
      icon: Icons.format_quote_outlined,
      title: "User Testimonials",
      themeColor: widget.themeColor,
      initiallyExpanded: false,
      headerPadding: const EdgeInsets.only(top: 8),
      contentPadding: const EdgeInsets.only(top: 16, left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description text
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Add user feedback and testimonials about your project.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

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
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: widget.themeColor.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                      colorScheme: ColorScheme.light(
                        primary: widget.themeColor,
                      ),
                    ),
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.format_quote,
                          color: widget.themeColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        testimonial.author,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            margin: const EdgeInsets.only(right: 8, top: 4),
                            decoration: BoxDecoration(
                              color: widget.themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.themeColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              testimonial.role,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: widget.themeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      childrenPadding: const EdgeInsets.all(16),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Avatar with cached image
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: widget.themeColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: _buildAvatarWidget(testimonial, index),
                                ),
                                const SizedBox(width: 12),
                                // Quote
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '"${testimonial.quote}"',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 14,
                                            height: 1.5,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Edit button
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _openEditTestimonialDialog(index),
                                  icon: const Icon(Icons.edit, size: 18),
                                  label: const Text("Edit"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: widget.themeColor,
                                    side: BorderSide(color: widget.themeColor),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Delete button
                                OutlinedButton.icon(
                                  onPressed: () => _removeTestimonial(index),
                                  icon: const Icon(Icons.delete_outline,
                                      size: 18),
                                  label: const Text("Delete"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red.shade400,
                                    side:
                                        BorderSide(color: Colors.red.shade200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
                color: widget.themeColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: widget.themeColor.withOpacity(0.1)),
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
      ),
    );
  }

  // Helper method to build the appropriate avatar widget based on the path
  Widget _buildAvatarWidget(Testimonial testimonial, int index) {
    final avatarPath = testimonial.avatarPath;

    if (avatarPath.isEmpty) {
      return Icon(
        Icons.person,
        color: widget.themeColor,
        size: 30,
      );
    } else if (avatarPath.startsWith('assets/')) {
      // For asset images
      return Image.asset(
        avatarPath,
        fit: BoxFit.cover,
      );
    } else if (!avatarPath.startsWith('http')) {
      // For local file (from image picker)
      return Image.file(
        File(avatarPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            color: widget.themeColor,
            size: 30,
          );
        },
      );
    } else {
      // For HTTP URLs, use cached image widget
      return CachedImageWidget(
        imageUrl: avatarPath,
        projectId: widget.projectId,
        imageType: 'testimonial_avatar_$index',
        fit: BoxFit.cover,
        placeholder: Container(
          color: widget.themeColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: widget.themeColor,
            size: 30,
          ),
        ),
        errorWidget: Container(
          color: widget.themeColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: widget.themeColor,
            size: 30,
          ),
        ),
      );
    }
  }
}

// Dialog for adding/editing testimonials
class TestimonialFormDialog extends StatefulWidget {
  final Color themeColor;
  final Testimonial? testimonial;
  final String projectId;

  const TestimonialFormDialog({
    Key? key,
    required this.themeColor,
    this.testimonial,
    required this.projectId,
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
        quote: _quoteController.text.trim(),
        author: _authorController.text.trim(),
        role: _roleController.text.trim(),
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
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.themeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.format_quote,
                        color: widget.themeColor,
                        size: 24,
                      ),
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

                // Author name field
                TextFormField(
                  controller: _authorController,
                  decoration: InputDecoration(
                    labelText: "Author Name",
                    hintText: "Who provided this testimonial",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: "Name of the person who gave this feedback",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectTestimonialsValidator.validateAuthor,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    helperText:
                        "The author's position or relationship to the project",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectTestimonialsValidator.validateRole,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Quote field
                TextFormField(
                  controller: _quoteController,
                  decoration: InputDecoration(
                    labelText: "Testimonial Quote",
                    hintText: "What they said about your project",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    helperText:
                        "The feedback or testimonial in their own words",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: ProjectTestimonialsValidator.validateQuote,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 24),

                // Avatar picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickAvatar,
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.themeColor.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildAvatarPreview(),
                        ),
                      ),
                    ),
                  ],
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

  // Helper method to build the avatar preview in the dialog
  Widget _buildAvatarPreview() {
    if (_avatarPath.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            color: widget.themeColor,
            size: 24,
          ),
        ],
      );
    } else if (_avatarPath.startsWith('assets/')) {
      // For asset images
      return Image.asset(
        _avatarPath,
        fit: BoxFit.cover,
      );
    } else if (!_avatarPath.startsWith('http')) {
      // For local file (from image picker)
      return Image.file(
        File(_avatarPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: widget.themeColor,
                size: 24,
              ),
            ],
          );
        },
      );
    } else {
      // For HTTP URLs, use cached image widget
      return CachedImageWidget(
        imageUrl: _avatarPath,
        projectId: widget.projectId,
        imageType: 'testimonial_avatar_preview',
        fit: BoxFit.cover,
        placeholder: Container(
          color: widget.themeColor.withOpacity(0.1),
          child: Center(
            child: Icon(
              Icons.add_a_photo,
              color: widget.themeColor,
              size: 24,
            ),
          ),
        ),
        errorWidget: Container(
          color: widget.themeColor.withOpacity(0.1),
          child: Center(
            child: Icon(
              Icons.add_a_photo,
              color: widget.themeColor,
              size: 24,
            ),
          ),
        ),
      );
    }
  }
}
