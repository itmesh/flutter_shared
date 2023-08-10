import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:itmesh_flutter_shared/flutter_shared.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '_logger.dart';

class LoggerInstance {
  factory LoggerInstance() {
    return _instance ??= LoggerInstance._();
  }

  LoggerInstance._();

  static LoggerInstance? _instance;
  final PublishSubject<UserError?> _userErrorState$ = PublishSubject<UserError?>();

  Stream<UserError?> get userErrorState {
    return _userErrorState$;
  }

  Future<void> dispose() async {
    await _userErrorState$.close();
  }

  static const String _logsKey = 'logger/logs';
  static const String _saveErrorAgreementKey = 'logger/save_error_agreement';
  static const int _maxLogfileLines = 10000;

  @Deprecated('Use getSharedPreferences instead.')
  SharedPreferences? _sharedPreferences;

  void log({
    required LoggerLevel level,
    required String tag,
    required String message,
    required Object? error,
    required StackTrace? stackTrace,
    UserError? userError,
  }) {
    if (userError != null) {
      _userErrorState$.add(userError);
    }

    final String date = DateTime.now().readableTime;
    message = '$date [$tag] $message';

    if (!kDebugMode && level == LoggerLevel.error && error != null) {
      _sendLogsToCrashlytics(message, error, stackTrace);
    }

    if (error != null) {
      message += '\nerror: $error';
    }

    if (stackTrace != null) {
      message += '\nstackTrace: $stackTrace';
    }

    _saveLogToFile(message);

    // ignore: avoid_print
    print(message);
  }

  Future<String> getSavedLogs() async {
    final SharedPreferences sharedPreferences = await _getSharedPreferences();
    final List<String> rows = sharedPreferences.getStringList(_logsKey) ?? <String>[];

    return rows.join('\n');
  }

  Future<void> deleteLogs() async {
    final SharedPreferences sharedPreferences = await _getSharedPreferences();
    await sharedPreferences.remove(_logsKey);
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    // ignore: deprecated_member_use_from_same_package
    return _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<void> setSaveErrorToFileAgreement(bool agreement) async {
    final SharedPreferences sharedPreferences = await _getSharedPreferences();

    await sharedPreferences.setBool(_saveErrorAgreementKey, agreement);
  }

  Future<void> _saveLogToFile(String message) async {
    final SharedPreferences sharedPreferences = await _getSharedPreferences();

    final bool? agreement = sharedPreferences.getBool(_saveErrorAgreementKey);
    if (agreement != true) {
      return;
    }

    final List<String> rows = sharedPreferences.getStringList(_logsKey) ?? <String>[];
    rows.insert(0, message);

    if (rows.length > _maxLogfileLines) {
      rows.removeLast();
    }

    await sharedPreferences.setStringList(_logsKey, rows);
  }

  Future<void> _sendLogsToCrashlytics(String message, Object error, StackTrace? stackTrace) async {
    if (kIsWeb) {
      return;
    }

    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: message,
      fatal: true,
    );
  }
}
