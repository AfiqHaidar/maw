// lib/features/upsert_project/widgets/project_category_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/upsert_project/validators/project_details_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

class ProjectCategorySection extends StatefulWidget {
  final String? selectedCategory;
  final Color themeColor;
  final List<String> categories;
  final Function(String?) onCategoryChanged;

  const ProjectCategorySection({
    Key? key,
    required this.selectedCategory,
    required this.themeColor,
    required this.categories,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  State<ProjectCategorySection> createState() => _ProjectCategorySectionState();
}

class _ProjectCategorySectionState extends State<ProjectCategorySection> {
  late String? _selectedCategory;
  bool _showDropdown = false;
  bool _isCustomCategory = false;
  final GlobalKey _categoryKey = GlobalKey();
  final TextEditingController _customCategoryController =
      TextEditingController();
  late List<String> _categoriesList;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    // Add "Custom" option to categories if not already present
    _categoriesList = List.from(widget.categories);
    if (!_categoriesList.contains('Custom')) {
      _categoriesList.add('Custom');
    }

    // Check if current selection is not in predefined categories
    if (_selectedCategory != null &&
        !widget.categories.contains(_selectedCategory) &&
        _selectedCategory != 'Custom') {
      _isCustomCategory = true;
      _customCategoryController.text = _selectedCategory!;
    }
  }

  @override
  void dispose() {
    _customCategoryController.dispose();
    super.dispose();
  }

  // Map categories to their icons
  IconData _getCategoryIcon(String category) {
    final Map<String, IconData> categoryIcons = {
      'Arcade Games': Icons.sports_esports,
      'Logic Puzzles': Icons.extension,
      'Mobile Apps': Icons.smartphone,
      'Web Development': Icons.web,
      'Tools': Icons.build,
      'Custom': Icons.edit,
      // Add more categories and icons as needed
    };

    return categoryIcons[category] ?? Icons.category;
  }

  // All categories use the theme color for consistency
  Color _getCategoryColor(String category) {
    return widget.themeColor;
  }

  void _toggleDropdown() {
    setState(() {
      _showDropdown = !_showDropdown;
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _showDropdown = false;

      if (category == 'Custom') {
        _isCustomCategory = true;
        // If custom was selected but no text entered yet, don't update parent
        if (_customCategoryController.text.isEmpty) {
          return;
        }
        // Otherwise use the custom text as category
        widget.onCategoryChanged(_customCategoryController.text);
      } else {
        _isCustomCategory = false;
        widget.onCategoryChanged(category);
      }
    });
  }

  void _applyCustomCategory(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _selectedCategory = value;
      });
      widget.onCategoryChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleSectionHeader(
      icon: Icons.category_outlined,
      title: "Category",
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
              "Select a category that best fits your project, or create a custom one if none match your project type.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),
          FormField<String>(
            initialValue: _selectedCategory,
            validator: ProjectDetailsValidator.validateCategory,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visual Category Selection
                  Container(
                    key: _categoryKey,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            state.hasError ? Colors.red : Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Selected Category Display
                        InkWell(
                          onTap: _toggleDropdown,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: _selectedCategory != null
                                  ? _getCategoryColor(_selectedCategory!)
                                      .withOpacity(0.1)
                                  : Colors.grey.shade50,
                            ),
                            child: Row(
                              children: [
                                if (_selectedCategory != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: widget.themeColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _isCustomCategory
                                          ? Icons.edit
                                          : _getCategoryIcon(
                                              _selectedCategory!),
                                      color: widget.themeColor,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      _isCustomCategory
                                          ? _customCategoryController.text
                                          : _selectedCategory!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Icon(
                                    Icons.category_outlined,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    "Select a category",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Icon(
                                  _showDropdown
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dropdown Categories
                        if (_showDropdown)
                          Container(
                            constraints: const BoxConstraints(
                              maxHeight: 250,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _categoriesList.length,
                              itemBuilder: (context, index) {
                                final category = _categoriesList[index];
                                final isSelected = category ==
                                        _selectedCategory ||
                                    (category == 'Custom' && _isCustomCategory);

                                return InkWell(
                                  onTap: () => _selectCategory(category),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? widget.themeColor.withOpacity(0.1)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: widget.themeColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            _getCategoryIcon(category),
                                            color: widget.themeColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? widget.themeColor
                                                : Colors.black87,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: widget.themeColor,
                                            size: 18,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // Custom category input field (shown when "Custom" is selected)
                        if (_isCustomCategory)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter Custom Category",
                                  style: TextStyle(
                                    color: widget.themeColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _customCategoryController,
                                        decoration: InputDecoration(
                                          hintText:
                                              "E.g., Educational, Utility, Game",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                        ),
                                        onSubmitted: _applyCustomCategory,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () => _applyCustomCategory(
                                          _customCategoryController.text),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: widget.themeColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text("Apply"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Validation Error Message
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        state.errorText!,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
