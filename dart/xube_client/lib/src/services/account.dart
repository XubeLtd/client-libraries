import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

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

  final dio = Dio();

  Stream? getAccountStream(String accountId) {
    return _subscriptionManager.findStreamById(accountId);
  }

  Future<String?> createAccount(String accountName) async {
    const url =
        'https://198lxm6kmg.execute-api.eu-west-1.amazonaws.com/prod/account';

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': _auth.token!,
          },
        ),
        data: json.encode(
          {
            'name': accountName,
          },
        ),
      );

      final responseData = json.decode(response.data);

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

    const url =
        'https://198lxm6kmg.execute-api.eu-west-1.amazonaws.com/prod/account/user';

    try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': _auth.token!,
          },
        ),
        data: json.encode(
          {
            'email': userEmail,
            'id': accountId,
            'roles': roles,
          },
        ),
      );

      final responseData = json.decode(response.data);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
