// lib/features/upsert_project/screens/add_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_form.dart';
import 'package:mb/widgets/tabs.dart';

class AddProjectScreen extends ConsumerStatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends ConsumerState<AddProjectScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Project',
                onPressed: () {},
              ),
            ],
          ),
          body: ProjectForm(
            selectedColor: Colors.blue,
            submitButtonText: "Save Project",
            onSave: (formData) => _saveProject(context, formData),
          ),
        ),
        // Loading overlay
        if (_isLoading)
          ModalBarrier(
            dismissible: false,
            color: Colors.black.withOpacity(0.5),
          ),
        if (_isLoading)
          Container(
            color: Colors.transparent,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                    height: 70,
                    color: AppColors.white,
                  ),
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _saveProject(BuildContext context, ProjectEntity project) async {
    setState(() {
      _isLoading = true;
    });

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
        MaterialPageRoute(builder: (ctx) => TabsWrapper()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

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
