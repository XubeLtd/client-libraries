import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';
import 'dart:developer';

class XubeClientDevice {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientDevice({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  final dio = Dio();

  void unsubscribe(String deviceId) {
    _channel.sink.add(
      json.encode({
        "action": "Unsubscribe",
        "format": "View",
        "contextKey": "DEVICE",
        "typeKey": "DEVICE",
        "typeId": deviceId,
      }),
    );

    _subscriptionManager.unsubscribe(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "DEVICE",
      typeId: deviceId,
    );
  }

  Stream? getDeviceStream(String deviceId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    if (stream != null) return stream;

    log('getDeviceStream: subscribing to $deviceId');
    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": "View",
        "contextKey": "DEVICE",
        "typeKey": "DEVICE",
        "typeId": deviceId,
      }),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    log('getDeviceStream: $stream');
    return stream;
  }
}
