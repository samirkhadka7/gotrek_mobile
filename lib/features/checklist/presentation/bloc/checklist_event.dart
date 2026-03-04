import 'package:equatable/equatable.dart';

import '../../domain/entities/checklist_entity.dart';

/// Base class for all checklist events
abstract class ChecklistEvent extends Equatable {
  const ChecklistEvent();

  @override
  List<Object?> get props => [];
}

/// Event to generate a new checklist
class GenerateChecklistEvent extends ChecklistEvent {
  final HikerExperience experience;
  final TrekDuration duration;
  final WeatherCondition weather;

  const GenerateChecklistEvent({
    required this.experience,
    required this.duration,
    required this.weather,
  });

  @override
  List<Object?> get props => [experience, duration, weather];
}

/// Event to load user's saved checklist
class LoadChecklistEvent extends ChecklistEvent {
  const LoadChecklistEvent();
}

/// Event to save checklist
class SaveChecklistEvent extends ChecklistEvent {
  final List<ChecklistItem> items;
  final ChecklistConfig config;

  const SaveChecklistEvent({
    required this.items,
    required this.config,
  });

  @override
  List<Object?> get props => [items, config];
}

/// Event to toggle a checklist item
class ToggleChecklistItemEvent extends ChecklistEvent {
  final String itemId;
  final bool isChecked;

  const ToggleChecklistItemEvent({
    required this.itemId,
    required this.isChecked,
  });

  @override
  List<Object?> get props => [itemId, isChecked];
}

/// Event to toggle item locally (without API call)
class ToggleItemLocallyEvent extends ChecklistEvent {
  final String itemId;

  const ToggleItemLocallyEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

/// Event to clear checklist
class ClearChecklistEvent extends ChecklistEvent {
  const ClearChecklistEvent();
}

/// Event to update config selection
class UpdateConfigEvent extends ChecklistEvent {
  final HikerExperience? experience;
  final TrekDuration? duration;
  final WeatherCondition? weather;

  const UpdateConfigEvent({
    this.experience,
    this.duration,
    this.weather,
  });

  @override
  List<Object?> get props => [experience, duration, weather];
}

/// Event to accept generated checklist
class AcceptGeneratedChecklistEvent extends ChecklistEvent {
  final GeneratedChecklist generatedChecklist;
  final ChecklistConfig config;

  const AcceptGeneratedChecklistEvent({
    required this.generatedChecklist,
    required this.config,
  });

  @override
  List<Object?> get props => [generatedChecklist, config];
}
