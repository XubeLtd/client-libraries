import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/models/result.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/src/xube_client.dart';

Future<dynamic> submit({
  required Map<String, dynamic> data,
  required String path,
  String method = 'post',
  XubeLog? log,
}) async {
  dynamic resultData;
  bool hasError = false;
  String message = '';
  String title = 'Oops, something went wrong!';

  Dio dio = GetIt.I<Dio>();
  log ??= XubeLog.getInstance();

  try {
    Response<dynamic>? response;

    //Consider = Future: Create a buffer of requests that get sent out when authentication is confirmed
    String? authToken = GetIt.I<XubeClientAuth>().token;

    if (authToken == null) {
      log.warning('User is not authenticated.');
      return false;
    }

    final options = Options(
      headers: {
        'Authorization': authToken,
      },
    );

    switch (method.toLowerCase()) {
      case 'get':
        response = await dio.get(
          path,
          options: options,
          queryParameters: data,
        );
        break;
      case 'post':
        response = await dio.post(
          path,
          options: options,
          data: json.encode(data),
        );
        break;
      case 'put':
        response = await dio.put(
          path,
          options: options,
          data: json.encode(data),
        );
        break;
      case 'patch':
        response = await dio.patch(
          path,
          options: options,
          data: json.encode(data),
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

    log.error('Error occurred during submit. ${e.toString()}');
  }

  return Result(
    data: resultData,
    hasError: hasError,
    title: title,
    message: message,
  );
}
