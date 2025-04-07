// lib/features/upsert_project/widgets/chip_list.dart
import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  final List<String> items;
  final Color chipColor;
  final Color textColor;
  final Color? borderColor;
  final bool showHashtag;
  final Function(int) onDelete;

  const ChipList({
    Key? key,
    required this.items,
    required this.chipColor,
    required this.textColor,
    this.borderColor,
    this.showHashtag = false,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.asMap().entries.map(
        (entry) {
          final index = entry.key;
          final item = entry.value;

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: chipColor,
              borderRadius: BorderRadius.circular(16),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  showHashtag ? "#$item" : item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => onDelete(index),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: textColor,
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
