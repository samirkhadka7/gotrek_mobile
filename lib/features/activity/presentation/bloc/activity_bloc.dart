import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_recent_activities.dart';
import 'activity_event.dart';
import 'activity_state.dart';

/// BLoC for handling activity operations
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetRecentActivitiesUseCase getRecentActivitiesUseCase;

  ActivityBloc({
    required this.getRecentActivitiesUseCase,
  }) : super(const ActivityInitial()) {
    on<LoadRecentActivitiesEvent>(_onLoadRecentActivities);
    on<RefreshActivitiesEvent>(_onRefreshActivities);
  }

  Future<void> _onLoadRecentActivities(
    LoadRecentActivitiesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    emit(const ActivityLoading());
    await _fetchActivities(emit);
  }

  Future<void> _onRefreshActivities(
    RefreshActivitiesEvent event,
    Emitter<ActivityState> emit,
  ) async {
    await _fetchActivities(emit);
  }

  Future<void> _fetchActivities(Emitter<ActivityState> emit) async {
    final result = await getRecentActivitiesUseCase(const NoParams());

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(ActivityLoaded(activities)),
    );
  }
}
