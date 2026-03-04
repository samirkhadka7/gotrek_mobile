import 'package:equatable/equatable.dart';
import '../../domain/entities/admin_trail_entity.dart';

/// Base state for Admin Trail
abstract class AdminTrailState extends Equatable {
  const AdminTrailState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AdminTrailInitial extends AdminTrailState {}

/// Loading state
class AdminTrailLoading extends AdminTrailState {}

/// Trails list loaded
class TrailsLoaded extends AdminTrailState {
  final List<AdminTrailEntity> trails;
  final int total;
  final int currentPage;
  final int totalPages;

  const TrailsLoaded({
    required this.trails,
    required this.total,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [trails, total, currentPage, totalPages];
}

/// Trail details loaded
class TrailDetailsLoaded extends AdminTrailState {
  final AdminTrailEntity trail;

  const TrailDetailsLoaded(this.trail);

  @override
  List<Object?> get props => [trail];
}

/// Trail created successfully
class TrailCreated extends AdminTrailState {
  final AdminTrailEntity newTrail;

  const TrailCreated(this.newTrail);

  @override
  List<Object?> get props => [newTrail];
}

/// Trail updated successfully
class TrailUpdated extends AdminTrailState {
  final AdminTrailEntity updatedTrail;

  const TrailUpdated(this.updatedTrail);

  @override
  List<Object?> get props => [updatedTrail];
}

/// Trail deleted successfully
class TrailDeleted extends AdminTrailState {
  final String trailId;

  const TrailDeleted(this.trailId);

  @override
  List<Object?> get props => [trailId];
}

/// Error state
class AdminTrailError extends AdminTrailState {
  final String message;

  const AdminTrailError(this.message);

  @override
  List<Object?> get props => [message];
}
