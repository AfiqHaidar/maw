// lib/features/home/widgets/user_search_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mb/data/providers/connection_provider.dart';

class UserSearchBar extends ConsumerWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onToggleSearch;
  final VoidCallback onInboxPressed;
  final Color? themeColor;

  const UserSearchBar({
    Key? key,
    required this.controller,
    required this.isSearching,
    required this.onToggleSearch,
    required this.onInboxPressed,
    this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final incomingRequestsAsync = ref.watch(incomingConnectionRequestsProvider);

    final pendingCount = incomingRequestsAsync.maybeWhen(
      data: (requests) => requests.length,
      orElse: () => 0,
    );

    print('Pending requests count: $pendingCount');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: InkWell(
        onTap: onToggleSearch,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withAlpha(50),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.search_rounded,
                          color: theme.primary,
                          size: 22,
                        ),
                        onPressed: onToggleSearch,
                        padding: EdgeInsets.zero,
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.inbox_rounded,
                                    color: theme.primary,
                                    size: 25,
                                  ),
                                  onPressed: onInboxPressed,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ),

                              // Notification badge (only show if there are pending requests)
                              if (pendingCount > 0)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      pendingCount > 9
                                          ? '9+'
                                          : pendingCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
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
