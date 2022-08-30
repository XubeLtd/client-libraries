import 'dart:convert';
import 'package:dio/dio.dart';

Future<dynamic> submit({
  required Map<String, dynamic> data,
  required String url,
  String? authToken,
}) async {
  try {
    final response = await Dio().post(
      url,
      options: authToken != null
          ? Options(
              headers: {
                'Authorization': authToken,
              },
            )
          : null,
      data: json.encode(data),
    );

    final responseData = response.data;

    if (responseData['error'] != null) {
      throw Exception(responseData['error']);
    }

    return responseData;
  } catch (e) {
    rethrow;
  }
}
