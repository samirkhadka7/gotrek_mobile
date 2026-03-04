import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_analytics.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

/// BLoC for handling analytics operations
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsUseCase getAnalyticsUseCase;

  AnalyticsBloc({
    required this.getAnalyticsUseCase,
  }) : super(const AnalyticsInitial()) {
    on<LoadAnalyticsEvent>(_onLoadAnalytics);
    on<RefreshAnalyticsEvent>(_onRefreshAnalytics);
  }

  Future<void> _onLoadAnalytics(
    LoadAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(const AnalyticsLoading());
    await _fetchAnalytics(emit);
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalyticsEvent event,
    Emitter<AnalyticsState> emit,
  ) async {
    await _fetchAnalytics(emit);
  }

  Future<void> _fetchAnalytics(Emitter<AnalyticsState> emit) async {
    final result = await getAnalyticsUseCase(const NoParams());

    result.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (analytics) => emit(AnalyticsLoaded(analytics)),
    );
  }
}
