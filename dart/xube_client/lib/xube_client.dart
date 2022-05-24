library xube_client;

import 'package:flutter/services.dart';

abstract class XubeClient {
  List<Stream> fetchDevicePageStreams(String deviceId);
}

class XubeClientImpl implements XubeClient {
  @override
  List<Stream> fetchDevicePageStreams(String deviceId) {
    return [
      Stream.fromFuture(
          rootBundle.loadString('assets/examples/xube_info.json')),
      Stream.fromFuture(
          rootBundle.loadString('assets/examples/xube_endpoint.json')),
      Stream.fromFuture(
          rootBundle.loadString('assets/examples/xube_connectivity.json')),
      Stream.fromFuture(
          rootBundle.loadString('assets/examples/xube_power.json')),
    ];
  }
}
