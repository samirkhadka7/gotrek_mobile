import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_trail_entity.dart';
import '../bloc/admin_trail_bloc.dart';
import '../bloc/admin_trail_event.dart';
import '../bloc/admin_trail_state.dart';
import 'edit_trail_page.dart';

/// Trail detail and management page
class TrailDetailPage extends StatefulWidget {
  final String trailId;
  final AdminTrailEntity? trail;

  const TrailDetailPage({
    Key? key,
    required this.trailId,
    this.trail,
  }) : super(key: key);

  @override
  State<TrailDetailPage> createState() => _TrailDetailPageState();
}

class _TrailDetailPageState extends State<TrailDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Details'),
        actions: [
          IconButton(
            onPressed: widget.trail == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AdminTrailBloc>(),
                          child: EditTrailPage(trail: widget.trail!),
                        ),
                      ),
                    );
                  },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: BlocListener<AdminTrailBloc, AdminTrailState>(
        listener: (context, state) {
          if (state is TrailDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trail deleted successfully')),
            );
            Navigator.pop(context);
          } else if (state is AdminTrailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<AdminTrailBloc, AdminTrailState>(
          builder: (context, state) {
            if (state is AdminTrailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final trail = widget.trail;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (trail != null) ...[
                    Text(
                      trail.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(trail.location),
                    const SizedBox(height: 8),
                    Text('${trail.distance} km • ${trail.elevation} m'),
                    const SizedBox(height: 8),
                    Text('Difficulty: ${trail.difficulty}'),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Trail ID: ${widget.trailId}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete Trail'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Trail?'),
                            content: const Text(
                              'Are you sure you want to delete this trail? This action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AdminTrailBloc>().add(
                                    DeleteTrailEvent(widget.trailId),
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
