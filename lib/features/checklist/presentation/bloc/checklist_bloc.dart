import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/checklist_entity.dart';
import '../../domain/usecases/clear_checklist.dart';
import '../../domain/usecases/generate_checklist.dart';
import '../../domain/usecases/get_my_checklist.dart';
import '../../domain/usecases/save_checklist.dart';
import '../../domain/usecases/update_checklist_item.dart';
import '../../../../core/usecases/usecase.dart';
import 'checklist_event.dart';
import 'checklist_state.dart';

/// BLoC for handling checklist operations
class ChecklistBloc extends Bloc<ChecklistEvent, ChecklistState> {
  final GenerateChecklistUseCase generateChecklistUseCase;
  final GetMyChecklistUseCase getMyChecklistUseCase;
  final SaveChecklistUseCase saveChecklistUseCase;
  final UpdateChecklistItemUseCase updateChecklistItemUseCase;
  final ClearChecklistUseCase clearChecklistUseCase;

  ChecklistBloc({
    required this.generateChecklistUseCase,
    required this.getMyChecklistUseCase,
    required this.saveChecklistUseCase,
    required this.updateChecklistItemUseCase,
    required this.clearChecklistUseCase,
  }) : super(const ChecklistInitial()) {
    on<LoadChecklistEvent>(_onLoadChecklist);
    on<GenerateChecklistEvent>(_onGenerateChecklist);
    on<SaveChecklistEvent>(_onSaveChecklist);
    on<ToggleChecklistItemEvent>(_onToggleItem);
    on<ToggleItemLocallyEvent>(_onToggleItemLocally);
    on<ClearChecklistEvent>(_onClearChecklist);
    on<UpdateConfigEvent>(_onUpdateConfig);
    on<AcceptGeneratedChecklistEvent>(_onAcceptGeneratedChecklist);
  }

  /// Load user's saved checklist
  Future<void> _onLoadChecklist(
    LoadChecklistEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading(message: 'Loading your checklist...'));

    final result = await getMyChecklistUseCase(const NoParams());

    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (checklist) {
        if (checklist != null && checklist.items.isNotEmpty) {
          emit(ChecklistLoaded(checklist));
        } else {
          emit(const ChecklistConfiguring());
        }
      },
    );
  }

  /// Generate new checklist based on config
  Future<void> _onGenerateChecklist(
    GenerateChecklistEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    final config = ChecklistConfig(
      experience: event.experience,
      duration: event.duration,
      weather: event.weather,
    );

    emit(const ChecklistLoading(message: 'Generating your checklist...'));

    final result = await generateChecklistUseCase(config);

    result.fold(
      (failure) => emit(ChecklistError(
        message: failure.message,
        lastConfig: config,
      )),
      (generatedChecklist) => emit(ChecklistGenerated(
        generatedChecklist: generatedChecklist,
        config: config,
      )),
    );
  }

  /// Save checklist
  Future<void> _onSaveChecklist(
    SaveChecklistEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    final currentState = state;
    UserChecklist? currentChecklist;
    if (currentState is ChecklistLoaded) {
      currentChecklist = currentState.checklist;
    }

    emit(ChecklistSaving(currentChecklist: currentChecklist));

    final result = await saveChecklistUseCase(SaveChecklistParams(
      items: event.items,
      config: event.config,
    ));

    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (checklist) => emit(ChecklistLoaded(checklist)),
    );
  }

  /// Toggle checklist item via API
  Future<void> _onToggleItem(
    ToggleChecklistItemEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ChecklistLoaded) return;

    // Optimistically update the UI
    final updatedItems = currentState.checklist.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isChecked: event.isChecked);
      }
      return item;
    }).toList();

    final optimisticChecklist = UserChecklist(
      items: updatedItems,
      config: currentState.checklist.config,
      updatedAt: DateTime.now(),
    );

    emit(ChecklistLoaded(optimisticChecklist));

    // Update via API
    final result = await updateChecklistItemUseCase(UpdateChecklistItemParams(
      itemId: event.itemId,
      isChecked: event.isChecked,
    ));

    result.fold(
      (failure) {
        // Revert on failure
        emit(ChecklistLoaded(currentState.checklist));
      },
      (checklist) => emit(ChecklistLoaded(checklist)),
    );
  }

  /// Toggle item locally without API call
  void _onToggleItemLocally(
    ToggleItemLocallyEvent event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is! ChecklistLoaded) return;

    final updatedItems = currentState.checklist.items.map((item) {
      if (item.id == event.itemId) {
        return item.copyWith(isChecked: !item.isChecked);
      }
      return item;
    }).toList();

    final updatedChecklist = UserChecklist(
      items: updatedItems,
      config: currentState.checklist.config,
      updatedAt: DateTime.now(),
    );

    emit(ChecklistLoaded(updatedChecklist));
  }

  /// Clear checklist
  Future<void> _onClearChecklist(
    ClearChecklistEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading(message: 'Clearing checklist...'));

    final result = await clearChecklistUseCase(const NoParams());

    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (_) => emit(const ChecklistConfiguring()),
    );
  }

  /// Update config during configuration
  void _onUpdateConfig(
    UpdateConfigEvent event,
    Emitter<ChecklistState> emit,
  ) {
    final currentState = state;
    if (currentState is ChecklistConfiguring) {
      emit(currentState.copyWith(
        experience: event.experience,
        duration: event.duration,
        weather: event.weather,
      ));
    } else if (currentState is ChecklistEmpty) {
      emit(ChecklistConfiguring(
        config: ChecklistConfig(
          experience: event.experience ?? currentState.config.experience,
          duration: event.duration ?? currentState.config.duration,
          weather: event.weather ?? currentState.config.weather,
        ),
      ));
    }
  }

  /// Accept generated checklist and save
  Future<void> _onAcceptGeneratedChecklist(
    AcceptGeneratedChecklistEvent event,
    Emitter<ChecklistState> emit,
  ) async {
    emit(const ChecklistLoading(message: 'Saving your checklist...'));

    final items = event.generatedChecklist.toChecklistItems();

    final result = await saveChecklistUseCase(SaveChecklistParams(
      items: items,
      config: event.config,
    ));

    result.fold(
      (failure) => emit(ChecklistError(message: failure.message)),
      (checklist) => emit(ChecklistLoaded(checklist)),
    );
  }
}
