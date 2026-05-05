import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_desktop_panel/utils/logger.dart';
import 'package:flutter_desktop_panel/services/realtime_socket_service.dart';

class WeatherProvider extends ChangeNotifier {
  late String _currentWeather;
  late String _currentTemperature;
  late String _currentWeatherIconPath;
  late String _currentTextNotification;
  late bool _isWarningColor;
  late int _currentAqi;
  late String _currentAqiCategory;
  late Color _currentAqiColor;
  late Color _currentAqiFrontColor;

  late Timer _timer;

  WeatherProvider() {
    _currentWeather = 'Unknown';
    _currentTemperature = 'N/A';
    _currentWeatherIconPath = 'assets/weather-icons/100-fill.svg';
    _currentTextNotification = '滚滚长江东逝水，浪花淘尽英雄。是非成败转头空。青山依旧在，几度夕阳红。';
    _isWarningColor = true;
    _currentAqi = 1000;
    _currentAqiCategory = 'N/A';
    _currentAqiColor = Color.fromARGB(255, 255, 255, 255);
    _currentAqiFrontColor = Color.fromARGB(255, 0, 0, 0);

    _initWeather();

    _startTimer();
  }

  Future<void> _initWeather() async {
    final response = await _fetchData();
    _refreshWeather(response);
  }

  String get currentWeather => _currentWeather;
  String get currentTemperature => _currentTemperature;
  String get currentWeatherIconPath => _currentWeatherIconPath;
  String get currentTextNotification => _currentTextNotification;
  bool get isWarningColor => _isWarningColor;
  int get currentAqi => _currentAqi;
  String get currentAqiCategory => _currentAqiCategory;
  Color get currentAqiColor => _currentAqiColor;
  Color get currentAqiFrontColor => _currentAqiFrontColor;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      final response = await _fetchData();
      _refreshWeather(response);
    });
  }

  Future<dynamic> _fetchData() async {
    try {
      return await RealtimeSocketService.instance.requestData(
        requestEvent: 'request_weather',
        responseEvent: 'weather_data',
      );
    } catch (e) {
      log.e('Error fetching weather data: $e');
      return null;
    }
  }

  void _refreshWeather(dynamic response) {
    if (response == null) {
      return;
    }

    final data = response as Map<String, dynamic>;
    final weather = data['weather']?.toString() ?? 'Unknown';
    final temperatureValue = data['temperature'];
    final temperature = temperatureValue != null
        ? '${temperatureValue}℃'
        : 'N/A';
    final iconPath = data['icon']?.toString() ?? '100';
    final textNotification = data['rain_notification']?.toString() ?? 'N/A';
    final aqi = int.tryParse(data['aqi']?.toString() ?? '') ?? 1000;
    final aqiCategory = data['aqi_category']?.toString() ?? 'N/A';

    _currentWeather = weather;
    _currentTemperature = temperature;
    _currentWeatherIconPath = _getWeatherIconPath(iconPath);
    _currentTextNotification = textNotification;
    _isWarningColor = _judgeWarningColor(textNotification, aqi.toString());
    _currentAqi = aqi;
    _currentAqiCategory = aqiCategory;
    _currentAqiColor = _refreshAqiColor(aqiCategory);
    _currentAqiFrontColor = _refreshAqiFrontColor(aqiCategory);

    notifyListeners();
  }

  String _getWeatherIconPath(String icon) {
    return 'assets/weather-icons/$icon-fill.svg';
  }

  bool _judgeWarningColor(String textNotification, String aqi) {
    if (textNotification == "未来两小时无降水" && int.parse(aqi) < 100) {
      return false;
    } else {
      return true;
    }
  }

  Color _refreshAqiColor(String aqiCategory) {
    switch (aqiCategory) {
      case '优':
        return Color.fromARGB(255, 0, 228, 0);
      case '良':
        return Color.fromARGB(255, 255, 255, 0);
      case '轻度污染':
        return Color.fromARGB(255, 255, 126, 0);
      case '中度污染':
        return Color.fromARGB(255, 255, 0, 0);
      case '重度污染':
        return Color.fromARGB(255, 153, 0, 76);
      case '严重污染':
        return Color.fromARGB(255, 126, 0, 35);
      default:
        return Color.fromARGB(255, 255, 255, 255);
    }
  }

  Color _refreshAqiFrontColor(String aqiCategory) {
    switch (aqiCategory) {
      case '优':
      case '良':
      case '轻度污染':
        return Color.fromARGB(255, 0, 0, 0);
      case '中度污染':
      case '重度污染':
      case '严重污染':
        return Color.fromARGB(255, 255, 255, 255);
      default:
        return Color.fromARGB(255, 0, 0, 0);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
