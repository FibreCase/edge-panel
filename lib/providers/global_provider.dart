import 'package:flutter/material.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';
import 'package:edge_panel/services/realtime_socket_service.dart';
import 'package:edge_panel/utils/logger.dart';
import 'dart:async';

class GlobalProvider extends ChangeNotifier {
  late Color _themeColor;
  late bool _isDarkMode;
  late Timer _timer;
  late Timer? _socketCheckTimer;
  bool _isSocketConnected = false;

  GlobalProvider() {
    final now = DateTime.now();
    _themeColor = _updateThemeColor(now);
    _isDarkMode = _updateDarkMode(now);

    _startTimer();
    _initializeSocket();
  }

  Color get themeColor => _themeColor;
  bool get isDarkMode => _isDarkMode;
  bool get isSocketConnected => _isSocketConnected;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      _themeColor = _updateThemeColor(now);
      _isDarkMode = _updateDarkMode(now);

      notifyListeners();
    });
  }

  Color _updateThemeColor(DateTime dateTime) {
    final double hue = (dateTime.minute) / 60.0 * 360.0;
    return HSLColor.fromAHSL(
      1.0, // Alpha (透明度)
      hue, // Hue (色相)
      0.7, // Saturation (饱和度)
      0.5, // Lightness (亮度)
    ).toColor();
  }

  bool _updateDarkMode(DateTime dateTime) {
    var sunriseSunset = getSunriseSunset(
      40.09,
      116.31,
      Duration(hours: 8),
      dateTime,
    );

    sunriseSunset.sunrise = sunriseSunset.sunrise.subtract(
      const Duration(hours: 8),
    );
    sunriseSunset.sunset = sunriseSunset.sunset.subtract(
      const Duration(hours: 8),
    );

    return dateTime.isAfter(sunriseSunset.sunset) ||
        dateTime.isBefore(sunriseSunset.sunrise);
  }

  void _initializeSocket() {
    final socketService = RealtimeSocketService.instance;

    // 先尝试连接一次
    socketService
        .connect()
        .then((_) {
          log.i('Socket connection completed');
          _updateSocketConnectedStatus(true);
        })
        .catchError((error) {
          log.e('Socket connection error: $error');
          _updateSocketConnectedStatus(false);
        });

    // 定期检查Socket连接状态
    _socketCheckTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      socketService
          .connect()
          .then((_) {
            _updateSocketConnectedStatus(true);
          })
          .catchError((error) {
            _updateSocketConnectedStatus(false);
          });
    });
  }

  void _updateSocketConnectedStatus(bool connected) {
    if (_isSocketConnected != connected) {
      _isSocketConnected = connected;
      log.i('Socket connection status changed to: $connected');
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _socketCheckTimer?.cancel();
    super.dispose();
  }
}
