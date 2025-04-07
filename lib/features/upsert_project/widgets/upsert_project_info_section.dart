// lib/features/upsert_project/widgets/project_info_section.dart
import 'package:flutter/material.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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

  @override
  void initState() {
    super.initState();
    _daysController =
        TextEditingController(text: widget.developmentDays.toString());
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
    );

    if (picked != null && picked != widget.releaseDate) {
      widget.onReleaseDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.info_outline,
          title: "Project Info",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

        // Role field
        TextFormField(
          controller: widget.roleController,
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
              widget.releaseDate != null
                  ? "${widget.releaseDate!.year}/${widget.releaseDate!.month.toString().padLeft(2, '0')}"
                  : "Select date",
              style: TextStyle(
                color: widget.releaseDate != null
                    ? Colors.black
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Development time
        TextFormField(
          controller: _daysController,
          decoration: InputDecoration(
            labelText: "Development Time in Days (optional)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.timer_outlined),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            widget.onDevelopmentDaysChanged(int.tryParse(value) ?? 0);
          },
        ),
      ],
    );
  }
}
