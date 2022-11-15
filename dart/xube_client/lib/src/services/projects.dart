import 'dart:convert';
import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientProjects {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientProjects({
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
          "format": "View",
          "contextKey": "PROJECT",
          "typeKey": "ACCOUNT",
          "typeId": accountId,
        },
      ),
    );

    _subscriptionManager.unsubscribe(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );
  }

  Future<void> createProject({
    required String accountId,
    required String endpointURL,
    required String name,
    required String stage,
  }) async {
    const url = '/project';

    try {
      final data = {
        'account': accountId,
        'endpoint': endpointURL,
        'name': name,
        'stage': stage,
      };

      await submit(
        data: data,
        url: url,
        authToken: _auth.token,
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream? getProjectsStream(String accountId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          "action": "Subscribe",
          "format": "View",
          "contextKey": "PROJECT",
          "typeKey": "ACCOUNT",
          "typeId": accountId,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "PROJECT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    log('getProjectsStream: $stream');
    return stream;
  }
}
