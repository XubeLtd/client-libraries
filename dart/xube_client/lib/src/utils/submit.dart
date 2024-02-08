import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:xube_client/src/models/result.dart';

Future<dynamic> submit({
  required Map<String, dynamic> data,
  required String url,
  String? authToken,
  String method = 'post',
}) async {
  dynamic resultData;
  bool hasError = false;
  String message = '';
  String title = 'Oops, something went wrong!';

  final tempUrl = 'https://api.jez.xube.dev$url';

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

    resultData = responseData;
    hasError = false;

    return responseData;
  } catch (e) {
    hasError = true;
    message = '$e';

    if (e is DioError) {
      message = e.message;
    }

    log(e.toString());
  }

  return Result(
    data: resultData,
    hasError: hasError,
    title: title,
    message: message,
  );
}
