import 'package:flutter/services.dart';

class XubeClientDevice {
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
}
