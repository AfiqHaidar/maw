// lib/features/upsert_project/widgets/upsert_project_features_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/feature_model.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';
import 'package:mb/features/upsert_project/validators/project_features_validator.dart';

class ProjectFeaturesSection extends StatefulWidget {
  final List<Feature> initialFeatures;
  final Color themeColor;
  final Function(List<Feature>) onFeaturesChanged;

  const ProjectFeaturesSection({
    Key? key,
    required this.initialFeatures,
    required this.themeColor,
    required this.onFeaturesChanged,
  }) : super(key: key);

  @override
  State<ProjectFeaturesSection> createState() => _ProjectFeaturesSectionState();
}

class _ProjectFeaturesSectionState extends State<ProjectFeaturesSection> {
  late List<Feature> _features;

  @override
  void initState() {
    super.initState();
    _features = List.from(widget.initialFeatures);
  }

  void _openAddFeatureDialog() async {
    final Feature? newFeature = await showDialog<Feature>(
      context: context,
      builder: (context) => FeatureFormDialog(
        themeColor: widget.themeColor,
      ),
    );

    if (newFeature != null) {
      setState(() {
        _features.add(newFeature);
      });
      widget.onFeaturesChanged(_features);
    }
  }

  void _openEditFeatureDialog(int index) async {
    final Feature? updatedFeature = await showDialog<Feature>(
      context: context,
      builder: (context) => FeatureFormDialog(
        themeColor: widget.themeColor,
        feature: _features[index],
      ),
    );

    if (updatedFeature != null) {
      setState(() {
        _features[index] = updatedFeature;
      });
      widget.onFeaturesChanged(_features);
    }
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
    widget.onFeaturesChanged(_features);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.stars_rounded,
          title: "Key Features",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        // Description text
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            "Add the standout features of your project to showcase what makes it special.",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
            ),
          ),
        ),

        // Add Feature button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openAddFeatureDialog,
            icon: const Icon(Icons.add_circle_outline, size: 20),
            label: const Text("Add Key Feature"),
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

        // Display features
        if (_features.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.themeColor.withOpacity(0.1)),
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
                        IconData(
                          int.tryParse(feature.iconName) ?? 0xe000,
                          fontFamily: 'MaterialIcons',
                        ),
                        color: widget.themeColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      feature.title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.all(16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.description,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Edit button
                              OutlinedButton.icon(
                                onPressed: () => _openEditFeatureDialog(index),
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
                                onPressed: () => _removeFeature(index),
                                icon:
                                    const Icon(Icons.delete_outline, size: 18),
                                label: const Text("Delete"),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade400,
                                  side: BorderSide(color: Colors.red.shade200),
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
                  Icons.lightbulb_outline,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  "No key features added yet",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Showcase what makes your project special",
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

// Dialog for adding/editing features
class FeatureFormDialog extends StatefulWidget {
  final Color themeColor;
  final Feature? feature;

  const FeatureFormDialog({
    Key? key,
    required this.themeColor,
    this.feature,
  }) : super(key: key);

  @override
  State<FeatureFormDialog> createState() => _FeatureFormDialogState();
}

class _FeatureFormDialogState extends State<FeatureFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIconName = '0xe5ca'; // Default icon (check)

  // List of common Material icons for features
  final List<String> _commonIcons = [
    '0xe5ca', // check
    '0xe8b8', // settings
    '0xe80c', // speed
    '0xe3f4', // security
    '0xe87f', // notifications
    '0xe332', // palette
    '0xe8f4', // statistics
    '0xe8b5', // search
    '0xe325', // music
    '0xe051', // videocam
    '0xe0d0', // cloud
    '0xe8f8', // storage
    '0xe873', // language
    '0xe1db', // date_range
    '0xe80e', // timer
    '0xe0af', // share
  ];

  @override
  void initState() {
    super.initState();
    if (widget.feature != null) {
      _titleController.text = widget.feature!.title;
      _descriptionController.text = widget.feature!.description;
      _selectedIconName = widget.feature!.iconName;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final feature = Feature(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        iconName: _selectedIconName,
      );
      Navigator.of(context).pop(feature);
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
                        Icons.stars_rounded,
                        color: widget.themeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.feature == null
                          ? "Add Key Feature"
                          : "Edit Key Feature",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Feature title field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Feature Title",
                    hintText: "e.g., Real-time Sync",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: "Enter a concise title for this feature",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectFeaturesValidator.validateTitle,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Feature description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Feature Description",
                    hintText:
                        "Explain what this feature does and why it's valuable",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    helperText: "Provide a detailed explanation of the feature",
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
                  validator: ProjectFeaturesValidator.validateDescription,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 24),

                // Icon selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose an Icon",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Select an icon that represents this feature",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: _commonIcons.length,
                        itemBuilder: (context, index) {
                          final iconName = _commonIcons[index];
                          final isSelected = iconName == _selectedIconName;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedIconName = iconName;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? widget.themeColor
                                    : widget.themeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? widget.themeColor
                                      : Colors.transparent,
                                  width: isSelected ? 2 : 0,
                                ),
                              ),
                              child: Icon(
                                IconData(
                                  int.parse(iconName),
                                  fontFamily: 'MaterialIcons',
                                ),
                                color: isSelected
                                    ? Colors.white
                                    : widget.themeColor,
                                size: 24,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        "Selected: ${ProjectFeaturesValidator.getIconName(_selectedIconName)}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
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
                        widget.feature == null ? "Add Feature" : "Save Changes",
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
