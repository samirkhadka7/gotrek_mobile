import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../group/domain/entities/group_entity.dart';
import '../../../group/presentation/bloc/group_bloc.dart';
import '../../../group/presentation/bloc/group_event.dart';
import '../../../group/presentation/bloc/group_state.dart';
import '../../../group/presentation/pages/edit_group_page.dart';
import '../widgets/group_list_item_widget.dart';

/// Admin Groups Management Page
class AdminGroupsPage extends StatefulWidget {
  const AdminGroupsPage({Key? key}) : super(key: key);

  @override
  State<AdminGroupsPage> createState() => _AdminGroupsPageState();
}

class _AdminGroupsPageState extends State<AdminGroupsPage> {
  String? _selectedStatus;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  void _loadGroups() {
    GroupFilterParams? filters;
    if (_selectedStatus != null) {
      final statusMap = {
        'Forming': GroupStatus.forming,
        'Upcoming': GroupStatus.upcoming,
        'Active': GroupStatus.active,
        'Completed': GroupStatus.completed,
        'Cancelled': GroupStatus.cancelled,
      };
      filters = GroupFilterParams(status: statusMap[_selectedStatus]);
    }

    context.read<GroupBloc>().add(
          LoadGroupsEvent(filters: filters),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(AppRoutes.createGroup),
            tooltip: 'Create Group',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGroups,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoutes.createGroup),
                icon: const Icon(Icons.add),
                label: const Text('Create Group'),
              ),
            ),
          ),
          // Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search groups...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _loadGroups();
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem(
                      value: 'Forming',
                      child: Text('Forming'),
                    ),
                    DropdownMenuItem(
                      value: 'Upcoming',
                      child: Text('Upcoming'),
                    ),
                    DropdownMenuItem(
                      value: 'Active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem(
                      value: 'Completed',
                      child: Text('Completed'),
                    ),
                    DropdownMenuItem(
                      value: 'Cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  onChanged: (value) {
                    _selectedStatus = value;
                    _loadGroups();
                  },
                ),
              ],
            ),
          ),

          // Groups List
          Expanded(
            child: BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                } else if (state is GroupUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Group updated successfully')),
                  );
                  _loadGroups();
                }
              },
              child: BlocBuilder<GroupBloc, GroupState>(
                builder: (context, state) {
                  if (state is GroupLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GroupsLoaded) {
                    if (state.groups.isEmpty) {
                      return const Center(child: Text('No groups found'));
                    }
                    return ListView.builder(
                      itemCount: state.groups.length,
                      itemBuilder: (context, index) {
                        final group = state.groups[index];
                        return GroupListItemWidget(
                          group: group,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<GroupBloc>(),
                                  child: EditGroupPage(group: group),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is GroupError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadGroups,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
