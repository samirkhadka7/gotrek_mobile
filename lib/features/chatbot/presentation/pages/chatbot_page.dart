import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../injection/injection.dart';
import '../../domain/entities/chat_message.dart';
import '../bloc/chatbot_bloc.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/typing_indicator.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late final ChatbotBloc _chatbotBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatbotBloc = sl<ChatbotBloc>();
    _chatbotBloc.add(const AddWelcomeMessageEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _chatbotBloc.add(SendMessageEvent(message: message.trim()));
    _messageController.clear();

    // Scroll to bottom after message is sent
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear the chat history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _chatbotBloc.add(const ClearChatEvent());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _chatbotBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.go('/chat'),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TrailMate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  BlocBuilder<ChatbotBloc, ChatbotState>(
                    builder: (context, state) {
                      return Text(
                        state.isLoading ? 'Typing...' : 'AI Trekking Assistant',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: _clearChat,
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Clear Chat',
            ),
          ],
        ),
        body: Column(
          children: [
            // Chat Messages
            Expanded(
              child: BlocConsumer<ChatbotBloc, ChatbotState>(
                listener: (context, state) {
                  // Auto scroll on new messages
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _scrollToBottom();
                  });
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];

                      if (message.type == MessageType.loading) {
                        return const Padding(
                          padding: EdgeInsets.only(left: 8, bottom: 16),
                          child: TypingIndicator(),
                        );
                      }

                      return ChatBubble(
                        message: message,
                        onSuggestionTap: (suggestion) {
                          _sendMessage(suggestion.query);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Input Area
            ChatInput(
              controller: _messageController,
              onSend: _sendMessage,
              isLoading: _chatbotBloc.state.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
