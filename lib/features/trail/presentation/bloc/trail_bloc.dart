import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/trail_entity.dart';
import '../../domain/usecases/complete_trail_usecase.dart';
import '../../domain/usecases/get_popular_trails_usecase.dart';
import '../../domain/usecases/get_trail_by_id_usecase.dart';
import '../../domain/usecases/get_trails_usecase.dart';
import '../../domain/usecases/join_trail_usecase.dart';
import '../../domain/usecases/search_trails_usecase.dart';
import '../../domain/repositories/trail_repository.dart';
import 'trail_event.dart';
import 'trail_state.dart';

/// BLoC for managing trail state
class TrailBloc extends Bloc<TrailEvent, TrailState> {
  final GetTrailsUseCase getTrailsUseCase;
  final GetTrailByIdUseCase getTrailByIdUseCase;
  final SearchTrailsUseCase searchTrailsUseCase;
  final GetPopularTrailsUseCase getPopularTrailsUseCase;
  final JoinTrailUseCase joinTrailUseCase;
  final CompleteTrailUseCase completeTrailUseCase;
  final TrailRepository trailRepository;

  TrailBloc({
    required this.getTrailsUseCase,
    required this.getTrailByIdUseCase,
    required this.searchTrailsUseCase,
    required this.getPopularTrailsUseCase,
    required this.joinTrailUseCase,
    required this.completeTrailUseCase,
    required this.trailRepository,
  }) : super(const TrailInitial()) {
    on<LoadTrailsEvent>(_onLoadTrails);
    on<RefreshTrailsEvent>(_onRefreshTrails);
    on<LoadTrailDetailsEvent>(_onLoadTrailDetails);
    on<SearchTrailsEvent>(_onSearchTrails);
    on<ClearSearchEvent>(_onClearSearch);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ClearFiltersEvent>(_onClearFilters);
    on<LoadPopularTrailsEvent>(_onLoadPopularTrails);
    on<LoadFeaturedTrailsEvent>(_onLoadFeaturedTrails);
    on<JoinTrailEvent>(_onJoinTrail);
    on<CompleteTrailEvent>(_onCompleteTrail);
    on<CancelJoinedTrailEvent>(_onCancelJoinedTrail);
    on<RateTrailEvent>(_onRateTrail);
  }

  /// Load all trails
  Future<void> _onLoadTrails(
    LoadTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(const TrailsLoading(message: 'Loading trails...'));

    final result = await getTrailsUseCase(
      GetTrailsParams(filters: event.filters),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trails) => emit(TrailsLoaded(
        trails: trails,
        activeFilters: event.filters,
      )),
    );
  }

  /// Refresh trails
  Future<void> _onRefreshTrails(
    RefreshTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    // Get current filters if any
    TrailFilterParams? currentFilters;
    if (state is TrailsLoaded) {
      currentFilters = (state as TrailsLoaded).activeFilters;
    }

    emit(const TrailsLoading(message: 'Refreshing trails...'));

    final result = await getTrailsUseCase(
      GetTrailsParams(filters: currentFilters),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trails) => emit(TrailsLoaded(
        trails: trails,
        activeFilters: currentFilters,
      )),
    );
  }

  /// Load trail details
  Future<void> _onLoadTrailDetails(
    LoadTrailDetailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(const TrailDetailsLoading());

    final result = await getTrailByIdUseCase(
      GetTrailByIdParams(trailId: event.trailId),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trail) => emit(TrailDetailsLoaded(trail: trail)),
    );
  }

  /// Search trails
  Future<void> _onSearchTrails(
    SearchTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadTrailsEvent());
      return;
    }

    emit(const TrailsLoading(message: 'Searching...'));

    final result = await searchTrailsUseCase(
      SearchTrailsParams(query: event.query),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trails) => emit(TrailSearchResults(
        results: trails,
        query: event.query,
      )),
    );
  }

  /// Clear search
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<TrailState> emit,
  ) {
    add(const LoadTrailsEvent());
  }

  /// Apply filters
  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<TrailState> emit,
  ) async {
    add(LoadTrailsEvent(filters: event.filters));
  }

  /// Clear filters
  void _onClearFilters(
    ClearFiltersEvent event,
    Emitter<TrailState> emit,
  ) {
    add(const LoadTrailsEvent());
  }

  /// Load popular trails
  Future<void> _onLoadPopularTrails(
    LoadPopularTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(const TrailsLoading(message: 'Loading popular trails...'));

    final result = await getPopularTrailsUseCase(
      GetPopularTrailsParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trails) => emit(PopularTrailsLoaded(trails: trails)),
    );
  }

  /// Load featured trails
  Future<void> _onLoadFeaturedTrails(
    LoadFeaturedTrailsEvent event,
    Emitter<TrailState> emit,
  ) async {
    final result = await trailRepository.getFeaturedTrails(limit: event.limit);

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (trails) => emit(FeaturedTrailsLoaded(trails: trails)),
    );
  }

  /// Join a trail
  Future<void> _onJoinTrail(
    JoinTrailEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(TrailOperationInProgress(
      operation: 'join',
      trailId: event.trailId,
    ));

    final result = await joinTrailUseCase(JoinTrailParams(
      trailId: event.trailId,
      startDate: event.startDate,
    ));

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const TrailOperationSuccess(
        operation: 'join',
        message: 'Successfully joined the trail!',
      )),
    );
  }

  /// Complete a trail
  Future<void> _onCompleteTrail(
    CompleteTrailEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(TrailOperationInProgress(
      operation: 'complete',
      trailId: event.joinedTrailId,
    ));

    final result = await completeTrailUseCase(
      CompleteTrailParams(joinedTrailId: event.joinedTrailId),
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const TrailOperationSuccess(
        operation: 'complete',
        message: 'Congratulations! Trail completed!',
      )),
    );
  }

  /// Cancel joined trail
  Future<void> _onCancelJoinedTrail(
    CancelJoinedTrailEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(TrailOperationInProgress(
      operation: 'cancel',
      trailId: event.joinedTrailId,
    ));

    final result = await trailRepository.cancelJoinedTrail(event.joinedTrailId);

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const TrailOperationSuccess(
        operation: 'cancel',
        message: 'Trail booking cancelled',
      )),
    );
  }

  /// Rate a trail
  Future<void> _onRateTrail(
    RateTrailEvent event,
    Emitter<TrailState> emit,
  ) async {
    emit(TrailOperationInProgress(
      operation: 'rate',
      trailId: event.trailId,
    ));

    final result = await trailRepository.rateTrail(
      trailId: event.trailId,
      rating: event.rating,
      review: event.review,
    );

    result.fold(
      (failure) => emit(TrailError(
        message: failure.message,
        type: TrailErrorTypeExtension.fromMessage(failure.message),
      )),
      (_) => emit(const TrailOperationSuccess(
        operation: 'rate',
        message: 'Thank you for your rating!',
      )),
    );
  }
}
