// lib/features/portofolio/screens/edit_project_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mb/data/enums/banner_identifier.dart';
import 'package:mb/data/models/project_model.dart';
import 'package:mb/features/portofolio/data/project_item.dart';
import 'package:mb/features/Portofolio/screens/project_screen.dart';
import 'package:mb/features/portofolio/widgets/project_section_header.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final ProjectModel project;

  const EditProjectScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _detailsController;
  late TextEditingController _shortDescriptionController;
  late TextEditingController _linkController;
  late TextEditingController _githubLinkController;
  late TextEditingController _roleController;
  final _techController = TextEditingController();
  final _tagController = TextEditingController();

  late DateTime? _releaseDate;
  late String? _selectedCategory;
  late Color _selectedColor;
  late BannerIdentifier _bannerType;
  late String? _selectedLogoPath;
  late List<String> _carouselImages;
  late List<String> _techStack;
  late List<String> _tags;
  late int _developmentDays;

  // Sample categories
  final List<String> _categories = [
    'Arcade Games',
    'Logic Puzzles',
    'Mobile Apps',
    'Web Development',
    'Tools'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing project data
    _nameController = TextEditingController(text: widget.project.name);
    _detailsController = TextEditingController(text: widget.project.details);
    _shortDescriptionController =
        TextEditingController(text: widget.project.shortDescription ?? '');
    _linkController = TextEditingController(text: widget.project.link);
    _githubLinkController =
        TextEditingController(text: widget.project.githubLink ?? '');
    _roleController = TextEditingController(text: widget.project.role ?? '');

    // Initialize other fields
    _releaseDate = widget.project.releaseDate;
    _selectedCategory = widget.project.category;
    _selectedColor = widget.project.bannerBgColor;
    _bannerType = widget.project.bannerType;
    _selectedLogoPath = widget.project.bannerImagePath;
    _carouselImages = List.from(widget.project.carouselImagePaths);
    _techStack = widget.project.techStack != null
        ? List.from(widget.project.techStack!)
        : [];
    _tags = widget.project.tags != null ? List.from(widget.project.tags!) : [];
    _developmentDays = widget.project.developmentTime?.inDays ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    _shortDescriptionController.dispose();
    _linkController.dispose();
    _githubLinkController.dispose();
    _roleController.dispose();
    _techController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _saveProject() {
    if (_formKey.currentState!.validate()) {
      // Create updated project using the form data
      final updatedProject = ProjectModel(
        id: widget.project.id, // Keep the same ID
        userId: widget.project.userId, // Keep the same user ID
        name: _nameController.text,
        bannerBgColor: _selectedColor,
        bannerType: _bannerType,
        bannerImagePath: 'assets/images/logo.jpg', // Use default image path
        bannerLottiePath:
            'assets/animations/stare_cat.json', // Keep the same lottie path
        carouselImagePaths: [
          'assets/images/games/tetris.jpg',
          'assets/images/games/dino.jpg',
          'assets/images/games/dino.jpg',
          'assets/images/games/dino.jpg',
        ],
        details: _detailsController.text,
        link: _linkController.text,
        techStack: _techStack.isNotEmpty ? _techStack : null,
        tags: _tags.isNotEmpty ? _tags : null,
        releaseDate: _releaseDate,
        shortDescription: _shortDescriptionController.text.isNotEmpty
            ? _shortDescriptionController.text
            : null,
        role: _roleController.text.isNotEmpty ? _roleController.text : null,
        developmentTime:
            _developmentDays > 0 ? Duration(days: _developmentDays) : null,
        category: _selectedCategory ?? _categories.first,
        // Keep existing additional data
        keyFeatures: widget.project.keyFeatures,
        challenges: widget.project.challenges,
        teamMembers: widget.project.teamMembers,
        futureEnhancements: widget.project.futureEnhancements,
        testimonials: widget.project.testimonials,
        additionalLinks: widget.project.additionalLinks,
        githubLink: _githubLinkController.text.isNotEmpty
            ? _githubLinkController.text
            : null,
        stats: widget.project.stats,
      );

      // Update the project in the provider
      ref.read(projectsProvider.notifier).updateProject(updatedProject);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Project "${updatedProject.name}" updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop(); // Close edit screen first
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectScreen(project: updatedProject),
        ),
      );
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _releaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _releaseDate) {
      setState(() {
        _releaseDate = picked;
      });
    }
  }

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedLogoPath = image.path;
      });
    }
  }

  Future<void> _addImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _carouselImages.add(image.path);
      });
    }
  }

  void _addTechStack() {
    if (_techController.text.isNotEmpty) {
      setState(() {
        _techStack.add(_techController.text);
        _techController.clear();
      });
    }
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Project",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: _selectedColor,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project banner with color picker and logo selection
              Container(
                width: double.infinity,
                color: _selectedColor,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickLogo,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          image: _selectedLogoPath != null
                              ? DecorationImage(
                                  image:
                                      _selectedLogoPath!.startsWith('assets/')
                                          ? AssetImage(_selectedLogoPath!)
                                              as ImageProvider
                                          : FileImage(File(_selectedLogoPath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedLogoPath == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Add Logo",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Color picker button
                    InkWell(
                      onTap: () {
                        // Show color picker dialog
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.color_lens,
                                          size: 20,
                                          color: _selectedColor,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Select Banner Color",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Color Grid
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: [
                                      _colorChoice(Colors.blue),
                                      _colorChoice(Colors.red),
                                      _colorChoice(Colors.green),
                                      _colorChoice(Colors.orange),
                                      _colorChoice(Colors.purple),
                                      _colorChoice(Colors.teal),
                                      _colorChoice(Colors.pink),
                                      _colorChoice(Colors.indigo),
                                      _colorChoice(Colors.amber),
                                      _colorChoice(Colors.cyan),
                                      _colorChoice(Colors.lime),
                                      _colorChoice(Colors.brown),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  // Done button
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: _selectedColor,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text("Done"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Change Theme Color",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Project name and description section
                    ProjectSectionHeader(
                      icon: Icons.description_outlined,
                      title: "Project Details",
                      themeColor: _selectedColor,
                    ),
                    const SizedBox(height: 16),

                    // Project name field
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: "Project Name",
                        hintText: "Enter project name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a project name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Short description field
                    TextFormField(
                      controller: _shortDescriptionController,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Short Description",
                        hintText: "Brief overview of your project",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    // Project description
                    TextFormField(
                      controller: _detailsController,
                      decoration: InputDecoration(
                        labelText: "Full Description",
                        hintText:
                            "Write a detailed description of your project...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a project description';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Project images
                    ProjectSectionHeader(
                      icon: Icons.image,
                      title: "Project Images",
                      themeColor: _selectedColor,
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
                          ..._carouselImages.asMap().entries.map((entry) {
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
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.red),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (index < _carouselImages.length) {
                                      _carouselImages.removeAt(index);
                                    }
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Category selection
                    ProjectSectionHeader(
                      icon: Icons.category_outlined,
                      title: "Category",
                      themeColor: _selectedColor,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        hintText: "Select Category",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Project Links
                    ProjectSectionHeader(
                      icon: Icons.link_rounded,
                      title: "Project Links",
                      themeColor: _selectedColor,
                    ),
                    const SizedBox(height: 16),

                    // Link field
                    TextFormField(
                      controller: _linkController,
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
                      controller: _githubLinkController,
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

                    // Project info
                    ProjectSectionHeader(
                      icon: Icons.info_outline,
                      title: "Project Info",
                      themeColor: _selectedColor,
                    ),
                    const SizedBox(height: 16),

                    // Role field
                    TextFormField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        labelText: "Your Role (optional)",
                        hintText: "Lead Developer",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Release date picker
                    InkWell(
                      onTap: _pickDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Release Date (optional)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _releaseDate != null
                              ? "${_releaseDate!.year}/${_releaseDate!.month.toString().padLeft(2, '0')}"
                              : "Select date",
                          style: TextStyle(
                            color: _releaseDate != null
                                ? Colors.black
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Development time
                    TextFormField(
                      initialValue: _developmentDays.toString(),
                      decoration: InputDecoration(
                        labelText: "Development Time in Days (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _developmentDays = int.tryParse(value) ?? 0;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Tech stack
                    ProjectSectionHeader(
                      icon: Icons.code_rounded,
                      title: "Tech Stack",
                      themeColor: _selectedColor,
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
                            backgroundColor: _selectedColor,
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _techStack
                          .map(
                            (tech) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tech,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _techStack.remove(tech);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 24),

                    // Tags
                    ProjectSectionHeader(
                      icon: Icons.tag_rounded,
                      title: "Tags",
                      themeColor: _selectedColor,
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
                            backgroundColor: _selectedColor,
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _tags
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _selectedColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "#$tag",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedColor,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _tags.remove(tag);
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: _selectedColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ElevatedButton.icon(
                        onPressed: _saveProject,
                        icon: const Icon(Icons.save_rounded, size: 20),
                        label: const Text("Update Project"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: _selectedColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorChoice(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _selectedColor == color
            ? const Icon(Icons.check, color: Colors.white, size: 26)
            : null,
      ),
    );
  }
}
