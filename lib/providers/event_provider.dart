import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:flutter_desktop_panel/utils/logger.dart';
import 'package:flutter_desktop_panel/services/realtime_socket_service.dart';

class EventProvider extends ChangeNotifier {
  late String _nextEventName;
  late String _nextEventTime;
  late String _nextEventDate;
  late String _nextEventLocation;

  late Timer _timer;

  EventProvider() {
    _nextEventName = "风力发电场电气设计";
    _nextEventTime = "00:00";
    _nextEventDate = "N/A";
    _nextEventLocation = "主楼B412";

    _fetchNextEvent();

    _startTimer();
  }

  String get nextEventName => _nextEventName;
  String get nextEventTime => _nextEventTime;
  String get nextEventDate => _nextEventDate;
  String get nextEventLocation => _nextEventLocation;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _fetchNextEvent();
    });
  }

  Future<void> _fetchNextEvent() async {
    try {
      final data = await RealtimeSocketService.instance.requestData(
        requestEvent: 'request_event',
        responseEvent: 'event_data',
      );

      if (data != null) {
        _nextEventName = data['name']?.toString() ?? "Unknown Event";
        _nextEventTime = data['time']?.toString() ?? "N/A";
        _nextEventDate = _formatDate(data['date']?.toString() ?? "N/A");
        _nextEventLocation = data['location']?.toString() ?? "N/A";
        notifyListeners();
      }
    } catch (e) {
      log.e('Error fetching event data: $e');
    }
  }

  String _formatDate(String dateStr) {
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

    if (dateStr == "N/A") {
      return dateStr;
    }
    try {
      DateTime eventDate = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      final month = months[eventDate.month - 1];

      return eventDate.year == now.year &&
              eventDate.month == now.month &&
              eventDate.day == now.day
          ? "Today"
          : '$month ${eventDate.day}';
    } catch (e) {
      log.e('Error parsing event date: $e');
      return "N/A";
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
