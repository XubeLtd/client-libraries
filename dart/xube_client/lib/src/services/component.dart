import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientComponent {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientComponent({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  void unsubscribe(String deviceId, String componentId) {
    _channel.sink.add(
      json.encode(
        {
          "action": "Unsubscribe",
          "format": "View",
          "contextKey": "COMPONENT",
          "contextId": componentId,
          "typeKey": "DEVICE",
          "typeId": deviceId,
        },
      ),
    );

    _subscriptionManager.unsubscribe(
      format: "View",
      contextKey: "COMPONENT",
      contextId: componentId,
      typeKey: "DEVICE",
      typeId: deviceId,
    );
  }

  Stream? getDeviceComponentStream(String deviceId, String componentId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT",
      contextId: componentId,
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          "action": "Subscribe",
          "format": "View",
          "contextKey": "COMPONENT",
          "contextId": componentId,
          "typeKey": "DEVICE",
          "typeId": deviceId,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "COMPONENT",
      contextId: componentId,
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT",
      contextId: componentId,
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    log('getDeviceComponentStream: $stream');
    return stream;
  }
}
