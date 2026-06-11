import 'dart:async';

import 'package:edge_panel/utils/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class RealtimeSocketService {
  RealtimeSocketService._();

  static final RealtimeSocketService instance = RealtimeSocketService._();

  static const String _serverUrl = 'http://127.0.0.1:5000';

  io.Socket? _socket;
  Completer<void>? _connectCompleter;
  bool _handlersRegistered = false;

  io.Socket _ensureSocket() {
    _socket ??= io.io(
      _serverUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );

    if (!_handlersRegistered) {
      _socket!.onConnect((_) {
        log.i('Socket.IO connected');
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.complete();
        }
        _connectCompleter = null;
      });

      _socket!.onDisconnect((_) {
        log.i('Socket.IO disconnected');
      });

      _socket!.onConnectError((error) {
        log.e('Socket.IO connect error: $error');
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.completeError(error);
        }
        _connectCompleter = null;
      });

      _handlersRegistered = true;
    }

    return _socket!;
  }

  Future<void> connect() async {
    final socket = _ensureSocket();

    if (socket.connected) {
      return;
    }

    if (_connectCompleter != null) {
      return _connectCompleter!.future;
    }

    _connectCompleter = Completer<void>();
    socket.connect();

    return _connectCompleter!.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.complete();
        }
        _connectCompleter = null;
      },
    );
  }

  Future<Map<String, dynamic>?> requestData({
    required String requestEvent,
    required String responseEvent,
  }) async {
    try {
      await connect();
      final socket = _ensureSocket();
      final completer = Completer<Map<String, dynamic>?>();

      socket.once(responseEvent, (dynamic data) {
        if (!completer.isCompleted) {
          completer.complete(_asMap(data));
        }
      });

      socket.emit(requestEvent);

      return completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
    } catch (error) {
      log.e('Socket.IO request failed for $requestEvent: $error');
      return null;
    }
  }

  Future<Map<String, dynamic>?> sendMessage({
    required String command,
    required int id,
  }) async {
    try {
      await connect();
      final socket = _ensureSocket();
      final completer = Completer<Map<String, dynamic>?>();

      socket.once('message_received', (dynamic data) {
        if (!completer.isCompleted) {
          completer.complete(_asMap(data));
        }
      });

      socket.emit('send_message', <String, dynamic>{
        'command': command,
        'id': id,
      });

      return completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
    } catch (error) {
      log.e('Socket.IO message send failed: $error');
      return null;
    }
  }

  Future<void> onEvent({
    required String event,
    required void Function(dynamic data) handler,
  }) async {
    await connect();
    _ensureSocket().on(event, handler);
  }

  void offEvent({required String event, void Function(dynamic data)? handler}) {
    final socket = _socket;
    if (socket == null) {
      return;
    }
    socket.off(event, handler);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return <String, dynamic>{};
  }
}
