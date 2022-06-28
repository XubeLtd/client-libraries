import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class XubeClientAccount {
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
