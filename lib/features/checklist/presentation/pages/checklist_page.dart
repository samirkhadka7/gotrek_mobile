import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../bloc/checklist_bloc.dart';
import '../bloc/checklist_event.dart';
import '../bloc/checklist_state.dart';
import 'checklist_config_page.dart';
import 'checklist_preview_page.dart';
import 'checklist_view_page.dart';

/// Main checklist page that orchestrates the checklist flow
class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  void initState() {
    super.initState();
    // Load existing checklist on page load
    context.read<ChecklistBloc>().add(const LoadChecklistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Packing Checklist',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        actions: [
          BlocBuilder<ChecklistBloc, ChecklistState>(
            builder: (context, state) {
              if (state is ChecklistLoaded) {
                return IconButton(
                  onPressed: () {
                    _showInfoDialog(context);
                  },
                  icon: const Icon(Icons.info_outline),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ChecklistBloc, ChecklistState>(
        builder: (context, state) {
          if (state is ChecklistInitial || state is ChecklistLoading) {
            return _buildLoadingView(state is ChecklistLoading
                ? (state).message ?? 'Loading...'
                : 'Loading...');
          }

          if (state is ChecklistConfiguring || state is ChecklistEmpty) {
            return ChecklistConfigPage(
              onGenerated: () {
                // Will be handled by BlocListener in config page
              },
            );
          }

          if (state is ChecklistGenerated) {
            return ChecklistPreviewPage(
              generatedChecklist: state.generatedChecklist,
              config: state.config,
              onBack: () {
                context.read<ChecklistBloc>().add(const UpdateConfigEvent());
              },
              onAccepted: () {
                // Will be handled by BlocListener in preview page
              },
            );
          }

          if (state is ChecklistLoaded) {
            return ChecklistViewPage(
              checklist: state.checklist,
              onNewChecklist: () {
                // Already handled by BlocListener in view page
              },
            );
          }

          if (state is ChecklistError) {
            return _buildErrorView(state.message, state.lastConfig != null);
          }

          if (state is ChecklistSaving) {
            return _buildLoadingView('Saving your checklist...');
          }

          if (state is ChecklistCleared) {
            // Return to config
            return ChecklistConfigPage(
              onGenerated: () {},
            );
          }

          return _buildLoadingView('Loading...');
        },
      ),
    );
  }

  Widget _buildLoadingView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(String message, bool canRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (canRetry)
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<ChecklistBloc>().add(const UpdateConfigEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ChecklistBloc>().add(const LoadChecklistEvent());
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.info_outline,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Tips'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTip('✓', 'Tap an item to mark it as packed'),
            const SizedBox(height: 12),
            _buildTip('↺', 'Use Reset to uncheck all items'),
            const SizedBox(height: 12),
            _buildTip('☁️', 'Sync to Cloud saves your progress'),
            const SizedBox(height: 12),
            _buildTip('➕', 'Create a new checklist anytime'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}
