import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admin_trail_bloc.dart';
import '../bloc/admin_trail_event.dart';
import '../bloc/admin_trail_state.dart';
import '../widgets/trail_list_item_widget.dart';
import 'create_trail_page.dart';
import 'trail_detail_page.dart';

/// Admin Trails Management Page
class AdminTrailsPage extends StatefulWidget {
  const AdminTrailsPage({Key? key}) : super(key: key);

  @override
  State<AdminTrailsPage> createState() => _AdminTrailsPageState();
}

class _AdminTrailsPageState extends State<AdminTrailsPage> {
  int _currentPage = 1;
  final int _limit = 10;
  String? _searchQuery;
  String? _selectedDifficulty;
  double? _maxDistance;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _maxDistanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrails();
  }

  void _loadTrails() {
    context.read<AdminTrailBloc>().add(
      LoadAllTrailsEvent(
        page: _currentPage,
        limit: _limit,
        search: _searchQuery,
        difficulty: _selectedDifficulty,
        maxDistance: _maxDistance,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trail Management'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTrails,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<AdminTrailBloc>(),
                child: const CreateTrailPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search trails...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _searchQuery = value.isEmpty ? null : value;
                    _currentPage = 1;
                    _loadTrails();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDifficulty,
                        decoration: InputDecoration(
                          labelText: 'Difficulty',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('All Difficulties'),
                          ),
                          DropdownMenuItem(
                            value: 'Easy',
                            child: Text('Easy'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'Hard',
                            child: Text('Hard'),
                          ),
                        ],
                        onChanged: (value) {
                          _selectedDifficulty = value;
                          _currentPage = 1;
                          _loadTrails();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _maxDistanceController,
                        decoration: InputDecoration(
                          labelText: 'Max Distance (km)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) {
                          _maxDistance =
                              value.isEmpty ? null : double.tryParse(value);
                          _currentPage = 1;
                          _loadTrails();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Trails List
          Expanded(
            child: BlocListener<AdminTrailBloc, AdminTrailState>(
              listener: (context, state) {
                if (state is AdminTrailError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                } else if (state is TrailDeleted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trail deleted successfully')),
                  );
                  _loadTrails();
                } else if (state is TrailCreated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trail created successfully')),
                  );
                  _loadTrails();
                } else if (state is TrailUpdated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trail updated successfully')),
                  );
                  _loadTrails();
                }
              },
              child: BlocBuilder<AdminTrailBloc, AdminTrailState>(
                builder: (context, state) {
                  if (state is AdminTrailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TrailsLoaded) {
                    if (state.trails.isEmpty) {
                      return const Center(child: Text('No trails found'));
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Total Trails: ${state.total} (Page ${state.currentPage}/${state.totalPages})',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.trails.length,
                            itemBuilder: (context, index) {
                              final trail = state.trails[index];
                              return TrailListItemWidget(
                                trail: trail,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<AdminTrailBloc>(),
                                        child: TrailDetailPage(
                                          trailId: trail.id,
                                          trail: trail,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is AdminTrailError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadTrails,
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

          // Pagination
          BlocBuilder<AdminTrailBloc, AdminTrailState>(
            builder: (context, state) {
              if (state is TrailsLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentPage > 1)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Previous'),
                          onPressed: () {
                            _currentPage--;
                            _loadTrails();
                          },
                        ),
                      const SizedBox(width: 16),
                      Text('Page $_currentPage of ${state.totalPages}'),
                      const SizedBox(width: 16),
                      if (_currentPage < state.totalPages)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                          onPressed: () {
                            _currentPage++;
                            _loadTrails();
                          },
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _maxDistanceController.dispose();
    super.dispose();
  }
}
