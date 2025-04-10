// lib/features/upsert_project/widgets/upsert_project_challenges_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/challenge_model.dart';
import 'package:mb/features/upsert_project/validators/project_challenges_validator.dart';
import 'package:mb/features/upsert_project/widgets/collapsible_section_header.dart';

class ProjectChallengesSection extends StatefulWidget {
  final List<Challenge> initialChallenges;
  final Color themeColor;
  final Function(List<Challenge>) onChallengesChanged;

  const ProjectChallengesSection({
    Key? key,
    required this.initialChallenges,
    required this.themeColor,
    required this.onChallengesChanged,
  }) : super(key: key);

  @override
  State<ProjectChallengesSection> createState() =>
      _ProjectChallengesSectionState();
}

class _ProjectChallengesSectionState extends State<ProjectChallengesSection> {
  late List<Challenge> _challenges;

  @override
  void initState() {
    super.initState();
    _challenges = List.from(widget.initialChallenges);
  }

  void _openAddChallengeDialog() async {
    final Challenge? newChallenge = await showDialog<Challenge>(
      context: context,
      builder: (context) => ChallengeFormDialog(
        themeColor: widget.themeColor,
      ),
    );

    if (newChallenge != null) {
      setState(() {
        _challenges.add(newChallenge);
      });
      widget.onChallengesChanged(_challenges);
    }
  }

  void _openEditChallengeDialog(int index) async {
    final Challenge? updatedChallenge = await showDialog<Challenge>(
      context: context,
      builder: (context) => ChallengeFormDialog(
        themeColor: widget.themeColor,
        challenge: _challenges[index],
      ),
    );

    if (updatedChallenge != null) {
      setState(() {
        _challenges[index] = updatedChallenge;
      });
      widget.onChallengesChanged(_challenges);
    }
  }

  void _removeChallenge(int index) {
    setState(() {
      _challenges.removeAt(index);
    });
    widget.onChallengesChanged(_challenges);
  }

  @override
  Widget build(BuildContext context) {
    return CollapsibleSectionHeader(
      icon: Icons.warning_amber_outlined,
      title: "Challenges & Solutions",
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
              "Share the obstacles you encountered and how you solved them.",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
          ),

          // Add Challenge button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openAddChallengeDialog,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: const Text("Add Challenge"),
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

          // Display challenges
          if (_challenges.isNotEmpty) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                final challenge = _challenges[index];
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
                          Icons.warning_amber_outlined,
                          color: widget.themeColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        challenge.title,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Challenge:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: widget.themeColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  challenge.description,
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            if (challenge.solution != null &&
                                challenge.solution!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        size: 18,
                                        color: widget.themeColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Solution:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: widget.themeColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    challenge.solution!,
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Edit button
                                OutlinedButton.icon(
                                  onPressed: () =>
                                      _openEditChallengeDialog(index),
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
                                  onPressed: () => _removeChallenge(index),
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
                    Icons.warning_amber_rounded,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No challenges added yet",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Share the obstacles you overcame in this project",
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

// Dialog for adding/editing challenges
class ChallengeFormDialog extends StatefulWidget {
  final Color themeColor;
  final Challenge? challenge;

  const ChallengeFormDialog({
    Key? key,
    required this.themeColor,
    this.challenge,
  }) : super(key: key);

  @override
  State<ChallengeFormDialog> createState() => _ChallengeFormDialogState();
}

class _ChallengeFormDialogState extends State<ChallengeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _solutionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.challenge != null) {
      _titleController.text = widget.challenge!.title;
      _descriptionController.text = widget.challenge!.description;
      _solutionController.text = widget.challenge!.solution ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final challenge = Challenge(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        solution: _solutionController.text.isEmpty
            ? null
            : _solutionController.text.trim(),
      );
      Navigator.of(context).pop(challenge);
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
                        Icons.warning_amber_rounded,
                        color: widget.themeColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.challenge == null
                          ? "Add Challenge"
                          : "Edit Challenge",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Challenge title field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Challenge Title",
                    hintText: "e.g., Performance Optimization",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    helperText: "Enter a concise title for this challenge",
                    helperStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: ProjectChallengesValidator.validateTitle,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Challenge description field
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Challenge Description",
                    hintText: "Describe the challenge you faced",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    helperText:
                        "Explain the difficulty or obstacle encountered",
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
                  validator: ProjectChallengesValidator.validateDescription,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

                const SizedBox(height: 16),

                // Solution field (optional)
                TextFormField(
                  controller: _solutionController,
                  decoration: InputDecoration(
                    labelText: "Solution",
                    hintText: "How did you overcome this challenge?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                    helperText: "Optional, describe how you solved the problem",
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
                  validator: ProjectChallengesValidator.validateSolution,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        widget.challenge == null
                            ? "Add Challenge"
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
