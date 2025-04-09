// lib/features/upsert_project/widgets/upsert_project_info_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/upsert_project/validators/project_info_validator.dart';
import 'package:intl/intl.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

class ProjectInfoSection extends StatefulWidget {
  final TextEditingController roleController;
  final DateTime? releaseDate;
  final int developmentDays;
  final Color themeColor;
  final Function(DateTime?) onReleaseDateChanged;
  final Function(int) onDevelopmentDaysChanged;

  const ProjectInfoSection({
    Key? key,
    required this.roleController,
    required this.releaseDate,
    required this.developmentDays,
    required this.themeColor,
    required this.onReleaseDateChanged,
    required this.onDevelopmentDaysChanged,
  }) : super(key: key);

  @override
  State<ProjectInfoSection> createState() => _ProjectInfoSectionState();
}

class _ProjectInfoSectionState extends State<ProjectInfoSection> {
  late TextEditingController _daysController;
  final _formKey = GlobalKey<FormState>();
  String? _releaseDateError;

  @override
  void initState() {
    super.initState();
    _daysController = TextEditingController(
        text: widget.developmentDays > 0
            ? widget.developmentDays.toString()
            : '');

    // Initial date validation
    _releaseDateError =
        ProjectInfoValidator.validateReleaseDate(widget.releaseDate);
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.releaseDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.themeColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final error = ProjectInfoValidator.validateReleaseDate(picked);

      setState(() {
        _releaseDateError = error;
      });

      if (error == null) {
        widget.onReleaseDateChanged(picked);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String? _formatReleaseDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleSectionHeader(
      icon: Icons.info_outline,
      title: "Project Info",
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
              "Additional information about your project and your role in it.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role field
                TextFormField(
                  controller: widget.roleController,
                  decoration: InputDecoration(
                    labelText: "Your Role",
                    hintText: "Lead Developer, Designer, etc.",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    helperText: "Optional, your position in this project",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectInfoValidator.validateRole,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Release date picker
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _releaseDateError != null
                            ? Colors.red.shade300
                            : widget.themeColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.calendar_today,
                            color: widget.themeColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Release Date",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            if (_formatReleaseDate(widget.releaseDate) != null)
                              const SizedBox(height: 4),
                            if (_formatReleaseDate(widget.releaseDate) != null)
                              Text(
                                _formatReleaseDate(widget.releaseDate)!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: widget.releaseDate != null
                                      ? Colors.black87
                                      : Colors.grey.shade500,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade400,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    "Optional, when was this project released to the public?",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),

                if (_releaseDateError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Text(
                      _releaseDateError!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
                // Development time
                TextFormField(
                  controller: _daysController,
                  decoration: InputDecoration(
                    labelText: "Development Time (in days)",
                    hintText: "e.g., 30, 90, 365",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.timer_outlined),
                    helperText: widget.developmentDays > 0
                        ? "Optional, approximately: ${ProjectInfoValidator.formatDevelopmentTime(widget.developmentDays)}"
                        : "Optional, enter the number of days spent developing",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: ProjectInfoValidator.validateDevelopmentDays,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value) {
                    final days = int.tryParse(value) ?? 0;
                    widget.onDevelopmentDaysChanged(days);
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                    // Force rebuild to update helper text
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
