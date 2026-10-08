import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:edge_panel/services/realtime_socket_service.dart';
import 'package:edge_panel/utils/logger.dart';

class SensorProvider extends ChangeNotifier {
  SensorProvider({Future<Map<String, dynamic>?> Function()? fetchData})
    : _fetchData = fetchData ?? _requestData {
    refresh();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => refresh());
  }

  final Future<Map<String, dynamic>?> Function() _fetchData;
  late final Timer _timer;
  bool _fetching = false;
  bool _disposed = false;
  String _temperature = '--';
  String _humidity = '--';
  String _eco2 = '--';

  String get temperature => _temperature;
  String get humidity => _humidity;
  String get eco2 => _eco2;

  static Future<Map<String, dynamic>?> _requestData() {
    return RealtimeSocketService.instance.requestData(
      requestEvent: 'request_sensor',
      responseEvent: 'sensor_data',
    );
  }

  static String _format(dynamic value, int decimals) {
    final number = value is num ? value : num.tryParse(value?.toString() ?? '');
    return number != null && number.isFinite
        ? number.toStringAsFixed(decimals)
        : '--';
  }

  Future<void> refresh() async {
    if (_fetching || _disposed) return;
    _fetching = true;
    Map<String, dynamic>? data;
    try {
      data = await _fetchData();
    } catch (error) {
      log.e('Error fetching sensor data: $error');
    } finally {
      _fetching = false;
    }
    if (_disposed) return;

    dynamic reading;
    if (data != null && data['status'] == 'ok') {
      reading = data['reading'];
    }
    _temperature = reading is Map ? _format(reading['temperature_c'], 1) : '--';
    _humidity = reading is Map ? _format(reading['humidity_rh_pct'], 1) : '--';
    _eco2 = reading is Map && reading['validity'] == 'normal'
        ? _format(reading['eco2_ppm'], 0)
        : '--';
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer.cancel();
    super.dispose();
  }
}
