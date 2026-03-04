import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/checklist_entity.dart';

/// Tile widget for displaying a checklist item
class ChecklistItemTile extends StatelessWidget {
  final ChecklistItem item;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onChanged(!item.isChecked),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Animated checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: item.isChecked
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: item.isChecked
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: item.isChecked
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                // Item name
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 15,
                      color: item.isChecked
                          ? Colors.grey.shade400
                          : Colors.grey.shade800,
                      decoration:
                          item.isChecked ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.grey.shade400,
                    ),
                    child: Text(item.name),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 56,
            color: Colors.grey.shade100,
          ),
      ],
    );
  }
}

/// Category header for grouping checklist items
class ChecklistCategoryHeader extends StatelessWidget {
  final String category;
  final int itemCount;
  final int checkedCount;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const ChecklistCategoryHeader({
    super.key,
    required this.category,
    required this.itemCount,
    required this.checkedCount,
    this.isExpanded = true,
    this.onToggle,
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
    final progress = itemCount > 0 ? checkedCount / itemCount : 0.0;

    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Text(
              _categoryIcon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 1.0
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$checkedCount/$itemCount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (onToggle != null) ...[
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Progress summary card
class ChecklistProgressCard extends StatelessWidget {
  final int totalItems;
  final int checkedItems;
  final VoidCallback? onResetPressed;
  final VoidCallback? onSavePressed;

  const ChecklistProgressCard({
    super.key,
    required this.totalItems,
    required this.checkedItems,
    this.onResetPressed,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalItems > 0 ? checkedItems / totalItems : 0.0;
    final percentage = (progress * 100).toInt();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        '$percentage%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Packing Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$checkedItems of $totalItems items packed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      progress == 1.0
                          ? '🎉 All packed! Ready to go!'
                          : '${totalItems - checkedItems} items remaining',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onResetPressed != null || onSavePressed != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                if (onResetPressed != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onResetPressed,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (onResetPressed != null && onSavePressed != null)
                  const SizedBox(width: 12),
                if (onSavePressed != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onSavePressed,
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
