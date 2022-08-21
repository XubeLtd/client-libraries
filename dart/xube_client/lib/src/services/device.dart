import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';

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

  List<Stream> getDeviceStream(String deviceId) {
    return [
      Stream.fromFuture(
              rootBundle.loadString('assets/examples/device/xube_info.json'))
          .asBroadcastStream(),
      Stream.fromFuture(rootBundle
              .loadString('assets/examples/device/xube_endpoint.json'))
          .asBroadcastStream(),
      Stream.fromFuture(rootBundle
              .loadString('assets/examples/device/xube_connectivity.json'))
          .asBroadcastStream(),
      Stream.fromFuture(
              rootBundle.loadString('assets/examples/device/xube_power.json'))
          .asBroadcastStream(),
    ];
  }
}
