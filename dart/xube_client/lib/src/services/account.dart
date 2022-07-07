import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

// {“action”: “Subscribe”, “format”: “View”, “contextType”:“ACCOUNT”, “contextID”:“sub account 20", “subscriptionType”: “ACCOUNT”, “subscriptionID”:“sub account 20"}

class XubeClientAccount {
  late final WebSocketChannel channel;

  XubeClientAccount({required this.channel});

  Future<String?> createAccount(String token, String accountName) async {
    final url = Uri.parse(
        'https://nwopvacn1a.execute-api.eu-west-1.amazonaws.com/prod/account');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
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

      channel.sink.add(
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

      log('createAccount responseData: $responseData');
      return responseData['message']?['id'];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserToAccount(
    String token,
    String userEmail,
    String accountId,
    Map<String, bool> accountRoles,
  ) async {
    List<String> roles = [];

    accountRoles.forEach((key, value) {
      if (value) roles.add(key);
    });

    final url = Uri.parse(
        'https://nwopvacn1a.execute-api.eu-west-1.amazonaws.com/prod/user');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
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
