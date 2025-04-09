// lib/features/upsert_project/widgets/upsert_project_enhancements_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/future_enhancement_model.dart';
import 'package:mb/features/upsert_project/validators/project_enhancements_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

class ProjectEnhancementsSection extends StatefulWidget {
  final List<FutureEnhancement> initialEnhancements;
  final Color themeColor;
  final Function(List<FutureEnhancement>) onEnhancementsChanged;

  const ProjectEnhancementsSection({
    Key? key,
    required this.initialEnhancements,
    required this.themeColor,
    required this.onEnhancementsChanged,
  }) : super(key: key);

  @override
  State<ProjectEnhancementsSection> createState() =>
      _ProjectEnhancementsSectionState();
}

class _ProjectEnhancementsSectionState
    extends State<ProjectEnhancementsSection> {
  late List<FutureEnhancement> _enhancements;

  @override
  void initState() {
    super.initState();
    _enhancements = List.from(widget.initialEnhancements);
  }

  void _openAddEnhancementDialog() async {
    final FutureEnhancement? newEnhancement =
        await showDialog<FutureEnhancement>(
      context: context,
      builder: (context) => EnhancementFormDialog(
        themeColor: widget.themeColor,
      ),
    );

    if (newEnhancement != null) {
      setState(() {
        _enhancements.add(newEnhancement);
      });
      widget.onEnhancementsChanged(_enhancements);
    }
  }

  void _openEditEnhancementDialog(int index) async {
    final FutureEnhancement? updatedEnhancement =
        await showDialog<FutureEnhancement>(
      context: context,
      builder: (context) => EnhancementFormDialog(
        themeColor: widget.themeColor,
        enhancement: _enhancements[index],
      ),
    );

    if (updatedEnhancement != null) {
      setState(() {
        _enhancements[index] = updatedEnhancement;
      });
      widget.onEnhancementsChanged(_enhancements);
    }
  }

  void _removeEnhancement(int index) {
    setState(() {
      _enhancements.removeAt(index);
    });
    widget.onEnhancementsChanged(_enhancements);
  }

  Color _getStatusColor(String status) {
    return ProjectEnhancementsValidator.getStatusColor(status);
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleSectionHeader(
      icon: Icons.update_outlined,
      title: "Future Enhancements",
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
              "Add planned improvements and future features for your project.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

          // Add Enhancement button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openAddEnhancementDialog,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text("Add Future Enhancement"),
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

          // Display enhancements
          if (_enhancements.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _enhancements.length,
              itemBuilder: (context, index) {
                final enhancement = _enhancements[index];
                final statusColor = _getStatusColor(enhancement.status);

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
                          Icons.lightbulb_outline,
                          color: widget.themeColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        enhancement.title,
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
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              enhancement.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: statusColor,
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
                            Text(
                              enhancement.description,
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
                                  onPressed: () =>
                                      _openEditEnhancementDialog(index),
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
                                  onPressed: () => _removeEnhancement(index),
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
                    Icons.update_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No future enhancements added yet",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Share your roadmap and planned features",
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
}

// Dialog for adding/editing future enhancements
class EnhancementFormDialog extends StatefulWidget {
  final Color themeColor;
  final FutureEnhancement? enhancement;

  const EnhancementFormDialog({
    Key? key,
    required this.themeColor,
    this.enhancement,
  }) : super(key: key);

  @override
  State<EnhancementFormDialog> createState() => _EnhancementFormDialogState();
}

class _EnhancementFormDialogState extends State<EnhancementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedStatus = 'Planned';

  // Status options
  final List<String> _statusOptions = [
    'Planned',
    'In Progress',
    'Completed',
    'On Hold'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.enhancement != null) {
      _titleController.text = widget.enhancement!.title;
      _descriptionController.text = widget.enhancement!.description;
      _selectedStatus = widget.enhancement!.status;
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
      final enhancement = FutureEnhancement(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _selectedStatus,
      );
      Navigator.of(context).pop(enhancement);
    }
  }

  Color _getStatusColor(String status) {
    return ProjectEnhancementsValidator.getStatusColor(status);
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
                        Icons.update_rounded,
                        color: widget.themeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.enhancement == null
                          ? "Add Future Enhancement"
                          : "Edit Future Enhancement",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Enhancement title field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Enhancement Title",
                    hintText: "e.g., Mobile App Version",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: "Enter a concise title for this enhancement",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectEnhancementsValidator.validateTitle,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Enhancement description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Enhancement Description",
                    hintText: "Describe what will be improved or added",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    helperText:
                        "Explain what this enhancement will add to your project",
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
                  validator: ProjectEnhancementsValidator.validateDescription,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Status dropdown
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          ..._statusOptions.map((status) {
                            final isSelected = status == _selectedStatus;
                            final statusColor = _getStatusColor(status);
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedStatus = status;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? statusColor.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _getStatusIcon(status),
                                        color: statusColor,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      status,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? statusColor
                                            : Colors.black87,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_circle,
                                        color: statusColor,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
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
                        widget.enhancement == null
                            ? "Add Enhancement"
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return Icons.schedule;
      case 'in progress':
        return Icons.engineering;
      case 'completed':
        return Icons.check_circle_outline;
      case 'on hold':
        return Icons.pause_circle_outline;
      default:
        return Icons.info_outline;
    }
  }
}
