import 'package:logging/logging.dart';

class MyLogger {
  final Logger _logger = Logger('MyLogger');

  void log(String message) {
    _logger.info(message);
  }
}
