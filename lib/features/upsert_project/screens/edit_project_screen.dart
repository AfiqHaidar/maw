// lib/features/upsert_project/screens/edit_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/project/screens/project_screen.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_form.dart';

class EditProjectScreen extends ConsumerWidget {
  final ProjectEntity project;

  const EditProjectScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Project",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: project.bannerBgColor,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ProjectForm(
        project: project,
        selectedColor: project.bannerBgColor,
        submitButtonText: "Update Project",
        onSave: (formData) => _updateProject(context, ref, formData),
      ),
    );
  }

  void _updateProject(
      BuildContext context, WidgetRef ref, ProjectEntity updatedProject) async {
    try {
      await ref.read(projectProvider.notifier).upsertProject(updatedProject);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project "${project.name}" updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectScreen(project: updatedProject),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add project: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
