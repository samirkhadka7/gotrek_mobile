/// Trail Feature barrel export
///
/// This file exports all public APIs for the trail feature
/// following Clean Architecture principles.

// Domain Layer
export 'domain/entities/trail_entity.dart';
export 'domain/repositories/trail_repository.dart';
export 'domain/usecases/complete_trail_usecase.dart';
export 'domain/usecases/get_popular_trails_usecase.dart';
export 'domain/usecases/get_trail_by_id_usecase.dart';
export 'domain/usecases/get_trails_usecase.dart';
export 'domain/usecases/join_trail_usecase.dart';
export 'domain/usecases/search_trails_usecase.dart';

// Data Layer
export 'data/models/trail_model.dart';
export 'data/datasources/local/trail_local_datasource.dart';
export 'data/datasources/remote/trail_remote_datasource.dart';
export 'data/repositories/trail_repository_impl.dart';

// Presentation Layer
export 'presentation/bloc/trail_bloc.dart';
export 'presentation/bloc/trail_event.dart';
export 'presentation/bloc/trail_state.dart';
export 'presentation/pages/trails_page.dart';
export 'presentation/pages/trail_details_page.dart';
export 'presentation/widgets/trail_card.dart';
