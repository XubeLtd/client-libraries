import 'package:flutter/services.dart';

class XubeClientComponent {
  List<Stream> fetchComponentPageStreams(String userId) {
    return [
      Stream.fromFuture(
              rootBundle.loadString('examples/components/xube_components.json'))
          .asBroadcastStream(),
    ];
  }
}
