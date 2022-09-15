import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/src/utils/submit.dart';
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
    const url = 'https://dev.api.xube.io/account';

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

    const url = 'https://dev.api.xube.io/account/user';
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
