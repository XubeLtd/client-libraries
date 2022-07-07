library xube_client;

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/services/account.dart';
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/component.dart';
import 'package:xube_client/src/services/device.dart';

class XubeClient {
  late final WebSocketChannel _channel;
  late final XubeClientAuth _auth;
  late final XubeClientAccount _account;
  late final XubeClientComponent _component;
  late final XubeClientDevice _device;

  XubeClientAuth get auth => _auth;
  XubeClientAccount get account => _account;
  XubeClientComponent get component => _component;
  XubeClientDevice get device => _device;

  Stream get stream => _channel.stream;

  XubeClient({
    WebSocketChannel? channel,
    XubeClientAuth? auth,
    XubeClientAccount? account,
    XubeClientComponent? component,
    XubeClientDevice? device,
  }) {
    _channel = channel ??
        WebSocketChannel.connect(
          Uri.parse('wss://wpc1qzf6mk.execute-api.eu-west-1.amazonaws.com/dev'),
        );
    _auth = auth ?? XubeClientAuth();
    _account = account ?? XubeClientAccount(channel: _channel);
    _component = component ?? XubeClientComponent();
    _device = device ?? XubeClientDevice();
  }
}
