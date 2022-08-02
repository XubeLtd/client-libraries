import 'dart:async';
import 'dart:developer';

import 'package:rxdart/subjects.dart';

class XubeSubscription {
  final String id;
  final controller = BehaviorSubject();

  XubeSubscription({required this.id});

  Stream get stream => controller.stream;

  void addData(dynamic data) {
    log('Adding data: $data to XubeSubscription $id');
    controller.add(data);
  }
}

class SubscriptionManager {
  static final SubscriptionManager instance = SubscriptionManager._internal();

  late final Map<String, XubeSubscription> _subscriptions;

  SubscriptionManager._internal() {
    _subscriptions = {};
  }

  Stream? findStreamById(String id) {
    return _subscriptions[id]?.stream;
  }

  void feed(String id, dynamic data) {
    _subscriptions[id]?.addData(data);
  }

  void createSubscription(String id) {
    log('Adding new XubeSubscription $id to the Subscription Manager');
    final newSubscription = XubeSubscription(id: id);
    _subscriptions.putIfAbsent(id, () => newSubscription);
  }
}
