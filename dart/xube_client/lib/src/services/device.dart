import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';
import 'dart:developer';

class XubeClientDevice {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientDevice({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  final dio = Dio();

  void unsubscribe({
    required String accountId,
    required String deviceId,
    String format = 'View',
  }) {
    _channel.sink.add(
      json.encode({
        "action": "Unsubscribe",
        "format": format,
        "contextKey": "COMPONENT#$deviceId",
        "typeKey": "ACCOUNT",
        "typeId": accountId,
      }),
    );

    _subscriptionManager.unsubscribe(
      format: format,
      contextKey: "COMPONENT#$deviceId",
      typeKey: "ACCOUNT",
      typeId: accountId,
    );
  }

  Stream? getDeviceStream({
    required String accountId,
    required String deviceId,
    String version = '',
    String format = 'View',
  }) {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    var stream = _subscriptionManager.findStreamById(
      format: format,
      contextKey: "COMPONENT#$deviceId",
      typeKey: "ACCOUNT",
      typeId: accountId,
      contextId: version,
    );

    if (stream != null) return stream;

    log('getDeviceStream: subscribing to $deviceId');
    _channel.sink.add(
      json.encode({
        "action": "Subscribe",
        "format": format,
        "contextKey": "COMPONENT#$deviceId",
        "typeKey": "ACCOUNT",
        "typeId": accountId,
        "contextId": version,
      }),
    );

    _subscriptionManager.createSubscription(
      format: format,
      contextKey: "COMPONENT#$deviceId",
      typeKey: "ACCOUNT",
      typeId: accountId,
      contextId: version,
    );

    stream = _subscriptionManager.findStreamById(
      format: format,
      contextKey: "COMPONENT#$deviceId",
      typeKey: "ACCOUNT",
      typeId: accountId,
      contextId: version,
    );

    log('getDeviceStream: $stream $format');
    return stream;
  }

  Future<Device?> getDevice(String deviceId) async {
    Device? device;

    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return null;
    }

    final url = '/devices/$deviceId';

    try {
      final responseData = await submit(
        data: {},
        url: url,
        authToken: _auth.token,
        method: 'get',
      );

      log('responseData: $responseData');

      device = Device.fromJson(responseData.data);

      return device;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateDeviceConfiguration({
    required String deviceId,
    required Map<String, dynamic> config,
  }) async {
    if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
      return;
    }

    const url = '/devices/config';

    try {
      final responseData = await submit(
        data: {
          "device": deviceId,
          "config": config,
        },
        url: url,
        authToken: _auth.token,
        method: 'patch',
      );

      log('responseData: $responseData');
    } catch (error) {
      rethrow;
    }
  }
}
