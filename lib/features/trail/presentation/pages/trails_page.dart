import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../injection/injection.dart';
import '../../domain/entities/trail_entity.dart';
import '../bloc/trail_bloc.dart';
import '../bloc/trail_event.dart';
import '../bloc/trail_state.dart';
import '../widgets/trail_card.dart';

/// Trails listing page (Explore screen)
class TrailsPage extends StatefulWidget {
  const TrailsPage({super.key});

  @override
  State<TrailsPage> createState() => _TrailsPageState();
}

class _TrailsPageState extends State<TrailsPage> {
  late final TrailBloc _trailBloc;
  final _searchController = TextEditingController();
  TrailFilterParams? _activeFilters;

  @override
  void initState() {
    super.initState();
    _trailBloc = sl<TrailBloc>();
    _trailBloc.add(const LoadTrailsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _trailBloc.add(const ClearSearchEvent());
    } else {
      _trailBloc.add(SearchTrailsEvent(query: query));
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        initialFilters: _activeFilters,
        onApply: (filters) {
          setState(() => _activeFilters = filters);
          _trailBloc.add(ApplyFiltersEvent(filters: filters));
        },
        onClear: () {
          setState(() => _activeFilters = null);
          _trailBloc.add(const ClearFiltersEvent());
        },
      ),
    );
  }

  void _navigateToTrailDetails(String trailId) {
    context.push(AppRoutes.trailDetailsPath(trailId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _trailBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore Trails'),
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
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search trails...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _onSearch,
              ),
            ),

            // Trail List
            Expanded(
              child: BlocBuilder<TrailBloc, TrailState>(
                builder: (context, state) {
                  if (state is TrailsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is TrailError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => _trailBloc.add(const RefreshTrailsEvent()),
                    );
                  }

                  if (state is TrailsLoaded) {
                    return _TrailsList(
                      trails: state.trails,
                      onTrailTap: _navigateToTrailDetails,
                      onRefresh: () async {
                        _trailBloc.add(const RefreshTrailsEvent());
                      },
                    );
                  }

                  if (state is TrailSearchResults) {
                    if (state.results.isEmpty) {
                      return _EmptySearchView(query: state.query);
                    }
                    return _TrailsList(
                      trails: state.results,
                      onTrailTap: _navigateToTrailDetails,
                      onRefresh: () async {
                        _trailBloc.add(SearchTrailsEvent(query: state.query));
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Trails list widget
class _TrailsList extends StatelessWidget {
  final List<TrailEntity> trails;
  final void Function(String) onTrailTap;
  final Future<void> Function() onRefresh;

  const _TrailsList({
    required this.trails,
    required this.onTrailTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (trails.isEmpty) {
      return const _EmptyView();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 16),
        itemCount: trails.length,
        itemBuilder: (context, index) {
          final trail = trails[index];
          return TrailCard(
            trail: trail,
            onTap: () => onTrailTap(trail.id),
          );
        },
      ),
    );
  }
}

/// Empty state view
class _EmptyView extends StatelessWidget {
  const _EmptyView();

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
              Icons.terrain_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Trails Found',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new adventures!',
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

/// Empty search results view
class _EmptySearchView extends StatelessWidget {
  final String query;

  const _EmptySearchView({required this.query});

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
              Icons.search_off,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Results',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No trails found for "$query".\nTry a different search term.',
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
  final TrailFilterParams? initialFilters;
  final void Function(TrailFilterParams) onApply;
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
  TrailDifficulty? _selectedDifficulty;
  TrailSortBy _sortBy = TrailSortBy.name;
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialFilters != null) {
      _selectedDifficulty = widget.initialFilters!.difficulty;
      _sortBy = widget.initialFilters!.sortBy ?? TrailSortBy.name;
      _ascending = widget.initialFilters!.ascending ?? true;
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
                'Filter Trails',
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

          // Difficulty Filter
          Text(
            'Difficulty',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: TrailDifficulty.values.map((difficulty) {
              return FilterChip(
                label: Text(difficulty.toDisplayString()),
                selected: _selectedDifficulty == difficulty,
                onSelected: (selected) {
                  setState(() {
                    _selectedDifficulty = selected ? difficulty : null;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

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
            children: [
              ChoiceChip(
                label: const Text('Name'),
                selected: _sortBy == TrailSortBy.name,
                onSelected: (_) => setState(() => _sortBy = TrailSortBy.name),
              ),
              ChoiceChip(
                label: const Text('Distance'),
                selected: _sortBy == TrailSortBy.distance,
                onSelected: (_) => setState(() => _sortBy = TrailSortBy.distance),
              ),
              ChoiceChip(
                label: const Text('Rating'),
                selected: _sortBy == TrailSortBy.rating,
                onSelected: (_) => setState(() => _sortBy = TrailSortBy.rating),
              ),
              ChoiceChip(
                label: const Text('Newest'),
                selected: _sortBy == TrailSortBy.newest,
                onSelected: (_) => setState(() => _sortBy = TrailSortBy.newest),
              ),
            ],
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
                widget.onApply(TrailFilterParams(
                  difficulty: _selectedDifficulty,
                  sortBy: _sortBy,
                  ascending: _ascending,
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
