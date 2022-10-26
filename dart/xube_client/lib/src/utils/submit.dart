import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';

Future<dynamic> submit({
  required Map<String, dynamic> data,
  required String url,
  String? authToken,
  String method = 'post',
}) async {
  final tempUrl = 'https://dev.api.xube.io$url';

  try {
    Response<dynamic>? response;

    final options = authToken != null
        ? Options(
            headers: {
              'Authorization': authToken,
            },
          )
        : null;

    final encodedData = json.encode(data);

    switch (method.toLowerCase()) {
      case 'get':
        response = await Dio().get(
          tempUrl,
          options: options,
          queryParameters: data,
        );
        break;
      case 'post':
        response = await Dio().post(
          tempUrl,
          options: options,
          data: encodedData,
        );
        break;
      case 'put':
        response = await Dio().put(
          tempUrl,
          options: options,
          data: encodedData,
        );
        break;
      case 'patch':
        response = await Dio().patch(
          tempUrl,
          options: options,
          data: encodedData,
        );
        break;
    }

    if (response == null) return;

    final responseData = response.data;

    if (responseData['error'] != null) {
      throw Exception(responseData['error']);
    }

    return responseData;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}
