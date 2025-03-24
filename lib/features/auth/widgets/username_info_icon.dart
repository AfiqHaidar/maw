import 'package:flutter/material.dart';

class UsernameInfoIcon extends StatelessWidget {
  const UsernameInfoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Username must be at least 4 characters and unique.',
      triggerMode: TooltipTriggerMode.tap,
      child: const Icon(
        Icons.info_outline,
        color: Colors.white70,
        size: 20,
      ),
    );
  }
}
