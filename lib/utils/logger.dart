import 'package:logging/logging.dart';

class MyLogger {
    final _logger = Logger('MyLogger');

    void log(String message) {
        _logger.info(message);
    }
}
