import 'package:flutter/foundation.dart';
import 'package:edge_panel/utils/logger.dart';

class ActionButtonProvider extends ChangeNotifier {
  bool _isDarkModeSelected = false;

  String get buttonText =>
      _isDarkModeSelected ? 'Switch to Light Mode' : 'Switch to Dark Mode';

  void handlePressed() {
    log.i('Home page button pressed');
    _isDarkModeSelected = !_isDarkModeSelected;
    notifyListeners();
    // TODO: 在这里通知 Python 后端，由后端调用目标 API。
  }
}
