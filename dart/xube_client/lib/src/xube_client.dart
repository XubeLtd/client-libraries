library xube_client;

import 'package:flutter/services.dart';
import 'package:xube_client/xube_client.dart';

abstract class XubeClient {
  List<Stream> fetchDevicePageStreams(String deviceId);
  List<Stream> fetchComponentPageStreams(String userId);
  late XubeAuth auth;
}

class XubeClientImpl implements XubeClient {
  @override
  XubeAuth auth = XubeAuth();

  @override
  List<Stream> fetchDevicePageStreams(String deviceId) {
    return [
      Stream.fromFuture(rootBundle.loadString('examples/device/xube_info.json'))
          .asBroadcastStream(),
      Stream.fromFuture(
              rootBundle.loadString('examples/device/xube_endpoint.json'))
          .asBroadcastStream(),
      Stream.fromFuture(
              rootBundle.loadString('examples/device/xube_connectivity.json'))
          .asBroadcastStream(),
      Stream.fromFuture(
              rootBundle.loadString('examples/device/xube_power.json'))
          .asBroadcastStream(),
    ];
  }

  @override
  List<Stream> fetchComponentPageStreams(String userId) {
    return [
      Stream.fromFuture(
              rootBundle.loadString('examples/components/xube_components.json'))
          .asBroadcastStream(),
    ];
  }
}
