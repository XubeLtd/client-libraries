import 'dart:developer';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';

class XubeClientAccount {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientAccount({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  Stream? getAccountStream(String accountId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": "View",
        "contextKey": "ACCOUNT",
        "typeKey": "ACCOUNT",
        "typeId": accountId,
      }),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );

    log('getAccountStream: $stream');
    return stream;
  }

  Future<void> addUserToAccount(
    String userEmail,
    String accountId,
    Map<String, bool> accountRoles,
  ) async {
    List<String> roles = [];

    accountRoles.forEach((key, value) {
      if (value) roles.add(key);
    });

    log('here ${_auth.token!}');

    const url = '/account/user';
    try {
      final responseData = await submit(
        data: {
          'email': userEmail,
          'id': accountId,
          'roles': roles,
          'account': accountId,
        },
        url: url,
        authToken: _auth.token!,
      );

      log('addUserToAccount responseData: $responseData');
    } catch (error) {
      rethrow;
    }
  }
}
