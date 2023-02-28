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
        ?.map(_accountDevicesListTransformer);

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
        ?.map(_accountDevicesListTransformer);

    log('getAccountDevicesStream: $stream');
    return stream;
  }

  List<Device> _accountDevicesListTransformer(dynamic event) {
    List<Device> devices = [];

    final items = (event['items'] as List);

    if (items.isNotEmpty) {
      devices = items.map((e) => Device.fromJson(e)).toList();
    }

    devices = [..._getMostRecentDeviceVersions(devices)];

    return devices;
  }

  List<Device> _getMostRecentDeviceVersions(List<Device> devices) {
    Map<String, Device> mostRecentDevices = {};
    for (var device in devices) {
      if (mostRecentDevices.containsKey(device.PKGSI1) &&
          int.parse(mostRecentDevices[device.PKGSI1]?.version ?? '0') >
              int.parse(device.version ?? '0')) {
        continue;
      }

      if (device.PKGSI1 != null) {
        mostRecentDevices.putIfAbsent(device.PKGSI1!, () => device);
      }
    }

    return mostRecentDevices.values.toList();
  }
}
