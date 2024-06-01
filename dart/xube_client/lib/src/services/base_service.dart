import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';

abstract class BaseService {
  final SubscriptionManager subscriptionManager;
  final XubeLog log;

  StreamSubscription? subscriptionStateStreamSubscription;

  BaseService({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  })  : subscriptionManager = GetIt.I<SubscriptionManager>(),
        log = XubeLog.getInstance();

  @protected
  Stream<T> getStream<T, U>(
    String path,
    T Function(U data) convertData,
  ) {
    Stream<T>? stream = subscriptionManager.findStreamById<T>(path: path);
    if (stream != null) {
      log.info('Found existing stream for path: $path');
      return stream;
    }

    log.info('Did not find stream for path $path. Subscribing...');

    return subscriptionManager.subscribe<T, U>(
      path: path,
      convertData: convertData,
    );
  }
}
