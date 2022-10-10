import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientAccounts {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientAccounts({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  final dio = Dio();

  Stream? getUserAccountsStream() {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "USER",
      typeId: _auth.email!,
    );

    if (stream != null) return stream;

    _channel.sink.add(
      json.encode(
        {
          "action": "Subscribe",
          "format": "View",
          "contextKey": "ACCOUNT",
          "typeKey": "USER",
          "typeId": _auth.email,
        },
      ),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "USER",
      typeId: _auth.email!,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "ACCOUNT",
      typeKey: "USER",
      typeId: _auth.email!,
    );

    log('getUserAccountsStream: $stream');
    return stream;
  }

  Future<String?> createAccount(String accountName) async {
    const url = '/account';

    try {
      final responseData = await submit(
        data: {
          'name': accountName,
        },
        url: url,
        authToken: _auth.token!,
      );

      _channel.sink.add(
        json.encode(
          {
            'action': 'Subscribe',
            'format': 'View',
            'contextKey': 'ACCOUNT',
            'typeKey': 'ACCOUNT',
            'typeId': accountName,
          },
        ),
      );

      _subscriptionManager.createSubscription(
        format: 'View',
        contextKey: 'ACCOUNT',
        typeKey: 'ACCOUNT',
        typeId: accountName,
      );

      log('createAccount responseData: $responseData');
      return responseData['message']?['id'];
    } catch (e) {
      rethrow;
    }
  }
}
