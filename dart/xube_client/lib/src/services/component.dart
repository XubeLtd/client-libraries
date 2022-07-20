import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientComponent {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;

  XubeClientComponent({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
  })  : _channel = channel,
        _auth = auth;

  List<Stream> fetchComponentPageStreams(String userId) {
    return [
      Stream.fromFuture(rootBundle
              .loadString('assets/examples/components/xube_components.json'))
          .asBroadcastStream(),
    ];
  }
}
