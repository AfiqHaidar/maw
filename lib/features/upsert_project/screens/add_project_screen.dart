// lib/features/upsert_project/screens/add_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_form.dart';
import 'package:mb/features/portofolio/screens/portofolio_screen.dart';

class AddProjectScreen extends ConsumerWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Project",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: ProjectForm(
        selectedColor: Colors.blue,
        submitButtonText: "Save Project",
        onSave: (formData) => _saveProject(context, ref, formData),
      ),
    );
  }

  void _saveProject(
      BuildContext context, WidgetRef ref, ProjectEntity project) async {
    try {
      await ref.read(projectProvider.notifier).upsertProject(project);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Project "${project.name}" added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => PortofolioScreen()),
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
