import 'package:flutter/foundation.dart';
import 'dart:async';

class TimeProvider extends ChangeNotifier {
  late String _currentTime;
  late String _currentDate;
  Timer? _timeTimer;
  Timer? _dateTimer;

  TimeProvider() {
    final now = DateTime.now();
    _currentTime = _formatTime(now);
    _currentDate = _formatDate(now);
    _startTimeTimer();
    _startDateTimer();
  }

  String get currentTime => _currentTime;
  String get currentDate => _currentDate;

  void _startTimeTimer() {
    final now = DateTime.now();
    final elapsedMicrosecondsInSecond =
        now.microsecond + (now.millisecond * 1000);
    final delayToNextSecond = Duration(
      microseconds: 1000000 - elapsedMicrosecondsInSecond,
    );

    _timeTimer?.cancel();
    _timeTimer = Timer(delayToNextSecond, () {
      _updateTime();
      _timeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateTime();
      });
    });
  }

  void _startDateTimer() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final delayToMidnight = nextMidnight.difference(now);

    _dateTimer?.cancel();
    _dateTimer = Timer(delayToMidnight, () {
      _updateDate();
      _dateTimer = Timer.periodic(const Duration(days: 1), (_) {
        _updateDate();
      });
    });
  }

  void _updateTime() {
    _currentTime = _formatTime(DateTime.now());
    notifyListeners();
  }

  void _updateDate() {
    _currentDate = _formatDate(DateTime.now());
    notifyListeners();
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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

    final weekDay = weekDays[dateTime.weekday - 1];
    final month = months[dateTime.month - 1];
    return '$weekDay $month ${dateTime.day}';
  }

  @override
  void dispose() {
    _timeTimer?.cancel();
    _dateTimer?.cancel();
    super.dispose();
  }
}
