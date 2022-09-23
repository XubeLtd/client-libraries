library xube_client;

// Dart Packages

import 'dart:convert';
import 'dart:developer';

// 3rd-Party Packages
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/services/components.dart';
import 'package:xube_client/src/services/devices.dart';

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
  late final XubeClientDevices _devices;
  late final XubeClientComponent _component;
  late final XubeClientComponents _components;

  XubeClientAuth get auth => _auth;
  XubeClientAccounts get accounts => _accounts;
  XubeClientAccount get account => _account;
  XubeClientProjects get projects => _projects;
  XubeClientProject get project => _project;
  XubeClientDevice get device => _device;
  XubeClientDevices get devices => _devices;
  XubeClientComponent get component => _component;
  XubeClientComponents get components => _components;

  XubeClient({
    WebSocketChannel? channel,
    XubeClientAuth? auth,
    XubeClientAccounts? accounts,
    XubeClientAccount? account,
    XubeClientProjects? projects,
    XubeClientProject? project,
    XubeClientDevice? device,
    XubeClientDevices? devices,
    XubeClientComponent? component,
    XubeClientComponents? components,
  }) {
    log('Init Xube Client');

    _auth = auth ?? XubeClientAuth();

    _auth.authStream.listen((event) {
      log('debug ${event.token}');
      if (event.token == null) return;

      _initSocket(channel, event.token!);

      _accounts =
          accounts ?? XubeClientAccounts(channel: _channel, auth: _auth);
      _account = account ?? XubeClientAccount(channel: _channel, auth: _auth);
      _projects =
          projects ?? XubeClientProjects(channel: _channel, auth: _auth);
      _project = project ?? XubeClientProject(channel: _channel, auth: _auth);
      _device = device ?? XubeClientDevice(channel: _channel, auth: _auth);
      _devices = devices ?? XubeClientDevices(channel: _channel, auth: _auth);
      _component =
          component ?? XubeClientComponent(channel: _channel, auth: _auth);
      _components =
          components ?? XubeClientComponents(channel: _channel, auth: _auth);
    });
  }

  _initSocket(WebSocketChannel? channel, String authToken) {
    log('initSocket $authToken');

    _channel = channel ??
        WebSocketChannel.connect(
          Uri.parse(
              'wss://05oqqk91oa.execute-api.eu-west-1.amazonaws.com/dev?token=$authToken'),
        );

    _channel.stream.listen((event) {
      final data = jsonDecode(event);

      if (data == null) return;

      final subscription = data['subscription'];

      if (subscription == null) return;

      SubscriptionManager.instance.feed(
        format: subscription['format'],
        contextKey: subscription['contextKey'],
        typeKey: subscription['typeKey'],
        typeId: subscription['typeId'],
        contextId: subscription['contextId'] ?? '',
        data: data,
      );
    });
  }

  Stream? findStreamById({
    required String format,
    required String contextKey,
    required String typeKey,
    required String typeId,
  }) {
    return SubscriptionManager.instance.findStreamById(
      format: format,
      contextKey: contextKey,
      typeKey: typeKey,
      typeId: typeId,
    );
  }
}
