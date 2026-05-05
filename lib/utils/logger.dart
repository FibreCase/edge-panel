import 'package:logger/logger.dart';

/// Global logger instance for the application
final log = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
  ),
  level: Level.all,
);
