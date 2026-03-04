import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_chatbot_query.dart';

// Events
abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatbotEvent {
  final String message;

  const SendMessageEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

class ClearChatEvent extends ChatbotEvent {
  const ClearChatEvent();
}

class AddWelcomeMessageEvent extends ChatbotEvent {
  const AddWelcomeMessageEvent();
}

// State
class ChatbotState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatbotState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}

// BLoC
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendChatbotQueryUseCase sendChatbotQueryUseCase;
  final _uuid = const Uuid();

  ChatbotBloc({
    required this.sendChatbotQueryUseCase,
  }) : super(const ChatbotState()) {
    on<AddWelcomeMessageEvent>(_onAddWelcomeMessage);
    on<SendMessageEvent>(_onSendMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  void _onAddWelcomeMessage(
    AddWelcomeMessageEvent event,
    Emitter<ChatbotState> emit,
  ) {
    final welcomeMessage = ChatMessage(
      id: _uuid.v4(),
      content: '''👋 Namaste! I'm **TrailMate**, your AI trekking assistant.

I can help you with:
• 🏔️ Finding the perfect trek in Nepal
• 📋 Packing lists and preparation tips
• ⛰️ Altitude sickness prevention
• 🗓️ Best seasons for trekking
• 👥 Finding trekking groups

What would you like to know?''',
      type: MessageType.bot,
      timestamp: DateTime.now(),
      suggestedActions: QuickSuggestions.defaultSuggestions,
    );

    emit(state.copyWith(messages: [welcomeMessage]));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: event.message,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    final loadingMessage = ChatMessage(
      id: _uuid.v4(),
      content: '',
      type: MessageType.loading,
      timestamp: DateTime.now(),
    );

    // Add user message and loading indicator
    emit(state.copyWith(
      messages: [...state.messages, userMessage, loadingMessage],
      isLoading: true,
      error: null,
    ));

    final result = await sendChatbotQueryUseCase(
      SendChatbotQueryParams(query: event.message),
    );

    result.fold(
      (failure) {
        // Remove loading message and add error message
        final updatedMessages = state.messages
            .where((m) => m.type != MessageType.loading)
            .toList();

        final errorMessage = ChatMessage(
          id: _uuid.v4(),
          content: failure.message,
          type: MessageType.bot,
          timestamp: DateTime.now(),
          isError: true,
        );

        emit(state.copyWith(
          messages: [...updatedMessages, errorMessage],
          isLoading: false,
          error: failure.message,
        ));
      },
      (response) {
        // Remove loading message and add bot response
        final updatedMessages = state.messages
            .where((m) => m.type != MessageType.loading)
            .toList();

        final botMessage = ChatMessage(
          id: _uuid.v4(),
          content: response,
          type: MessageType.bot,
          timestamp: DateTime.now(),
          suggestedActions: QuickSuggestions.followUpSuggestions,
        );

        emit(state.copyWith(
          messages: [...updatedMessages, botMessage],
          isLoading: false,
          error: null,
        ));
      },
    );
  }

  void _onClearChat(
    ClearChatEvent event,
    Emitter<ChatbotState> emit,
  ) {
    emit(const ChatbotState());
    add(const AddWelcomeMessageEvent());
  }
}
