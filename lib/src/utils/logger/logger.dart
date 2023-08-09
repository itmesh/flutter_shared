import 'package:chalkdart/chalk.dart';
import 'package:rxdart/rxdart.dart';

import '_logger.dart';
import 'logger_instance.dart';

class Logger {
  Logger(this.className);

  static LoggerLevel _level = LoggerLevel.warning;

  final String className;
  final LoggerInstance _loggerInstance = LoggerInstance();

  final BehaviorSubject<UserError?> _userErrorState$ = BehaviorSubject<UserError?>.seeded(null);

  Stream<UserError?> get userErrorState {
    return _userErrorState$;
  }

  Future<void> dispose() async {
    await _userErrorState$.close();
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    UserError? userError,
  }) {
    if (_level.level > LoggerLevel.error.level) {
      return;
    }

    if (userError != null) {
      _userErrorState$.add(userError);
    }

    _loggerInstance.log(
      level: LoggerLevel.error,
      message: chalk.red.bold('🛑 $message'),
      tag: className,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void warning(String message) {
    if (_level.level > LoggerLevel.warning.level) {
      return;
    }

    _loggerInstance.log(
      level: LoggerLevel.warning,
      message: chalk.yellow('⚠️ $message'),
      tag: className,
      error: null,
      stackTrace: null,
    );
  }

  void info(String message) {
    if (_level.level > LoggerLevel.info.level) {
      return;
    }

    _loggerInstance.log(
      level: LoggerLevel.info,
      message: chalk.blue('ℹ️ $message'),
      tag: className,
      error: null,
      stackTrace: null,
    );
  }

  void routeChange(String message) {
    _loggerInstance.log(
      level: LoggerLevel.info,
      message: chalk.green('🚦 $message'),
      tag: className,
      error: null,
      stackTrace: null,
    );
  }

  Future<String> getSavedLogs() async {
    return _loggerInstance.getSavedLogs();
  }

  Future<void> setSaveErrorToFileAgreement(bool agreement) async {
    await _loggerInstance.setSaveErrorToFileAgreement(agreement);
  }

  // Use this method to set the log level for the entire app.
  // Use it in the main.dart file.
  static void setLevel(LoggerLevel level) {
    _level = level;
  }
}
