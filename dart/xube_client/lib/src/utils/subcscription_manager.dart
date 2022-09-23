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
    String contextId = '',
  }) {
    String id = '$format#$contextKey#$typeKey#$typeId';
    if (contextId.isNotEmpty) {
      id += '#$contextId';
    }

    return id;
  }

  SubscriptionManager._internal() {
    _subscriptions = {};
  }

  Stream? findStreamById({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
    String contextId = '',
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
      contextId: contextId,
    );

    return _subscriptions[id]?.stream;
  }

  void feed({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
    String contextId = '',
    dynamic data,
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
      contextId: contextId,
    );

    _subscriptions[id]?.addData(data);
  }

  void createSubscription({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
    String contextId = '',
  }) {
    final id = _formatId(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
      contextId: contextId,
    );

    log('Adding new XubeSubscription $id to the Subscription Manager');

    final newSubscription = XubeSubscription(id: id);

    _subscriptions.putIfAbsent(id, () => newSubscription);
  }
}
