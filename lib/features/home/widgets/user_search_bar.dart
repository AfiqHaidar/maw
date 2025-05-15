// lib/features/home/widgets/user_search_bar.dart
import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final Color? themeColor;

  const UserSearchBar({
    Key? key,
    required this.controller,
    required this.isSearching,
    required this.onToggleSearch,
    this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: InkWell(
        onTap: onToggleSearch,
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: theme.primaryContainer.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (isSearching) ...[
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: theme.onPrimaryContainer),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      isDense: true,
                    ),
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: theme.onPrimaryContainer,
                    size: 20,
                  ),
                  onPressed: onToggleSearch,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
              ] else ...[
                Expanded(
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: theme.onPrimaryContainer,
                        size: 22,
                      ),
                      onPressed: onToggleSearch,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
