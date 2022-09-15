import 'dart:async';
import 'dart:developer';

import 'package:rxdart/subjects.dart';

class XubeSubscription {
  final String id;
  final _controller = BehaviorSubject();

  XubeSubscription({required this.id});

  Stream get stream => _controller.stream;

  void addData(dynamic data) {
    log('Adding data: $data to XubeSubscription $id');
    _controller.add(data);
  }
}

class SubscriptionManager {
  static final SubscriptionManager instance = SubscriptionManager._internal();

  late final Map<String, XubeSubscription> _subscriptions;

  String _formatId({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
  }) =>
      '$format#$contextKey#$typeKey#$typeId';

  SubscriptionManager._internal() {
    _subscriptions = {};
  }

  Stream? findStreamById({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
    );

    return _subscriptions[id]?.stream;
  }

  void feed({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
    dynamic data,
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
    );

    _subscriptions[id]?.addData(data);
  }

  void createSubscription({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
    );

    log('Adding new XubeSubscription $id to the Subscription Manager');

    final newSubscription = XubeSubscription(id: id);

    _subscriptions.putIfAbsent(id, () => newSubscription);
  }
}
