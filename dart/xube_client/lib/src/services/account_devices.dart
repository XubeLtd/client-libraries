import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientAccountDevices {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientAccountDevices({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  void unsubscribe(String accountId) {
    _channel.sink.add(
      json.encode(
        {
          "action": "Unsubscribe",
          "format": "Raw",
          "contextKey": "COMPONENT#DEVICE",
          "typeKey": "ACCOUNT",
          "typeId": accountId,
        },
      ),
    );

    _subscriptionManager.unsubscribe(
      format: "Raw",
      contextKey: "COMPONENT#DEVICE",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );
  }

  Stream<List<Device>>? getAccountDevicesStream(String accountId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager
        .findStreamById(
      format: "Raw",
      contextKey: "COMPONENT#DEVICE",
      typeKey: "ACCOUNT",
      typeId: accountId,
    )
        ?.map((event) {
      final items = (event['items'] as List);

      if (items.isNotEmpty) {
        return items.map((e) => Device.fromJson(e)).toList()
          ..sort(
              (a, b) => (int.parse(b.version)).compareTo(int.parse(a.version)));
      }

      return <Device>[];
    });

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          "action": "Subscribe",
          "format": "Raw",
          "contextKey": "COMPONENT#DEVICE",
          "typeKey": "ACCOUNT",
          "typeId": accountId,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: "Raw",
      contextKey: "COMPONENT#DEVICE",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    stream = _subscriptionManager
        .findStreamById(
      format: "Raw",
      contextKey: "COMPONENT#DEVICE",
      typeKey: "ACCOUNT",
      typeId: accountId,
    )
        ?.map((event) {
      final items = (event['items'] as List);

      if (items.isNotEmpty) {
        return items.map((e) => Device.fromJson(e)).toList()
          ..sort(
              (a, b) => (int.parse(b.version)).compareTo(int.parse(a.version)));
      }

      return <Device>[];
    }) as Stream<List<Device>>;

    log('getAccountDevicesStream: $stream');
    return stream;
  }
}
