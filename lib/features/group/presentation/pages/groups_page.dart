import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../injection/injection.dart';
import '../../domain/entities/group_entity.dart';
import '../bloc/group_bloc.dart';
import '../bloc/group_event.dart';
import '../bloc/group_state.dart';
import '../widgets/group_card.dart';

/// Groups listing page
class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> with SingleTickerProviderStateMixin {
  late final GroupBloc _groupBloc;
  late final TabController _tabController;
  GroupFilterParams? _activeFilters;

  @override
  void initState() {
    super.initState();
    _groupBloc = sl<GroupBloc>();
    _tabController = TabController(length: 2, vsync: this);
    _groupBloc.add(const LoadGroupsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        initialFilters: _activeFilters,
        onApply: (filters) {
          setState(() => _activeFilters = filters);
          _groupBloc.add(ApplyGroupFiltersEvent(filters: filters));
        },
        onClear: () {
          setState(() => _activeFilters = null);
          _groupBloc.add(const ClearGroupFiltersEvent());
        },
      ),
    );
  }

  void _navigateToGroupDetails(String groupId) {
    context.push(AppRoutes.groupDetailsPath(groupId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _groupBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Groups'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All Groups'),
              Tab(text: 'My Groups'),
            ],
          ),
          actions: [
            IconButton(
              icon: Badge(
                isLabelVisible: _activeFilters != null,
                child: const Icon(Icons.filter_list),
              ),
              onPressed: _showFilterSheet,
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // All Groups Tab
            _AllGroupsTab(
              onGroupTap: _navigateToGroupDetails,
              onRefresh: () async {
                _groupBloc.add(const RefreshGroupsEvent());
              },
            ),
            // My Groups Tab
            _MyGroupsTab(
              onGroupTap: _navigateToGroupDetails,
            ),
          ],
        ),
      ),
    );
  }
}

/// All groups tab
class _AllGroupsTab extends StatelessWidget {
  final void Function(String) onGroupTap;
  final Future<void> Function() onRefresh;

  const _AllGroupsTab({
    required this.onGroupTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        if (state is GroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupError) {
          return _ErrorView(
            message: state.message,
            onRetry: () {
              context.read<GroupBloc>().add(const LoadGroupsEvent());
            },
          );
        }

        if (state is GroupsLoaded) {
          return _GroupsList(
            groups: state.groups,
            onGroupTap: onGroupTap,
            onRefresh: onRefresh,
            isFromCache: state.isFromCache,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// My groups tab
class _MyGroupsTab extends StatefulWidget {
  final void Function(String) onGroupTap;

  const _MyGroupsTab({required this.onGroupTap});

  @override
  State<_MyGroupsTab> createState() => _MyGroupsTabState();
}

class _MyGroupsTabState extends State<_MyGroupsTab> {
  @override
  void initState() {
    super.initState();
    context.read<GroupBloc>().add(const LoadMyGroupsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupBloc, GroupState>(
      buildWhen: (previous, current) =>
          current is MyGroupsLoading ||
          current is MyGroupsLoaded ||
          current is GroupError,
      builder: (context, state) {
        if (state is MyGroupsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupError) {
          return _ErrorView(
            message: state.message,
            onRetry: () {
              context.read<GroupBloc>().add(const LoadMyGroupsEvent());
            },
          );
        }

        if (state is MyGroupsLoaded) {
          return _GroupsList(
            groups: state.groups,
            onGroupTap: widget.onGroupTap,
            onRefresh: () async {
              context.read<GroupBloc>().add(const LoadMyGroupsEvent());
            },
            emptyMessage: 'You haven\'t joined any groups yet.',
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

/// Groups list widget
class _GroupsList extends StatelessWidget {
  final List<GroupEntity> groups;
  final void Function(String) onGroupTap;
  final Future<void> Function() onRefresh;
  final bool isFromCache;
  final String emptyMessage;

  const _GroupsList({
    required this.groups,
    required this.onGroupTap,
    required this.onRefresh,
    this.isFromCache = false,
    this.emptyMessage = 'No groups found.',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (groups.isEmpty) {
      return _EmptyView(message: emptyMessage);
    }

    return Column(
      children: [
        if (isFromCache)
          Container(
            color: theme.colorScheme.tertiaryContainer,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.cloud_off,
                  size: 16,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Showing cached data (offline)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 80),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  group: group,
                  onTap: () => onGroupTap(group.id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Empty state view
class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Groups',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter bottom sheet
class _FilterBottomSheet extends StatefulWidget {
  final GroupFilterParams? initialFilters;
  final void Function(GroupFilterParams) onApply;
  final VoidCallback onClear;

  const _FilterBottomSheet({
    this.initialFilters,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  GroupStatus? _selectedStatus;
  GroupSortBy _sortBy = GroupSortBy.startDate;
  bool _ascending = true;
  bool _hasAvailableSlots = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedStatus = widget.initialFilters!.status;
      _sortBy = widget.initialFilters!.sortBy ?? GroupSortBy.startDate;
      _ascending = widget.initialFilters!.ascending ?? true;
      _hasAvailableSlots = widget.initialFilters!.hasAvailableSlots ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Groups',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  Navigator.pop(context);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Status Filter
          Text(
            'Status',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: GroupStatus.values.map((status) {
              return FilterChip(
                label: Text(status.toDisplayString()),
                selected: _selectedStatus == status,
                onSelected: (selected) {
                  setState(() {
                    _selectedStatus = selected ? status : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Availability Filter
          SwitchListTile(
            title: const Text('Only show groups with available slots'),
            value: _hasAvailableSlots,
            onChanged: (value) => setState(() => _hasAvailableSlots = value),
          ),
          const SizedBox(height: 16),

          // Sort By
          Text(
            'Sort By',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: GroupSortBy.values.map((sortOption) {
              return ChoiceChip(
                label: Text(sortOption.toDisplayString()),
                selected: _sortBy == sortOption,
                onSelected: (_) => setState(() => _sortBy = sortOption),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Sort Order
          SwitchListTile(
            title: const Text('Ascending Order'),
            value: _ascending,
            onChanged: (value) => setState(() => _ascending = value),
          ),
          const SizedBox(height: 24),

          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(GroupFilterParams(
                  status: _selectedStatus,
                  sortBy: _sortBy,
                  ascending: _ascending,
                  hasAvailableSlots: _hasAvailableSlots ? true : null,
                ));
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
