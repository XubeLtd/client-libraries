import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientDevices {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientDevices({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;
  Stream? getProjectDevicesStream(String projectId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "PROJECT",
      typeId: projectId,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          "action": "Subscribe",
          "format": "View",
          "contextKey": "DEVICE",
          "typeKey": "PROJECT",
          "typeId": projectId,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "PROJECT",
      typeId: projectId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "DEVICE",
      typeKey: "PROJECT",
      typeId: projectId,
    );

    log('getProjectDevicesStream: $stream');
    return stream;
  }
}
