import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/checklist_entity.dart';
import '../bloc/checklist_bloc.dart';
import '../bloc/checklist_event.dart';
import '../bloc/checklist_state.dart';

/// Page for previewing generated checklist before saving
class ChecklistPreviewPage extends StatelessWidget {
  final GeneratedChecklist generatedChecklist;
  final ChecklistConfig config;
  final VoidCallback? onBack;
  final VoidCallback? onAccepted;

  const ChecklistPreviewPage({
    super.key,
    required this.generatedChecklist,
    required this.config,
    this.onBack,
    this.onAccepted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChecklistBloc, ChecklistState>(
      listener: (context, state) {
        if (state is ChecklistLoaded) {
          onAccepted?.call();
        } else if (state is ChecklistError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Checklist Generated!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Review your personalized packing list',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Config summary
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ConfigChip(
                      icon: Icons.person,
                      label: config.experience.displayName,
                    ),
                    _ConfigChip(
                      icon: Icons.schedule,
                      label: config.duration.displayName,
                    ),
                    _ConfigChip(
                      icon: Icons.cloud,
                      label: '${config.weather.icon} ${config.weather.displayName}',
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Checklist items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: generatedChecklist.itemsByCategory.length,
              itemBuilder: (context, index) {
                final category =
                    generatedChecklist.itemsByCategory.keys.elementAt(index);
                final items = generatedChecklist.itemsByCategory[category]!;

                return _CategoryCard(
                  category: category,
                  items: items,
                );
              },
            ),
          ),
          // Action buttons
          Container(
            padding: const EdgeInsets.all(20),
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
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Regenerate'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: BlocBuilder<ChecklistBloc, ChecklistState>(
                      builder: (context, state) {
                        final isLoading = state is ChecklistLoading ||
                            state is ChecklistSaving;

                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<ChecklistBloc>().add(
                                        AcceptGeneratedChecklistEvent(
                                          generatedChecklist: generatedChecklist,
                                          config: config,
                                        ),
                                      );
                                },
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check),
                          label: Text(isLoading ? 'Saving...' : 'Use This List'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
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
      ),
    );
  }
}

class _ConfigChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ConfigChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final List<String> items;

  const _CategoryCard({
    required this.category,
    required this.items,
  });

  String get _categoryIcon {
    switch (category.toLowerCase()) {
      case 'essentials':
      case 'essential':
        return '🎒';
      case 'clothing':
      case 'clothes':
        return '👕';
      case 'footwear':
      case 'shoes':
        return '👟';
      case 'safety':
      case 'first aid':
      case 'safety gear':
        return '🏥';
      case 'navigation':
        return '🧭';
      case 'food':
      case 'food & water':
      case 'nutrition':
        return '🍎';
      case 'shelter':
      case 'camping':
        return '⛺';
      case 'electronics':
      case 'gadgets':
        return '📱';
      case 'hygiene':
      case 'toiletries':
        return '🧴';
      case 'documents':
        return '📄';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text(
                  _categoryIcon,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${items.length} items',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Items
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              indent: 56,
              color: Colors.grey.shade100,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        items[index],
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
