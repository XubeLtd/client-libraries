import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

// {“action”: “Subscribe”, “format”: “View”, “contextType”:“ACCOUNT”, “contextID”:“sub account 20", “subscriptionType”: “ACCOUNT”, “subscriptionID”:“sub account 20"}

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
    return _subscriptionManager.findStreamById(accountId);
  }

  Future<String?> createAccount(String accountName) async {
    final url = Uri.parse(
        'https://198lxm6kmg.execute-api.eu-west-1.amazonaws.com/prod/account');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _auth.token!,
        },
        body: json.encode(
          {
            'name': accountName,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }

      _channel.sink.add(
        json.encode(
          {
            'action': 'Subscribe',
            'format': 'View',
            'contextType': 'ACCOUNT',
            'contextID': accountName,
            'subscriptionType': 'ACCOUNT',
            'subscriptionID': accountName,
          },
        ),
      );

      _subscriptionManager.createSubscription(accountName);

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

    final url = Uri.parse(
        'https://198lxm6kmg.execute-api.eu-west-1.amazonaws.com/prod/account/user');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': _auth.token!,
        },
        body: json.encode(
          {
            'email': userEmail,
            'id': accountId,
            'roles': roles,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
