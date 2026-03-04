import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection/injection.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';
import 'edit_group_page.dart';

/// Check if URL is valid for network image
bool _isValidImageUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

/// Group details page
class GroupDetailsPage extends StatefulWidget {
  final String groupId;

  const GroupDetailsPage({
    super.key,
    required this.groupId,
  });

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage>
    with SingleTickerProviderStateMixin {
  late final GroupBloc _groupBloc;
  late TabController _tabController;
  GroupEntity? _lastLoadedGroup;

  @override
  void initState() {
    super.initState();
    _groupBloc = sl<GroupBloc>();
    _groupBloc.add(LoadGroupDetailsEvent(groupId: widget.groupId));
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showJoinRequestDialog(GroupEntity group) {
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.group_add,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Request to Join',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          group.name,
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
              const SizedBox(height: 24),
              const Text(
                'Message to the leader (optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tell the group leader about yourself...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _groupBloc.add(RequestJoinGroupEvent(
                      groupId: group.id,
                      message: messageController.text.isNotEmpty
                          ? messageController.text
                          : null,
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Request',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCommentDialog(GroupEntity group) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add a Comment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (commentController.text.isNotEmpty) {
                      Navigator.pop(context);
                      _groupBloc.add(AddCommentEvent(
                        groupId: group.id,
                        content: commentController.text,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Post Comment'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupBloc,
      child: BlocConsumer<GroupBloc, GroupState>(
        listener: (context, state) {
          if (state is GroupOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            // Reload group details
            _groupBloc.add(LoadGroupDetailsEvent(groupId: widget.groupId));
          } else if (state is GroupDetailsLoaded) {
            _lastLoadedGroup = state.group;
          } else if (state is GroupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
            // Re-load group details so the view doesn't get stuck on error
            if (_lastLoadedGroup != null) {
              _groupBloc.add(LoadGroupDetailsEvent(groupId: widget.groupId));
            }
          }
        },
        builder: (context, state) {
          if (state is GroupDetailsLoading && _lastLoadedGroup == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is GroupDetailsLoaded) {
            _lastLoadedGroup = state.group;
            return _buildContent(state.group);
          }

          // If we have a previously loaded group, keep showing it
          if (_lastLoadedGroup != null) {
            return _buildContent(_lastLoadedGroup!);
          }

          if (state is GroupError) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _groupBloc.add(LoadGroupDetailsEvent(groupId: widget.groupId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildContent(GroupEntity group) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // Header with image
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<GroupBloc>(),
                          child: EditGroupPage(group: group),
                        ),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 8)],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_isValidImageUrl(group.trailImage))
                      CachedNetworkImage(
                        imageUrl: group.trailImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.primary.withOpacity(0.3),
                          child: const Icon(
                            Icons.terrain,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                      )
                    else
                      Container(
                        color: AppColors.primary,
                        child: const Icon(
                          Icons.group,
                          size: 80,
                          color: Colors.white54,
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Status badge
                    Positioned(
                      top: 100,
                      left: 16,
                      child: _StatusBadge(status: group.status),
                    ),
                  ],
                ),
              ),
            ),
            // Info section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Trail name
                    Row(
                      children: [
                        Icon(Icons.terrain, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            group.trailName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.calendar_today,
                          label: group.formattedStartDate,
                        ),
                        const SizedBox(width: 12),
                        _InfoChip(
                          icon: Icons.people,
                          label: group.participantCountText,
                        ),
                        if (group.availableSlots > 0) ...[
                          const SizedBox(width: 12),
                          _InfoChip(
                            icon: Icons.event_seat,
                            label: '${group.availableSlots} slots left',
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                    if (group.description != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        group.description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(
                      text: 'Members (${group.currentParticipants})',
                    ),
                    Tab(
                      text: 'Comments (${group.comments.length})',
                    ),
                    if (group.pendingRequests.isNotEmpty)
                      Tab(
                        text: 'Requests (${group.pendingRequests.length})',
                      )
                    else
                      const Tab(text: 'Requests'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _MembersTab(participants: group.participants),
            _CommentsTab(
              comments: group.comments,
              onAddComment: () => _showAddCommentDialog(group),
            ),
            _RequestsTab(
              requests: group.pendingRequests,
              onApprove: (requestId) {
                _groupBloc.add(ManageJoinRequestEvent(
                  groupId: group.id,
                  requestId: requestId,
                  approve: true,
                ));
              },
              onDeny: (requestId) {
                _groupBloc.add(ManageJoinRequestEvent(
                  groupId: group.id,
                  requestId: requestId,
                  approve: false,
                ));
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(group),
    );
  }

  Widget _buildBottomBar(GroupEntity group) {
    // Get current user ID from auth state
    final authState = context.read<AuthBloc>().state;
    final currentUserId =
        authState is AuthAuthenticated ? authState.user.id : '';
    final isMember = group.isUserMember(currentUserId);
    final hasPendingRequest = group.joinRequests.any(
      (r) => r.userId == currentUserId && r.isPending,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: isMember
            ? Row(
                children: [
                  // Chat Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          AppRoutes.chatRoomPath(group.id),
                          extra: group.name,
                        );
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('Chat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Leave Group Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _groupBloc.add(LeaveGroupEvent(groupId: group.id));
                      },
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Leave Group'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : hasPendingRequest
                ? OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.hourglass_top),
                    label: const Text('Request Pending'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      disabledForegroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: group.isFull
                        ? null
                        : () => _showJoinRequestDialog(group),
                    icon: const Icon(Icons.group_add),
                    label: Text(
                      group.isFull ? 'Group Full' : 'Request to Join',
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final GroupStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(status.colorValue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toDisplayString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: chipColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class _MembersTab extends StatelessWidget {
  final List<GroupParticipant> participants;

  const _MembersTab({required this.participants});

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const Center(
        child: Text('No members yet'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return _ParticipantTile(participant: participant);
      },
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final GroupParticipant participant;

  const _ParticipantTile({required this.participant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: _isValidImageUrl(participant.profilePicture)
                ? CachedNetworkImageProvider(participant.profilePicture!)
                : null,
            child: !_isValidImageUrl(participant.profilePicture)
                ? Text(
                    participant.username.isNotEmpty
                        ? participant.username.substring(0, 1).toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.username,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  participant.isLeader ? '👑 Leader' : 'Member',
                  style: TextStyle(
                    fontSize: 13,
                    color: participant.isLeader
                        ? Colors.amber.shade700
                        : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsTab extends StatelessWidget {
  final List<GroupComment> comments;
  final VoidCallback onAddComment;

  const _CommentsTab({
    required this.comments,
    required this.onAddComment,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (comments.isEmpty)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No comments yet'),
              ],
            ),
          )
        else
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return _CommentTile(comment: comment);
            },
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: onAddComment,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add_comment, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final GroupComment comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: _isValidImageUrl(comment.userProfilePicture)
                    ? CachedNetworkImageProvider(comment.userProfilePicture!)
                    : null,
                child: !_isValidImageUrl(comment.userProfilePicture)
                    ? Text(
                        comment.username.isNotEmpty
                            ? comment.username.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _formatDate(comment.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _RequestsTab extends StatelessWidget {
  final List<JoinRequest> requests;
  final Function(String) onApprove;
  final Function(String) onDeny;

  const _RequestsTab({
    required this.requests,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_disabled, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No pending requests'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return _RequestTile(
          request: request,
          onApprove: () => onApprove(request.id),
          onDeny: () => onDeny(request.id),
        );
      },
    );
  }
}

class _RequestTile extends StatelessWidget {
  final JoinRequest request;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  const _RequestTile({
    required this.request,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: _isValidImageUrl(request.userProfilePicture)
                    ? CachedNetworkImageProvider(request.userProfilePicture!)
                    : null,
                child: !_isValidImageUrl(request.userProfilePicture)
                    ? Text(
                        request.username.isNotEmpty
                            ? request.username.substring(0, 1).toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
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
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDate(request.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (request.message != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${request.message}"',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDeny,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Deny'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
