library xube_client;

// Dart Packages

import 'dart:convert';
import 'dart:developer';

// 3rd-Party Packages
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/services/code.dart';
import 'package:xube_client/src/services/codes.dart';
import 'package:xube_client/src/services/component_data_endpoint.dart';
import 'package:xube_client/src/services/components.dart';
import 'package:xube_client/src/services/devices.dart';
import 'package:xube_client/src/services/account_components.dart';
import 'package:xube_client/src/services/product.dart';
import 'package:xube_client/src/services/products.dart';

// Utilities
import 'package:xube_client/src/utils/subscription_manager.dart';

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
  late final XubeClientProducts _products;
  late final XubeClientProduct _product;
  late final XubeClientProjects _projects;
  late final XubeClientProject _project;
  late final XubeClientDevice _device;
  late final XubeClientDevices _devices;
  late final XubeClientComponent _component;
  late final XubeClientDeviceComponents _deviceComponents;
  late final XubeClientAccountComponents _accountComponents;
  late final XubeClientCodes _codes;
  late final XubeClientCode _code;
  late final XubeClientComponentDataEndpoint _componentDataEndpoint;

  XubeClientAuth get auth => _auth;
  XubeClientAccounts get accounts => _accounts;
  XubeClientProducts get products => _products;
  XubeClientProduct get product => _product;
  XubeClientAccount get account => _account;
  XubeClientProjects get projects => _projects;
  XubeClientProject get project => _project;
  XubeClientDevice get device => _device;
  XubeClientDevices get devices => _devices;
  XubeClientComponent get component => _component;
  XubeClientDeviceComponents get deviceComponents => _deviceComponents;
  XubeClientAccountComponents get accountComponents => _accountComponents;
  XubeClientCodes get codes => _codes;
  XubeClientCode get code => _code;
  XubeClientComponentDataEndpoint get componentDataEndpoint =>
      _componentDataEndpoint;

  XubeClient({
    WebSocketChannel? channel,
    XubeClientAuth? auth,
    XubeClientAccounts? accounts,
    XubeClientProducts? products,
    XubeClientProduct? product,
    XubeClientAccount? account,
    XubeClientProjects? projects,
    XubeClientProject? project,
    XubeClientDevice? device,
    XubeClientDevices? devices,
    XubeClientComponent? component,
    XubeClientDeviceComponents? deviceComponents,
    XubeClientAccountComponents? accountComponents,
    XubeClientCodes? codes,
    XubeClientCode? code,
    XubeClientComponentDataEndpoint? componentDataEndpoint,
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
      _products =
          products ?? XubeClientProducts(channel: _channel, auth: _auth);
      _product = product ?? XubeClientProduct(channel: _channel, auth: _auth);
      _projects =
          projects ?? XubeClientProjects(channel: _channel, auth: _auth);
      _project = project ?? XubeClientProject(channel: _channel, auth: _auth);
      _device = device ?? XubeClientDevice(channel: _channel, auth: _auth);
      _devices = devices ?? XubeClientDevices(channel: _channel, auth: _auth);
      _component =
          component ?? XubeClientComponent(channel: _channel, auth: _auth);
      _deviceComponents = deviceComponents ??
          XubeClientDeviceComponents(channel: _channel, auth: _auth);
      _accountComponents = accountComponents ??
          XubeClientAccountComponents(channel: _channel, auth: _auth);
      _codes = codes ?? XubeClientCodes(channel: _channel, auth: _auth);
      _code = code ?? XubeClientCode(channel: _channel, auth: _auth);
      _componentDataEndpoint = componentDataEndpoint ??
          XubeClientComponentDataEndpoint(channel: _channel, auth: _auth);
    });
  }

  _initSocket(WebSocketChannel? channel, String authToken) {
    log('initSocket $authToken');

    _channel = channel ??
        WebSocketChannel.connect(
          Uri.parse('wss://dev.socket.xube.io/subscriptions?token=$authToken'),
        );

    _channel.stream.listen((event) {
      final data = jsonDecode(event);

      if (data == null) return;

      final subscription = data['subscription'];

      if (subscription == null) return;

      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      String prettyprint = encoder.convert(data);
      log(prettyprint);

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
