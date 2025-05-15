// lib/features/upsert_project/screens/edit_project_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/core/theme/colors.dart';
import 'package:mb/data/entities/project_entity.dart';
import 'package:mb/data/providers/project_provider.dart';
import 'package:mb/features/project/screens/project_screen.dart';
import 'package:mb/features/upsert_project/widgets/upsert_project_form.dart';

class EditProjectScreen extends ConsumerStatefulWidget {
  final ProjectEntity project;

  const EditProjectScreen({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  ConsumerState<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends ConsumerState<EditProjectScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Edit",
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
            project: widget.project,
            selectedColor: widget.project.bannerBgColor,
            submitButtonText: "Update Project",
            onSave: (formData) => _updateProject(context, formData),
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

  void _updateProject(
      BuildContext context, ProjectEntity updatedProject) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(projectProvider.notifier).upsertProject(updatedProject);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Project "${widget.project.name}" updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectScreen(
            project: updatedProject,
            isOwner: true,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update project: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
