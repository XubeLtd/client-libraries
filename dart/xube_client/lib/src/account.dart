import 'dart:convert';
import 'package:http/http.dart' as http;

class XubeClientAccount {
  Future<void> createAccount(String token, String accountName) async {
    final url = Uri.parse(
        'https://nwopvacn1a.execute-api.eu-west-1.amazonaws.com/prod/account');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': token,
        },
        body: {
          'name': accountName,
        },
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
