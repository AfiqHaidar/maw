// lib/features/upsert_project/widgets/project_images_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

class ProjectImagesSection extends StatefulWidget {
  final List<String> carouselImages;
  final Color themeColor;
  final Function(List<String>) onImagesChanged;

  const ProjectImagesSection({
    Key? key,
    required this.carouselImages,
    required this.themeColor,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<ProjectImagesSection> createState() => _ProjectImagesSectionState();
}

class _ProjectImagesSectionState extends State<ProjectImagesSection> {
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.carouselImages);
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _images.add(image.path);
      });
      widget.onImagesChanged(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      if (index < _images.length) {
        _images.removeAt(index);
      }
    });
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.image,
          title: "Project Images",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),
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
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          color: Colors.grey.shade600, size: 32),
                      const SizedBox(height: 4),
                      Text(
                        "Add Image",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Display selected images
              ..._images.asMap().entries.map((entry) {
                final index = entry.key;
                final path = entry.value;

                return Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: path.startsWith('assets/')
                          ? AssetImage(path) as ImageProvider
                          : FileImage(File(path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.close, size: 16, color: Colors.red),
                    ),
                    onPressed: () => _removeImage(index),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
