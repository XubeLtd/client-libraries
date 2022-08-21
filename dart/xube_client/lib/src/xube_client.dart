library xube_client;

// Dart Packages

import 'dart:convert';
import 'dart:developer';

// 3rd-Party Packages
import 'package:web_socket_channel/web_socket_channel.dart';

// Utilities
import 'package:xube_client/src/utils/subcscription_manager.dart';

// Services
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/account.dart';
import 'package:xube_client/src/services/accounts.dart';
import 'package:xube_client/src/services/component.dart';
import 'package:xube_client/src/services/device.dart';
import 'package:xube_client/src/services/project.dart';
import 'package:xube_client/src/services/projects.dart';
export 'package:xube_client/src/services/auth.dart';

class XubeClient {
  late final WebSocketChannel _channel;
  late final XubeClientAuth _auth;
  late final XubeClientAccounts _accounts;
  late final XubeClientAccount _account;
  late final XubeClientProjects _projects;
  late final XubeClientProject _project;
  late final XubeClientDevice _device;
  late final XubeClientComponent _component;

  XubeClientAuth get auth => _auth;
  XubeClientAccounts get accounts => _accounts;
  XubeClientAccount get account => _account;
  XubeClientProjects get projects => _projects;
  XubeClientProject get project => _project;
  XubeClientDevice get device => _device;
  XubeClientComponent get component => _component;

  XubeClient({
    WebSocketChannel? channel,
    XubeClientAuth? auth,
    XubeClientAccounts? accounts,
    XubeClientAccount? account,
    XubeClientProjects? projects,
    XubeClientProject? project,
    XubeClientDevice? device,
    XubeClientComponent? component,
  }) {
    log('Init Xube Client');
    _initSocket(channel);

    _auth = auth ?? XubeClientAuth();
    _accounts = accounts ?? XubeClientAccounts(channel: _channel, auth: _auth);
    _account = account ?? XubeClientAccount(channel: _channel, auth: _auth);
    _projects = projects ?? XubeClientProjects(channel: _channel, auth: _auth);
    _project = project ?? XubeClientProject(channel: _channel, auth: _auth);
    _device = device ?? XubeClientDevice(channel: _channel, auth: _auth);
    _component =
        component ?? XubeClientComponent(channel: _channel, auth: _auth);
  }

  _initSocket(WebSocketChannel? channel) {
    _channel = channel ??
        WebSocketChannel.connect(
          Uri.parse('wss://wpc1qzf6mk.execute-api.eu-west-1.amazonaws.com/dev'),
        );

    _channel.stream.listen((event) {
      final data = jsonDecode(event);
      if (data == null) return;

      final subscription = data['subscription'];

      if (subscription == null) return;

      SubscriptionManager.instance.feed(subscription['subscriptionID'], data);
    });
  }

  Stream? findStreamById(String id) {
    return SubscriptionManager.instance.findStreamById(id);
  }
}
