// lib/features/upsert_project/widgets/upsert_project_stats_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/project_stats_model.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Add listeners to all controllers
    _usersController.addListener(_updateStats);
    _starsController.addListener(_updateStats);
    _forksController.addListener(_updateStats);
    _downloadsController.addListener(_updateStats);
    _contributionsController.addListener(_updateStats);
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
    if (widget.initialStats != null) {
      _usersController.text = widget.initialStats!.users.toString();
      _starsController.text = widget.initialStats!.stars.toString();
      _forksController.text = widget.initialStats!.forks.toString();
      _downloadsController.text = widget.initialStats!.downloads.toString();
      _contributionsController.text =
          widget.initialStats!.contributions.toString();

      // If any stat is greater than 0, expand the section by default
      if (widget.initialStats!.users > 0 ||
          widget.initialStats!.stars > 0 ||
          widget.initialStats!.forks > 0 ||
          widget.initialStats!.downloads > 0 ||
          widget.initialStats!.contributions > 0) {
        _isExpanded = true;
      }
    } else {
      _usersController.text = '0';
      _starsController.text = '0';
      _forksController.text = '0';
      _downloadsController.text = '0';
      _contributionsController.text = '0';
    }
  }

  void _updateStats() {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with expand/collapse button
        Row(
          children: [
            Expanded(
              child: ProjectSectionHeader(
                icon: Icons.analytics_outlined,
                title: "Project Statistics",
                themeColor: widget.themeColor,
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: widget.themeColor,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ],
        ),

        if (_isExpanded) ...[
          const SizedBox(height: 16),

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

          // Grid of stat inputs
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Users stat
              _buildStatInput(
                controller: _usersController,
                label: "Users",
                icon: Icons.people_outline,
                iconColor: Colors.blue,
              ),

              // Stars stat
              _buildStatInput(
                controller: _starsController,
                label: "Stars",
                icon: Icons.star_outline,
                iconColor: Colors.amber,
              ),

              // Forks stat
              _buildStatInput(
                controller: _forksController,
                label: "Forks",
                icon: Icons.call_split_outlined,
                iconColor: Colors.purple,
              ),

              // Downloads stat
              _buildStatInput(
                controller: _downloadsController,
                label: "Downloads",
                icon: Icons.download_outlined,
                iconColor: Colors.green,
              ),

              // Contributions stat
              _buildStatInput(
                controller: _contributionsController,
                label: "Contributions",
                icon: Icons.groups_outlined,
                iconColor: Colors.deepOrange,
              ),
            ],
          ),
        ] else ...[
          // Collapsed view - show summary of stats
          if (_hasStats())
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (int.parse(_usersController.text) > 0)
                    _buildStatChip(
                      label: "Users",
                      value: _usersController.text,
                      icon: Icons.people_outline,
                      iconColor: Colors.blue,
                    ),
                  if (int.parse(_starsController.text) > 0)
                    _buildStatChip(
                      label: "Stars",
                      value: _starsController.text,
                      icon: Icons.star_outline,
                      iconColor: Colors.amber,
                    ),
                  if (int.parse(_forksController.text) > 0)
                    _buildStatChip(
                      label: "Forks",
                      value: _forksController.text,
                      icon: Icons.call_split_outlined,
                      iconColor: Colors.purple,
                    ),
                  if (int.parse(_downloadsController.text) > 0)
                    _buildStatChip(
                      label: "Downloads",
                      value: _downloadsController.text,
                      icon: Icons.download_outlined,
                      iconColor: Colors.green,
                    ),
                  if (int.parse(_contributionsController.text) > 0)
                    _buildStatChip(
                      label: "Contributions",
                      value: _contributionsController.text,
                      icon: Icons.groups_outlined,
                      iconColor: Colors.deepOrange,
                    ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "No statistics added yet. Tap to add project stats.",
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildStatInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            "$label: $value",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  bool _hasStats() {
    return int.parse(_usersController.text) > 0 ||
        int.parse(_starsController.text) > 0 ||
        int.parse(_forksController.text) > 0 ||
        int.parse(_downloadsController.text) > 0 ||
        int.parse(_contributionsController.text) > 0;
  }
}
