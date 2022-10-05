import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/src/utils/submit.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientComponents {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientComponents({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  final dio = Dio();

  Future<List<Component>> getComponents(String accountId) async {
    List<Component> components = [];

    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return components;
    }

    const url = 'https://dev.api.xube.io/component/account';
    try {
      log('debug $accountId');
      log('debug ${_auth.token}');
      final responseData = await submit(
        data: {'account': accountId},
        url: url,
        authToken: _auth.token,
        method: HttpMethod.get,
      );

      log('responseData: $responseData');

      final List<dynamic> rawComponents = responseData['message'] ?? [];

      components = rawComponents
          .map((e) => Component.fromJson(e as Map<String, dynamic>))
          .toList();

      return components;
    } catch (error) {
      rethrow;
    }
  }

  Stream? getDeviceComponentsStream(String deviceId) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    if (stream != null) return stream;

    log('getDeviceStream: subscribing to $deviceId');
    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": "View",
        "contextKey": "COMPONENT",
        "typeKey": "DEVICE",
        "typeId": deviceId,
      }),
    );

    _subscriptionManager.createSubscription(
      format: "View",
      contextKey: "COMPONENT",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    stream = _subscriptionManager.findStreamById(
      format: "View",
      contextKey: "COMPONENT",
      typeKey: "DEVICE",
      typeId: deviceId,
    );

    log('getDeviceComponentsStream: $stream');
    return stream;
  }
}
