// lib/features/upsert_project/widgets/color_picker_dialog.dart
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPickerDialog({
    Key? key,
    required this.selectedColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.color_lens,
                    size: 20,
                    color: selectedColor,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Select Banner Color",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Color Grid
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _colorChoice(Colors.blue, context),
                _colorChoice(Colors.red, context),
                _colorChoice(Colors.green, context),
                _colorChoice(Colors.orange, context),
                _colorChoice(Colors.purple, context),
                _colorChoice(Colors.teal, context),
                _colorChoice(Colors.pink, context),
                _colorChoice(Colors.indigo, context),
                _colorChoice(Colors.amber, context),
                _colorChoice(Colors.cyan, context),
                _colorChoice(Colors.lime, context),
                _colorChoice(Colors.brown, context),
              ],
            ),

            const SizedBox(height: 20),

            // Done button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: selectedColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Done"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorChoice(Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        onColorSelected(color);
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedColor == color ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white, size: 26)
            : null,
      ),
    );
  }
}
