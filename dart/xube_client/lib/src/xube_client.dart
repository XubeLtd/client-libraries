library xube_client;

import 'dart:convert';
import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/services/account.dart';
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/component.dart';
import 'package:xube_client/src/services/device.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';

export 'package:xube_client/src/services/auth.dart';

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

  XubeClient({
    WebSocketChannel? channel,
    XubeClientAuth? auth,
    XubeClientAccount? account,
    XubeClientComponent? component,
    XubeClientDevice? device,
  }) {
    log('Init Xube Client');
    _initSocket(channel);

    _auth = auth ?? XubeClientAuth();
    _account = account ?? XubeClientAccount(channel: _channel, auth: _auth);
    _component =
        component ?? XubeClientComponent(channel: _channel, auth: _auth);
    _device = device ?? XubeClientDevice();
  }

  _initSocket(WebSocketChannel? channel) {
    _channel = channel ??
        WebSocketChannel.connect(
          Uri.parse('wss://wpc1qzf6mk.execute-api.eu-west-1.amazonaws.com/dev'),
        );

    _channel.stream.listen((event) {
      final data = jsonDecode(event);
      SubscriptionManager.instance.feed(data['subscriptionID'], data);
    });
  }

  Stream? findStreamById(String id) {
    return SubscriptionManager.instance.findStreamById(id);
  }
}
