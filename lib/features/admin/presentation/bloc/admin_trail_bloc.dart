import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_trails.dart';
import '../../domain/usecases/create_trail.dart';
import '../../domain/usecases/update_trail.dart';
import '../../domain/usecases/delete_trail.dart';
import 'admin_trail_event.dart';
import 'admin_trail_state.dart';

/// BLoC for Admin Trail Management
class AdminTrailBloc extends Bloc<AdminTrailEvent, AdminTrailState> {
  final GetAllTrailsUseCase getAllTrailsUseCase;
  final CreateTrailUseCase createTrailUseCase;
  final UpdateTrailUseCase updateTrailUseCase;
  final DeleteTrailUseCase deleteTrailUseCase;

  AdminTrailBloc({
    required this.getAllTrailsUseCase,
    required this.createTrailUseCase,
    required this.updateTrailUseCase,
    required this.deleteTrailUseCase,
  }) : super(AdminTrailInitial()) {
    on<LoadAllTrailsEvent>(_onLoadAllTrails);
    on<CreateTrailEvent>(_onCreateTrail);
    on<UpdateTrailEvent>(_onUpdateTrail);
    on<DeleteTrailEvent>(_onDeleteTrail);
    on<RefreshTrailsEvent>(_onRefreshTrails);
  }

  Future<void> _onLoadAllTrails(
    LoadAllTrailsEvent event,
    Emitter<AdminTrailState> emit,
  ) async {
    emit(AdminTrailLoading());

    final params = GetAllTrailsParams(
      page: event.page,
      limit: event.limit,
      search: event.search,
      maxDistance: event.maxDistance,
      maxElevation: event.maxElevation,
      difficulty: event.difficulty,
    );

    final result = await getAllTrailsUseCase(params);

    result.fold(
      (failure) => emit(AdminTrailError(failure.message)),
      (trailList) => emit(TrailsLoaded(
        trails: trailList.trails,
        total: trailList.total,
        currentPage: trailList.page,
        totalPages: trailList.totalPages,
      )),
    );
  }

  Future<void> _onCreateTrail(
    CreateTrailEvent event,
    Emitter<AdminTrailState> emit,
  ) async {
    emit(AdminTrailLoading());

    final params = CreateTrailParams(
      name: event.name,
      description: event.description,
      location: event.location,
      distance: event.distance,
      elevation: event.elevation,
      difficulty: event.difficulty,
      durationMin: event.durationMin,
      durationMax: event.durationMax,
      imagePaths: event.imagePaths,
    );

    final result = await createTrailUseCase(params);

    result.fold(
      (failure) => emit(AdminTrailError(failure.message)),
      (newTrail) => emit(TrailCreated(newTrail)),
    );
  }

  Future<void> _onUpdateTrail(
    UpdateTrailEvent event,
    Emitter<AdminTrailState> emit,
  ) async {
    emit(AdminTrailLoading());

    final params = UpdateTrailParams(
      trailId: event.trailId,
      name: event.name,
      description: event.description,
      location: event.location,
      distance: event.distance,
      elevation: event.elevation,
      difficulty: event.difficulty,
      durationMin: event.durationMin,
      durationMax: event.durationMax,
      imagePaths: event.imagePaths,
    );

    final result = await updateTrailUseCase(params);

    result.fold(
      (failure) => emit(AdminTrailError(failure.message)),
      (updatedTrail) => emit(TrailUpdated(updatedTrail)),
    );
  }

  Future<void> _onDeleteTrail(
    DeleteTrailEvent event,
    Emitter<AdminTrailState> emit,
  ) async {
    emit(AdminTrailLoading());

    final result = await deleteTrailUseCase(event.trailId);

    result.fold(
      (failure) => emit(AdminTrailError(failure.message)),
      (_) => emit(TrailDeleted(event.trailId)),
    );
  }

  Future<void> _onRefreshTrails(
    RefreshTrailsEvent event,
    Emitter<AdminTrailState> emit,
  ) async {
    add(const LoadAllTrailsEvent());
  }
}
