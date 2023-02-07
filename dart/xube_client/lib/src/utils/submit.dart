import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:xube_client/src/models/result.dart';

Future<Result> submit({
  required Map<String, dynamic> data,
  required String url,
  String? authToken,
  String method = 'post',
}) async {
  dynamic data;
  bool hasError = false;
  String message = '';
  String title = 'Oops, something went wrong!';

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

    if (response == null) {
      return Result(
        hasError: true,
        message: "That didn't load right",
      );
    }

    final responseData = response.data;
    data = responseData;
    hasError = false;
  } catch (e) {
    hasError = true;
    message = '$e';
    log(e.toString());
  }

  return Result(
    data: data,
    hasError: hasError,
    title: title,
    message: message,
  );
}
