import 'package:chalkdart/chalk.dart';

import '_logger.dart';
import 'logger_instance.dart';

class Logger {
  Logger(this.className);

  static LoggerLevel _level = LoggerLevel.warning;

  final String className;
  final LoggerInstance _loggerInstance = LoggerInstance();

  Stream<UserError?> get userErrorState {
    return _loggerInstance.userErrorState;
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

    _loggerInstance.log(
      level: LoggerLevel.error,
      message: chalk.red.bold('🛑 $message'),
      tag: className,
      error: error,
      stackTrace: stackTrace,
      userError: userError,
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

  Future<bool> getSaveErrorToFileAgreement() async {
    return _loggerInstance.getSaveErrorToFileAgreement();
  }

  Future<void> setSaveErrorToFileAgreement(bool agreement) async {
    await _loggerInstance.setSaveErrorToFileAgreement(agreement);
  }

  Future<void> deleteLogs() async {
    await _loggerInstance.deleteLogs();
  }

  // Use this method to set the log level for the entire app.
  // Use it in the main.dart file.
  static void setLevel(LoggerLevel level) {
    _level = level;
  }
}
