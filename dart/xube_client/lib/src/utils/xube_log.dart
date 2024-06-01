import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class XubeLogLevel {
  static const int debug = 300;
  static const int info = 500;
  static const int warning = 900;
  static const int error = 1000;
  static const int critical = 2000;
  static const int emergency = 3000;
}

class XubeLog {
  static XubeLog? _instance;
  int _minimumPrintLevel = XubeLogLevel.debug;
  int _minimumSendDiagnosticsLevel = XubeLogLevel.critical;
  String? _platformDiagnosticsUrl;
  String? _applicationVersion;

  XubeLog._internal();

  initialize({
    required String applicationVersion,
    required String platformDiagnosticsUrl,
    required int minimumPrintLevel,
    required int minimumSendDiagnosticsLevel,
  }) {
    _applicationVersion = applicationVersion;
    _platformDiagnosticsUrl = platformDiagnosticsUrl;
    _minimumPrintLevel = minimumPrintLevel;
    _minimumSendDiagnosticsLevel = minimumSendDiagnosticsLevel;
  }

  factory XubeLog.getInstance() {
    return _instance ??= XubeLog._internal();
  }

  void setMinimumPrintLevel(int level) {
    _minimumPrintLevel = level;
  }

  void setMinimumSendDiagnosticsLevel(int level) {
    _minimumSendDiagnosticsLevel = level;
  }

  void log(String message, {int level = XubeLogLevel.info, Object? error}) {
    if (level >= _minimumPrintLevel) {
      DateTime now = DateTime.now();
      developer.log(
        '${now.toIso8601String()}: Level: $level, Message: $message',
        level: level,
        time: now,
        error: error,
      );
    }
    if (level >= _minimumSendDiagnosticsLevel) {
      _sendToBackend(level, message);
    }
  }

  void info(String message) {
    log(message, level: XubeLogLevel.info);
  }

  void warning(String message, {Object? error}) {
    log(message, level: XubeLogLevel.warning, error: error);
  }

  void error(String message, {Object? error}) {
    log(message, level: XubeLogLevel.error, error: error);
  }

  void critical(String message, {Object? error}) {
    log(message, level: XubeLogLevel.critical, error: error);
  }

  Future<void> _sendToBackend(
    int level,
    String message, {
    Object? error,
  }) async {
    String? platformDiagnosticsPath = _platformDiagnosticsUrl;
    if (platformDiagnosticsPath == null) {
      developer.log('Platform diagnostics url not set',
          level: XubeLogLevel.warning);
      return;
    }

    var diagnostics = {
      'level': level,
      'message': message,
      'origin': 'app',
      'version': _applicationVersion,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (error != null) {
      diagnostics['error'] = error.toString();
    }

    try {
      Response response = await GetIt.I<Dio>().post(
        platformDiagnosticsPath,
        data: json.encode(diagnostics),
      );

      if (response.statusCode != HttpStatus.ok) {
        developer.log('Failed to send logs to backend: ${response.data}');
      }
    } catch (e) {
      developer.log('Failed to send logs to backend: $e');
    }
  }
}
