import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edge_panel/services/realtime_socket_service.dart';
import 'package:edge_panel/widgets/message_card.dart';

class MessageProvider extends ChangeNotifier {
  late Widget _currentMessageWidget;
  late final void Function(dynamic data) _messageUpdatedHandler;
  static final Uri _messageApiUri = Uri.parse(
    'http://127.0.0.1:5000/api/messages',
  );
  static final Uri _messageApiBaseUri = _messageApiUri.replace(path: '/');

  MessageProvider() {
    _currentMessageWidget = const SizedBox.shrink();
    _messageUpdatedHandler = (_) {
      _fetchAndBuildMessages();
    };

    _initMessageStream();
  }

  Widget get currentMessageWidget => _currentMessageWidget;

  Future<void> _initMessageStream() async {
    await RealtimeSocketService.instance.onEvent(
      event: 'messages_updated',
      handler: _messageUpdatedHandler,
    );
    await _fetchAndBuildMessages();
  }

  Future<void> _fetchAndBuildMessages() async {
    try {
      final response = await http.get(_messageApiUri);
      if (response.statusCode != 200) {
        return;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final messagesRaw = decoded['messages'];
      if (messagesRaw is! List) {
        return;
      }

      final messages =
          messagesRaw
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
            ..sort((a, b) {
              final left = int.tryParse(b['id']?.toString() ?? '') ?? 0;
              final right = int.tryParse(a['id']?.toString() ?? '') ?? 0;
              return left.compareTo(right);
            });

      _currentMessageWidget = _buildMessageWidget(messages);

      notifyListeners();
    } catch (_) {
      return;
    }
  }

  Widget _buildMessageWidget(List<Map<String, dynamic>> messages) {
    if (messages.isEmpty) {
      return Builder(
        builder: (context) => MessageCard(
          colorScheme: Theme.of(context).colorScheme,
          type: 'idle',
          data: const ['暂无消息', 'Waiting'],
        ),
      );
    }

    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return Row(
          children: [
            for (int index = 0; index < messages.length; index++) ...[
              MessageCard(
                colorScheme: colorScheme,
                type: messages[index]['type']?.toString() ?? 'text',
                data: _buildCardData(messages[index]),
                onDoubleTap: () => _deleteMessage(
                  int.tryParse(messages[index]['id']?.toString() ?? '') ?? -1,
                ),
              ),
              if (index != messages.length - 1) const SizedBox(width: 24),
            ],
          ],
        );
      },
    );
  }

  dynamic _buildCardData(Map<String, dynamic> message) {
    final type = message['type']?.toString() ?? 'text';
    final content = message['content']?.toString() ?? '';

    if (type == 'image') {
      return _resolveImageUrl(content);
    }

    if (type == 'notify') {
      final sourceName = message['source_name']?.toString() ?? '';
      final createdAt = message['created_at']?.toString() ?? '';

      return [
        content,
        _formatMessageTime(createdAt),
        sourceName.isNotEmpty ? sourceName : '通知',
      ];
    }

    final createdAt = message['created_at']?.toString() ?? '';
    return [content, _formatMessageTime(createdAt)];
  }

  String _resolveImageUrl(String content) {
    if (content.startsWith('http://') || content.startsWith('https://')) {
      return content;
    }

    if (content.startsWith('/')) {
      return _messageApiBaseUri.resolve(content).toString();
    }

    return _messageApiBaseUri.resolve('/$content').toString();
  }

  String _formatMessageTime(String createdAt) {
    if (createdAt.isEmpty) {
      return '--:--, --- --';
    }

    final normalized = createdAt.contains('T')
        ? createdAt
        : createdAt.replaceFirst(' ', 'T');
    final parsed = DateTime.tryParse(normalized);
    if (parsed == null) {
      return '--:--, --- --';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '$hour:$minute, ${months[parsed.month - 1]} ${parsed.day}';
  }

  Future<Map<String, dynamic>?> sendCommand({
    required String command,
    required int id,
  }) {
    return RealtimeSocketService.instance.sendMessage(command: command, id: id);
  }

  Future<void> _deleteMessage(int messageId) async {
    if (messageId <= 0) {
      return;
    }

    try {
      final response = await http.delete(
        _messageApiUri.replace(path: '/api/messages/$messageId'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _fetchAndBuildMessages();
      }
    } catch (_) {
      return;
    }
  }

  @override
  void dispose() {
    RealtimeSocketService.instance.offEvent(
      event: 'messages_updated',
      handler: _messageUpdatedHandler,
    );
    super.dispose();
  }
}
