import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';
import 'dart:async';

class GlobalProvider extends ChangeNotifier {
  late Color _themeColor;
  late bool _isDarkMode;
  late Timer _timer;

  GlobalProvider() {
    final now = DateTime.now();
    _themeColor = _updateThemeColor(now);
    _isDarkMode = _updateDarkMode(now);

    _startTimer();
  }

  Color get themeColor => _themeColor;
  bool get isDarkMode => _isDarkMode;

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
      Duration(hours: 0), // 此处UTC处理可能不当，导致早上切换时间不准确
      dateTime,
    );

    return dateTime.isAfter(sunriseSunset.sunset) ||
        dateTime.isBefore(sunriseSunset.sunrise);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
