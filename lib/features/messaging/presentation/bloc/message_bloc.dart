import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/socket_service.dart';
import '../../data/models/message_model.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_by_group.dart';
import 'message_event.dart';
import 'message_state.dart';

/// BLoC for managing message operations
class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesByGroup getMessagesByGroup;
  final SocketService socketService;

  MessageBloc({
    required this.getMessagesByGroup,
    required this.socketService,
  }) : super(const MessageInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<JoinGroupChatEvent>(_onJoinGroupChat);
    on<LeaveGroupChatEvent>(_onLeaveGroupChat);
    on<ClearMessagesEvent>(_onClearMessages);
    on<MessageErrorEvent>(_onMessageError);

    // Setup socket listeners
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    // Connect to socket
    socketService.connect();

    // Listen for new messages
    socketService.onNewMessage = (data) {
      try {
        // Parse the socket message using MessageModel
        final message = MessageModel.fromJson(data).toEntity();
        add(MessageReceivedEvent(message: message));
      } catch (e) {
        print('Error parsing new message: $e');
      }
    };

    // Listen for message errors
    socketService.onMessageError = (error) {
      print('Message error: $error');
      add(MessageErrorEvent(error: error));
    };
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<MessageState> emit,
  ) async {
    emit(const MessageLoading());

    final result = await getMessagesByGroup(event.groupId);

    result.fold(
      (failure) => emit(MessageError(message: failure.message)),
      (messages) => emit(MessageLoaded(
        messages: messages,
        groupId: event.groupId,
      )),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final currentState = state;
    if (currentState is! MessageLoaded) {
      print('Cannot send message - not in loaded state');
      return;
    }

    // Create optimistic message to show immediately
    final optimisticMessage = MessageEntity(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      groupId: event.groupId,
      sender: MessageSender(
        id: event.senderId,
        name: event.senderName,
        profileImage: event.senderProfileImage,
      ),
      content: event.content,
      createdAt: DateTime.now(),
    );

    // Add optimistic message to UI immediately
    final updatedMessages = List<MessageEntity>.from(currentState.messages)
      ..add(optimisticMessage);
    emit(currentState.copyWith(messages: updatedMessages));

    // Send via Socket.IO (server will broadcast back to all clients)
    socketService.sendMessage(
      groupId: event.groupId,
      senderId: event.senderId,
      text: event.content,
    );
  }

  void _onMessageReceived(
    MessageReceivedEvent event,
    Emitter<MessageState> emit,
  ) {
    final currentState = state;
    if (currentState is MessageLoaded) {
      // Remove any temporary message with same content from same sender
      // (this handles the case where we added an optimistic message)
      final filteredMessages = currentState.messages.where((msg) {
        final isTemp = msg.id.startsWith('temp_');
        final isSameSender = msg.sender.id == event.message.sender.id;
        final isSameContent = msg.content == event.message.content;
        final isRecent = DateTime.now().difference(msg.createdAt).inSeconds < 5;
        
        // Keep the message unless it's a temp message with same content from same sender
        return !(isTemp && isSameSender && isSameContent && isRecent);
      }).toList();

      final updatedMessages = List<MessageEntity>.from(filteredMessages)
        ..add(event.message);
      emit(currentState.copyWith(messages: updatedMessages));
    }
  }

  void _onJoinGroupChat(
    JoinGroupChatEvent event,
    Emitter<MessageState> emit,
  ) {
    // Join the socket room
    socketService.joinGroup(event.groupId);
    // Load existing messages
    add(LoadMessagesEvent(groupId: event.groupId));
  }

  void _onLeaveGroupChat(
    LeaveGroupChatEvent event,
    Emitter<MessageState> emit,
  ) {
    // Leave the socket room
    socketService.leaveGroup(event.groupId);
  }

  void _onClearMessages(
    ClearMessagesEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(const MessageInitial());
  }

  void _onMessageError(
    MessageErrorEvent event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageError(message: event.error));
  }
}
