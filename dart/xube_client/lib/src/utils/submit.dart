import 'dart:convert';
import 'package:dio/dio.dart';

enum HttpMethod {
  post,
  get,
  put,
}

Future<dynamic> submit({
  required Map<String, dynamic> data,
  required String url,
  String? authToken,
  HttpMethod method = HttpMethod.post,
}) async {
  try {
    Response<dynamic> response;

    final options = authToken != null
        ? Options(
            headers: {
              'Authorization': authToken,
            },
          )
        : null;

    final encodedData = json.encode(data);

    switch (method) {
      case HttpMethod.get:
        response = await Dio().get(
          url,
          options: options,
          queryParameters: data,
        );
        break;
      case HttpMethod.post:
        response = await Dio().post(
          url,
          options: options,
          data: encodedData,
        );
        break;
      case HttpMethod.put:
        response = await Dio().put(
          url,
          options: options,
          data: encodedData,
        );
        break;
    }

    final responseData = response.data;

    if (responseData['error'] != null) {
      throw Exception(responseData['error']);
    }

    return responseData;
  } catch (e) {
    rethrow;
  }
}
