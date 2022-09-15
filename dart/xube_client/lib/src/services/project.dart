import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientProject {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientProject({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  Stream? getProjectStream(String projectId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: projectId,
    );

    if (stream != null) return stream;

    log('getProjectStream: subscribing to $projectId');
    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": "View",
        "contextKey": "PROJECT",
        "typeKey": "ACCOUNT",
        "typeId": projectId,
      }),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: projectId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: projectId,
    );

    log('getProjectStream: $stream');
    return stream;
  }
}
