import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';

class XubeClientProducts {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientProducts({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  Stream? getUserProductsStream() {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: 'View',
      contextKey: 'PRODUCT',
      typeKey: 'USER',
      typeId: _auth.email!,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          'action': 'Subscribe',
          'format': 'View',
          'contextKey': 'PRODUCT',
          'typeKey': 'USER',
          'typeId': _auth.email,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: 'View',
      contextKey: 'PRODUCT',
      typeKey: 'USER',
      typeId: _auth.email!,
    );

    stream = _subscriptionManager.findStreamById(
      format: 'View',
      contextKey: 'PRODUCT',
      typeKey: 'USER',
      typeId: _auth.email!,
    );

    log('getUserProductsStream: $stream');
    return stream;
  }
}
