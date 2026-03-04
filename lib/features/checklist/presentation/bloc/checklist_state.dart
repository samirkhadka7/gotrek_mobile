import 'package:equatable/equatable.dart';

import '../../domain/entities/checklist_entity.dart';

/// Base class for all checklist states
abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChecklistInitial extends ChecklistState {
  const ChecklistInitial();
}

/// Loading state
class ChecklistLoading extends ChecklistState {
  final String? message;

  const ChecklistLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when checklist is loaded
class ChecklistLoaded extends ChecklistState {
  final UserChecklist checklist;

  const ChecklistLoaded(this.checklist);

  @override
  List<Object?> get props => [checklist];
}

/// State when no checklist exists (show config form)
class ChecklistEmpty extends ChecklistState {
  final ChecklistConfig config;

  const ChecklistEmpty({
    this.config = const ChecklistConfig(
      experience: HikerExperience.newbie,
      duration: TrekDuration.halfDay,
      weather: WeatherCondition.mild,
    ),
  });

  @override
  List<Object?> get props => [config];
}

/// State when config is being selected
class ChecklistConfiguring extends ChecklistState {
  final ChecklistConfig config;

  const ChecklistConfiguring({
    this.config = const ChecklistConfig(
      experience: HikerExperience.newbie,
      duration: TrekDuration.halfDay,
      weather: WeatherCondition.mild,
    ),
  });

  ChecklistConfiguring copyWith({
    HikerExperience? experience,
    TrekDuration? duration,
    WeatherCondition? weather,
  }) {
    return ChecklistConfiguring(
      config: ChecklistConfig(
        experience: experience ?? config.experience,
        duration: duration ?? config.duration,
        weather: weather ?? config.weather,
      ),
    );
  }

  @override
  List<Object?> get props => [config];
}

/// State when checklist is generated but not saved
class ChecklistGenerated extends ChecklistState {
  final GeneratedChecklist generatedChecklist;
  final ChecklistConfig config;

  const ChecklistGenerated({
    required this.generatedChecklist,
    required this.config,
  });

  @override
  List<Object?> get props => [generatedChecklist, config];
}

/// Error state
class ChecklistError extends ChecklistState {
  final String message;
  final ChecklistConfig? lastConfig;

  const ChecklistError({
    required this.message,
    this.lastConfig,
  });

  @override
  List<Object?> get props => [message, lastConfig];
}

/// State when saving checklist
class ChecklistSaving extends ChecklistState {
  final UserChecklist? currentChecklist;

  const ChecklistSaving({this.currentChecklist});

  @override
  List<Object?> get props => [currentChecklist];
}

/// State when checklist is cleared
class ChecklistCleared extends ChecklistState {
  const ChecklistCleared();
}
