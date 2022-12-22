import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';

class XubeClientComponentDataEndpoint {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientComponentDataEndpoint({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  void unsubscribe(String accountId) {
    _channel.sink.add(
      json.encode({
        "action": "Unsubscribe",
        "format": "View",
        "contextKey": "COMPONENT-DATA-ENDPOINT",
        "contextId": "CURRENT",
        "typeKey": "ACCOUNT",
        "typeId": accountId,
      }),
    );

    _subscriptionManager.unsubscribe(
      format: "View",
      contextKey: "COMPONENT-DATA-ENDPOINT",
      contextId: "CURRENT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );
  }

  Stream? getComponentDataEndpointStream(String accountId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT-DATA-ENDPOINT",
      contextId: "CURRENT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": "View",
        "contextKey": "COMPONENT-DATA-ENDPOINT",
        "contextId": "CURRENT",
        "typeKey": "ACCOUNT",
        "typeId": accountId,
      }),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "COMPONENT-DATA-ENDPOINT",
      contextId: "CURRENT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT-DATA-ENDPOINT",
      contextId: "CURRENT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    log('getComponentDataEndpointStream: $stream');
    return stream;
  }

  Future<void> setEndpoint(
    String accountId,
    String endpoint,
  ) async {
    const url = '/data/endpoint';
    try {
      final responseData = await submit(
        data: {
          'account': accountId,
          'endpoint': endpoint,
        },
        url: url,
        authToken: _auth.token!,
        method: 'patch',
      );

      log('setEndpoint responseData: $responseData');
    } catch (error) {
      rethrow;
    }
  }
}
