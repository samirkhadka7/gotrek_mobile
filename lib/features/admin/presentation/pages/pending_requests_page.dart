import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../group/domain/entities/group_entity.dart';
import '../../../group/presentation/bloc/group_bloc.dart';
import '../../../group/presentation/bloc/group_event.dart';
import '../../../group/presentation/bloc/group_state.dart';

/// Pending Join Requests Page for Admin
class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({Key? key}) : super(key: key);

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  @override
  void initState() {
    super.initState();
    // Load pending requests when page initializes
    context.read<GroupBloc>().add(const LoadPendingRequestsEvent());
  }

  List<JoinRequest> _cachedRequests = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
          // Reload pending requests after error
          if (mounted) {
            context.read<GroupBloc>().add(const LoadPendingRequestsEvent());
          }
        } else if (state is JoinRequestManaged ||
            state is GroupOperationSuccess) {
          // Refresh the list after approving/denying
          if (mounted) {
            context.read<GroupBloc>().add(const LoadPendingRequestsEvent());
          }
        }
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is PendingRequestsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PendingRequestsLoaded) {
            _cachedRequests = state.requests;
          }

          // Show cached requests for transient states
          if (state is PendingRequestsLoaded ||
              state is GroupActionInProgress ||
              state is GroupOperationSuccess ||
              state is JoinRequestManaged) {
            if (_cachedRequests.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Pending Requests',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All join requests have been processed',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _cachedRequests.length,
              itemBuilder: (context, index) {
                final request = _cachedRequests[index];
                return _buildRequestCard(context, request);
              },
            );
          }

          return const Center(
            child: Text('Loading requests...'),
          );
        },
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, JoinRequest request) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: request.userProfilePicture != null
                      ? NetworkImage(request.userProfilePicture!)
                      : null,
                  child: request.userProfilePicture == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.username,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User ID: ${request.userId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Message
            if (request.message != null && request.message!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.message!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Request Date
            Text(
              'Requested: ${_formatDate(request.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApprove(context, request),
                    icon: const Icon(Icons.check),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleDeny(context, request),
                    icon: const Icon(Icons.close),
                    label: const Text('Deny'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
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

  void _handleApprove(BuildContext context, JoinRequest request) {
    _showConfirmDialog(
      context: context,
      title: 'Approve Request',
      message:
          'Are you sure you want to approve ${request.username}\'s join request?',
      onConfirm: (dialogContext) {
        context.read<GroupBloc>().add(
              ManageJoinRequestEvent(
                groupId: request.groupId,
                requestId: request.id,
                approve: true,
              ),
            );
        Navigator.pop(dialogContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${request.username}\'s request approved!'),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }

  void _handleDeny(BuildContext context, JoinRequest request) {
    _showConfirmDialog(
      context: context,
      title: 'Deny Request',
      message:
          'Are you sure you want to deny ${request.username}\'s join request?',
      onConfirm: (dialogContext) {
        context.read<GroupBloc>().add(
              ManageJoinRequestEvent(
                groupId: request.groupId,
                requestId: request.id,
                approve: false,
              ),
            );
        Navigator.pop(dialogContext);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${request.username}\'s request denied!'),
            backgroundColor: Colors.orange,
          ),
        );
      },
    );
  }

  void _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required void Function(BuildContext dialogContext) onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => onConfirm(dialogContext),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
