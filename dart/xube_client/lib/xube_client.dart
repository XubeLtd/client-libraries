library xube_client;

import 'package:flutter/services.dart';

abstract class XubeClient {
  List<Stream> fetchDevicePageStreams(String deviceId);
  List<Stream> fetchComponentPageStreams(String userId);
}

class XubeClientImpl implements XubeClient {
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
