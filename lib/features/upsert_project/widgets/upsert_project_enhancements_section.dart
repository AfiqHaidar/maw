// lib/features/upsert_project/widgets/upsert_project_enhancements_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/future_enhancement_model.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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
    switch (status.toLowerCase()) {
      case 'planned':
        return Colors.blue;
      case 'in progress':
        return Colors.amber;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.update_rounded,
          title: "Future Enhancements",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

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
                  color: Colors.white,
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: statusColor,
                    ),
                  ),
                  title: Text(
                    enhancement.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        enhancement.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          enhancement.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'edit') {
                        _openEditEnhancementDialog(index);
                      } else if (value == 'delete') {
                        _removeEnhancement(index);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
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
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
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
        title: _titleController.text,
        description: _descriptionController.text,
        status: _selectedStatus,
      );
      Navigator.of(context).pop(enhancement);
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
                      Icons.update_rounded,
                      color: widget.themeColor,
                      size: 24,
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
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
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe the enhancement';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Status dropdown
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a status';
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
}
