// lib/features/upsert_project/widgets/project_images_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';
import 'package:mb/widgets/cached_image_widget.dart';

class ProjectImagesSection extends StatefulWidget {
  final List<String> carouselImages;
  final Color themeColor;
  final Function(List<String>) onImagesChanged;
  final GlobalKey<FormFieldState>? formFieldKey;
  final String projectId;

  const ProjectImagesSection({
    Key? key,
    required this.carouselImages,
    required this.themeColor,
    required this.onImagesChanged,
    this.formFieldKey,
    required this.projectId,
  }) : super(key: key);

  @override
  State<ProjectImagesSection> createState() => _ProjectImagesSectionState();
}

class _ProjectImagesSectionState extends State<ProjectImagesSection> {
  late List<String> _images;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.carouselImages);
    _validateImages();
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images.add(image.path);
        _errorMessage = null;
      });
      widget.onImagesChanged(_images);
      _validateImages();
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _images.length) {
        _images.removeAt(index);
      }
    });
    widget.onImagesChanged(_images);
    _validateImages();
  }

  void _validateImages() {
    if (_images.isEmpty) {
      setState(() {
        _errorMessage = "At least one project image is required";
      });
      if (widget.formFieldKey?.currentState != null) {
        widget.formFieldKey!.currentState!.validate();
      }
    } else {
      setState(() {
        _errorMessage = null;
      });
      if (widget.formFieldKey?.currentState != null) {
        widget.formFieldKey!.currentState!.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      key: widget.formFieldKey,
      initialValue: _images,
      validator: (_) => _errorMessage,
      builder: (FormFieldState<List<String>> field) {
        return CollapsibleSectionHeader(
          icon: Icons.image_outlined,
          title: "Project Images",
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
                  "Add images of your project to showcase its appearance and features. At least one image is required.",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Add image button
                    InkWell(
                      onTap: _addImage,
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _errorMessage != null
                                ? Colors.red.shade300
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: _errorMessage != null
                                  ? Colors.red.shade400
                                  : Colors.grey.shade600,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Add Image",
                              style: TextStyle(
                                fontSize: 12,
                                color: _errorMessage != null
                                    ? Colors.red.shade400
                                    : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Display selected images using cached image widget when appropriate
                    ..._images.asMap().entries.map((entry) {
                      final index = entry.key;
                      final path = entry.value;

                      return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _buildImageWidget(path, index),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Error message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageWidget(String path, int index) {
    if (!path.startsWith('http')) {
      // Image Picker
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } else {
      // Remote/Cached
      return CachedImageWidget(
        imageUrl: path,
        projectId: widget.projectId,
        imageType: 'carousel_$index',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(12),
        placeholder: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(widget.themeColor),
            ),
          ),
        ),
        errorWidget: Container(
          color: Colors.grey.shade200,
          child: Icon(
            Icons.image_not_supported,
            color: Colors.grey.shade400,
            size: 32,
          ),
        ),
      );
    }
  }
}
