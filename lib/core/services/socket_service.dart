import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/constants/api_constants.dart';
import '../../features/auth/data/datasources/local/auth_local_datasource.dart';
import '../../injection/injection.dart';

/// Socket.IO service for real-time messaging
class SocketService {
  IO.Socket? _socket;
  
  /// Callback for new messages
  Function(Map<String, dynamic>)? onNewMessage;
  
  /// Callback for message errors
  Function(String)? onMessageError;
  
  /// Connect to Socket.IO server
  void connect() {
    if (_socket?.connected ?? false) {
      return; // Already connected
    }

    // Get auth token
    final authLocalDataSource = sl<AuthLocalDataSource>();
    final token = authLocalDataSource.getToken();

    _socket = IO.io(
      ApiConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setReconnectionAttempts(5)
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket?.onConnect((_) {
      print('✅ Socket.IO connected');
    });

    _socket?.on('newMessage', (data) {
      print('📩 New message received: $data');
      onNewMessage?.call(data as Map<String, dynamic>);
    });

    _socket?.on('messageError', (data) {
      print('❌ Message error: $data');
      final error = data is Map ? data['message'] as String? : data.toString();
      onMessageError?.call(error ?? 'Failed to send message');
    });

    _socket?.onDisconnect((_) {
      print('❌ Socket.IO disconnected');
    });

    _socket?.onConnectError((error) {
      print('❌ Socket.IO connection error: $error');
    });

    _socket?.onError((error) {
      print('❌ Socket.IO error: $error');
    });
  }

  /// Join a group chat room
  void joinGroup(String groupId) {
    if (_socket?.connected ?? false) {
      _socket?.emit('joinGroup', groupId);
      print('👥 Joined group: $groupId');
    } else {
      print('❌ Cannot join group - socket not connected');
    }
  }

  /// Leave a group chat room
  void leaveGroup(String groupId) {
    if (_socket?.connected ?? false) {
      _socket?.emit('leaveGroup', groupId);
      print('👋 Left group: $groupId');
    }
  }

  /// Send a message to a group
  void sendMessage({
    required String groupId,
    required String senderId,
    required String text,
  }) {
    if (_socket?.connected ?? false) {
      _socket?.emit('sendMessage', {
        'groupId': groupId,
        'senderId': senderId,
        'text': text,
      });
      print('📤 Message sent to group $groupId: $text');
    } else {
      print('❌ Cannot send message - socket not connected');
      onMessageError?.call('Not connected to chat server');
    }
  }

  /// Disconnect from Socket.IO server
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    print('🔌 Socket.IO disconnected');
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;
}
