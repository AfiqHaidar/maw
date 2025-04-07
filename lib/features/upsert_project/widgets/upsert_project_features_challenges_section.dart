// lib/features/upsert_project/widgets/upsert_project_challenges_section.dart
import 'package:flutter/material.dart';
import 'package:mb/data/models/challenge_model.dart';
import 'package:mb/features/project/widgets/project_section_header.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSectionHeader(
          icon: Icons.warning_amber_rounded,
          title: "Challenges & Solutions",
          themeColor: widget.themeColor,
        ),
        const SizedBox(height: 16),

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
                child: ExpansionTile(
                  leading: Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.amber.shade600,
                  ),
                  title: Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    challenge.description.length > 60
                        ? '${challenge.description.substring(0, 60)}...'
                        : challenge.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(
                                Icons.edit,
                                color: widget.themeColor,
                              ),
                              title: const Text("Edit"),
                              onTap: () {
                                Navigator.pop(context);
                                _openEditChallengeDialog(index);
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              title: const Text("Delete"),
                              onTap: () {
                                Navigator.pop(context);
                                _removeChallenge(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Challenge:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            challenge.description,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (challenge.solution != null &&
                              challenge.solution!.isNotEmpty) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_outline,
                                  size: 18,
                                  color: widget.themeColor,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Solution:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              challenge.solution!,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
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
        title: _titleController.text,
        description: _descriptionController.text,
        solution:
            _solutionController.text.isEmpty ? null : _solutionController.text,
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
                    Icon(
                      Icons.warning_amber_rounded,
                      color: widget.themeColor,
                      size: 24,
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
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
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
                  ),
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe the challenge';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Solution field (optional)
                TextFormField(
                  controller: _solutionController,
                  decoration: InputDecoration(
                    labelText: "Solution (Optional)",
                    hintText: "How did you overcome this challenge?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                  minLines: 3,
                  maxLines: 5,
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
