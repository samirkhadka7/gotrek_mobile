import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/checklist_entity.dart';
import '../bloc/checklist_bloc.dart';
import '../bloc/checklist_event.dart';
import '../bloc/checklist_state.dart';
import '../widgets/checklist_item_tile.dart';

/// Page for viewing and managing the saved checklist
class ChecklistViewPage extends StatefulWidget {
  final UserChecklist checklist;
  final VoidCallback? onNewChecklist;

  const ChecklistViewPage({
    super.key,
    required this.checklist,
    this.onNewChecklist,
  });

  @override
  State<ChecklistViewPage> createState() => _ChecklistViewPageState();
}

class _ChecklistViewPageState extends State<ChecklistViewPage> {
  final Map<String, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    // Expand all categories by default
    for (final category in widget.checklist.groupedItems.keys) {
      _expandedCategories[category] = true;
    }
  }

  void _toggleCategory(String category) {
    setState(() {
      _expandedCategories[category] = !(_expandedCategories[category] ?? true);
    });
  }

  void _toggleItem(String itemId) {
    context.read<ChecklistBloc>().add(ToggleItemLocallyEvent(itemId: itemId));
  }

  void _saveChecklist() {
    final state = context.read<ChecklistBloc>().state;
    if (state is ChecklistLoaded) {
      context.read<ChecklistBloc>().add(SaveChecklistEvent(
            items: state.checklist.items,
            config: state.checklist.config,
          ));
    }
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Checklist?'),
        content: const Text(
          'This will uncheck all items. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset all items
              final state = context.read<ChecklistBloc>().state;
              if (state is ChecklistLoaded) {
                final resetItems = state.checklist.items
                    .map((item) => item.copyWith(isChecked: false))
                    .toList();
                context.read<ChecklistBloc>().add(SaveChecklistEvent(
                      items: resetItems,
                      config: state.checklist.config,
                    ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showNewChecklistConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create New Checklist?'),
        content: const Text(
          'This will replace your current checklist. Are you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChecklistBloc>().add(const ClearChecklistEvent());
              widget.onNewChecklist?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistBloc, ChecklistState>(
      builder: (context, state) {
        UserChecklist checklist = widget.checklist;
        if (state is ChecklistLoaded) {
          checklist = state.checklist;
        }

        final groupedItems = checklist.groupedItems;
        final categories = groupedItems.keys.toList();

        return Column(
          children: [
            // Progress Card
            ChecklistProgressCard(
              totalItems: checklist.items.length,
              checkedItems: checklist.checkedCount,
              onResetPressed: _showResetConfirmation,
              onSavePressed: _saveChecklist,
            ),
            // Categories list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final items = groupedItems[category]!;
                  final checkedCount =
                      items.where((item) => item.isChecked).length;
                  final isExpanded = _expandedCategories[category] ?? true;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Category header
                        ChecklistCategoryHeader(
                          category: category,
                          itemCount: items.length,
                          checkedCount: checkedCount,
                          isExpanded: isExpanded,
                          onToggle: () => _toggleCategory(category),
                        ),
                        // Items
                        AnimatedCrossFade(
                          firstChild: Column(
                            children: items.asMap().entries.map((entry) {
                              final item = entry.value;
                              final isLast = entry.key == items.length - 1;

                              return ChecklistItemTile(
                                item: item,
                                onChanged: (_) => _toggleItem(item.id),
                                showDivider: !isLast,
                              );
                            }).toList(),
                          ),
                          secondChild: const SizedBox.shrink(),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom action bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _showNewChecklistConfirmation,
                        icon: const Icon(Icons.add),
                        label: const Text('New Checklist'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocBuilder<ChecklistBloc, ChecklistState>(
                        builder: (context, state) {
                          final isLoading = state is ChecklistSaving;

                          return ElevatedButton.icon(
                            onPressed: isLoading ? null : _saveChecklist,
                            icon: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.cloud_upload_outlined),
                            label:
                                Text(isLoading ? 'Saving...' : 'Sync to Cloud'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
