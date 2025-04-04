import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mb/core/theme/colors.dart';
import 'profile_picture_selector_dialog.dart';

class ProfilePicturePicker extends StatefulWidget {
  final void Function(String selectedAsset) onChanged;

  const ProfilePicturePicker({super.key, required this.onChanged});

  @override
  State<ProfilePicturePicker> createState() => _ProfilePicturePickerState();
}

class _ProfilePicturePickerState extends State<ProfilePicturePicker> {
  String _selectedAsset = 'assets/animations/blue_stare.json';

  void _openSelector() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => const ProfilePictureSelectorDialog(),
      backgroundColor: Colors.transparent,
    );

    if (selected != null && selected != _selectedAsset) {
      setState(() {
        _selectedAsset = selected;
      });
      widget.onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          child: ClipOval(
            child: Lottie.asset(
              _selectedAsset,
              fit: BoxFit.cover,
              repeat: true,
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: _openSelector,
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.6),
              radius: 16,
              child: Icon(Icons.change_circle,
                  size: 16, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
