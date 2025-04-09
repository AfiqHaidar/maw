// lib/features/upsert_project/widgets/upsert_project_stats_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_stats_model.dart';

import 'package:mb/features/upsert_project/validators/project_stats_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

class ProjectStatsSection extends StatefulWidget {
  final ProjectStats? initialStats;
  final Color themeColor;
  final Function(ProjectStats) onStatsChanged;

  const ProjectStatsSection({
    Key? key,
    this.initialStats,
    required this.themeColor,
    required this.onStatsChanged,
  }) : super(key: key);

  @override
  State<ProjectStatsSection> createState() => _ProjectStatsSectionState();
}

class _ProjectStatsSectionState extends State<ProjectStatsSection> {
  final TextEditingController _usersController = TextEditingController();
  final TextEditingController _starsController = TextEditingController();
  final TextEditingController _forksController = TextEditingController();
  final TextEditingController _downloadsController = TextEditingController();
  final TextEditingController _contributionsController =
      TextEditingController();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    _usersController.dispose();
    _starsController.dispose();
    _forksController.dispose();
    _downloadsController.dispose();
    _contributionsController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    _hasInitialized = true;

    if (widget.initialStats != null) {
      // Only set non-zero values
      if (widget.initialStats!.users > 0) {
        _usersController.text = widget.initialStats!.users.toString();
      }
      if (widget.initialStats!.stars > 0) {
        _starsController.text = widget.initialStats!.stars.toString();
      }
      if (widget.initialStats!.forks > 0) {
        _forksController.text = widget.initialStats!.forks.toString();
      }
      if (widget.initialStats!.downloads > 0) {
        _downloadsController.text = widget.initialStats!.downloads.toString();
      }
      if (widget.initialStats!.contributions > 0) {
        _contributionsController.text =
            widget.initialStats!.contributions.toString();
      }
    }

    // Add listeners to all controllers
    _usersController.addListener(_updateStats);
    _starsController.addListener(_updateStats);
    _forksController.addListener(_updateStats);
    _downloadsController.addListener(_updateStats);
    _contributionsController.addListener(_updateStats);
  }

  void _updateStats() {
    if (!_hasInitialized) return;

    final stats = ProjectStats(
      users: int.tryParse(_usersController.text) ?? 0,
      stars: int.tryParse(_starsController.text) ?? 0,
      forks: int.tryParse(_forksController.text) ?? 0,
      downloads: int.tryParse(_downloadsController.text) ?? 0,
      contributions: int.tryParse(_contributionsController.text) ?? 0,
    );
    widget.onStatsChanged(stats);
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleSectionHeader(
      icon: Icons.analytics_outlined,
      title: "Project Statistics",
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
              "Add statistics about your project to showcase its impact and popularity.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

          // Stat Items
          _buildStatItem(
            label: "Users",
            icon: Icons.people_outline,
            controller: _usersController,
            hint: "Number of users",
            validator: ProjectStatsValidator.validateUsers,
          ),

          _buildStatItem(
            label: "Stars",
            icon: Icons.star_outline,
            controller: _starsController,
            hint: "GitHub stars",
            validator: ProjectStatsValidator.validateStars,
          ),

          _buildStatItem(
            label: "Forks",
            icon: Icons.call_split_outlined,
            controller: _forksController,
            hint: "GitHub forks/clones",
            validator: ProjectStatsValidator.validateForks,
          ),

          _buildStatItem(
            label: "Downloads",
            icon: Icons.download_outlined,
            controller: _downloadsController,
            hint: "Download count",
            validator: ProjectStatsValidator.validateDownloads,
          ),

          _buildStatItem(
            label: "Contributions",
            icon: Icons.groups_outlined,
            controller: _contributionsController,
            hint: "Number of contributors",
            validator: ProjectStatsValidator.validateContributions,
          ),

          // Tip text
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 16.0),
            child: Text(
              "Tip: You can use shortcuts like 1K for 1,000 or 1.5M for 1,500,000",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text, // Allow formatted input like "1K"
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          prefixIcon: Icon(icon, color: widget.themeColor),
          errorStyle: TextStyle(
            color: Colors.red.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // Process formatted numbers on submit
        onChanged: (value) {
          // Handle formatted input (like 1K, 2.5M) when the user types
          if (value.isNotEmpty &&
              (value.toUpperCase().contains('K') ||
                  value.toUpperCase().contains('M') ||
                  value.toUpperCase().contains('B'))) {
            final parsedValue =
                ProjectStatsValidator.parseFormattedNumber(value);
            if (parsedValue != null) {
              // Only update if we could parse it successfully
              controller.text = parsedValue.toString();
              // Move cursor to the end
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          }
        },
      ),
    );
  }
}
