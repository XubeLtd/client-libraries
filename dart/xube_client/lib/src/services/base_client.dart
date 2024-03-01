import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';

abstract class BaseClient {
  final SubscriptionManager _subscriptionManager;
  final XubeLog _log;

  StreamSubscription? subscriptionStateStreamSubscription;

  BaseClient({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  })  : _subscriptionManager = GetIt.I<SubscriptionManager>(),
        _log = XubeLog.getInstance();

  @protected
  Stream<T> getStream<T>(
    String path,
    T Function(List<Map<String, dynamic>> data) convertData,
  ) {
    Stream<T>? stream = _subscriptionManager.findStreamById<T>(path: path);
    if (stream != null) {
      _log.info('Found existing stream for path: $path');
      return stream;
    }

    _log.info('Did not find stream for path $path. Subscribing...');

    return _subscriptionManager.subscribe<T>(
      path: path,
      convertData: convertData,
    );
  }
}
