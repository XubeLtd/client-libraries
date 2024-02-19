library xube_client;

// Dart Packages

// import 'dart:convert';
// import 'dart:developer';

// 3rd-Party Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/services/account_devices.dart';
// import 'package:xube_client/src/services/code.dart';
// import 'package:xube_client/src/services/codes.dart';
// import 'package:xube_client/src/services/data_endpoint.dart';
// import 'package:xube_client/src/services/components.dart';
// import 'package:xube_client/src/services/devices.dart';
// import 'package:xube_client/src/services/account_components.dart';
// import 'package:xube_client/src/services/group.dart';
// import 'package:xube_client/src/services/groups.dart';
// import 'package:xube_client/src/services/product.dart';
// import 'package:xube_client/src/services/products.dart';

// Utilities
import 'package:xube_client/src/utils/subscription_manager.dart';

// Services
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/account.dart';
import 'package:xube_client/src/services/user-accounts.dart';
// import 'package:xube_client/src/services/component.dart';
// import 'package:xube_client/src/services/device.dart';
// import 'package:xube_client/src/services/project.dart';
// import 'package:xube_client/src/services/projects.dart';
import 'package:xube_client/src/utils/xube_log.dart';
export 'package:xube_client/src/services/auth.dart';

class XubeClient {
  late final XubeClientAuth _auth;
  late final XubeClientUserAccounts _userAccounts;
  late final XubeClientAccount _account;
  // late final XubeClientProducts _products;
  // late final XubeClientProduct _product;
  // late final XubeClientProjects _projects;
  // late final XubeClientProject _project;
  // late final XubeClientDevice _device;
  // late final XubeClientDevices _devices;
  // late final XubeClientComponent _component;
  // late final XubeClientDeviceComponents _deviceComponents;
  // late final XubeClientAccountComponents _accountComponents;
  // late final XubeClientCodes _codes;
  // late final XubeClientCode _code;
  // late final XubeClientDataEndpoint _dataEndpoint;
  // late final XubeClientAccountDevices _accountDevices;
  // late final XubeClientGroups _groups;
  // late final XubeClientGroup _group;

  XubeClientAuth get auth => _auth;
  XubeClientUserAccounts get accounts => _userAccounts;
  // XubeClientProducts get products => _products;
  // XubeClientProduct get product => _product;
  XubeClientAccount get account => _account;
  // XubeClientProjects get projects => _projects;
  // XubeClientProject get project => _project;
  // XubeClientDevice get device => _device;
  // XubeClientDevices get devices => _devices;
  // XubeClientComponent get component => _component;
  // XubeClientDeviceComponents get deviceComponents => _deviceComponents;
  // XubeClientAccountComponents get accountComponents => _accountComponents;
  // XubeClientCodes get codes => _codes;
  // XubeClientCode get code => _code;
  // XubeClientDataEndpoint get dataEndpoint => _dataEndpoint;
  // XubeClientAccountDevices get accountDevices => _accountDevices;
  // XubeClientGroups get groups => _groups;
  // XubeClientGroup get group => _group;

  XubeClient({
    required String baseApiUrl,
    required String baseSocketUrl,
    XubeClientAuth? auth,
    XubeClientUserAccounts? userAccounts,
    // XubeClientProducts? products,
    // XubeClientProduct? product,
    XubeClientAccount? account,
    // XubeClientProjects? projects,
    // XubeClientProject? project,
    // XubeClientDevice? device,
    // XubeClientDevices? devices,
    // XubeClientComponent? component,
    // XubeClientDeviceComponents? deviceComponents,
    // XubeClientAccountComponents? accountComponents,
    // XubeClientCodes? codes,
    // XubeClientCode? code,
    // XubeClientDataEndpoint? dataEndpoint,
    // XubeClientAccountDevices? accountDevices,
    // XubeClientGroups? groups,
    // XubeClientGroup? group,
    XubeLog? log,
  }) {
    log ??= XubeLog.getInstance();
    log.initialize(
        applicationVersion: '0.0.1',
        platformDiagnosticsUrl: '/app/diagnostics',
        minimumPrintLevel: 0,
        minimumSendDiagnosticsLevel: XubeLogLevel.error);
    log.info('Initializing Xube Client');

    final Dio _dio = Dio(
      BaseOptions(
        baseUrl: baseApiUrl,
        contentType: 'application/json',
      ),
    );
    _auth = auth ?? XubeClientAuth();

    SubscriptionManager subscriptionManager = SubscriptionManager(
      baseApiUrl,
      baseSocketUrl,
      _auth,
      log,
    );

    final getIt = GetIt.instance;
    getIt.registerSingleton<XubeLog>(log);
    getIt.registerSingleton<XubeClientAuth>(_auth);
    getIt.registerSingleton<Dio>(_dio);
    getIt.registerSingleton<SubscriptionManager>(subscriptionManager);

    _userAccounts = userAccounts ?? XubeClientUserAccounts();
    // _account = account ?? XubeClientAccount(channel: _channel, auth: _auth);
    // _products =
    //     products ?? XubeClientProducts(channel: _channel, auth: _auth);
    // _product = product ?? XubeClientProduct(channel: _channel, auth: _auth);
    // _projects =
    //     projects ?? XubeClientProjects(channel: _channel, auth: _auth);
    // _project = project ?? XubeClientProject(channel: _channel, auth: _auth);
    // _device = device ?? XubeClientDevice(channel: _channel, auth: _auth);
    // _devices = devices ?? XubeClientDevices(channel: _channel, auth: _auth);
    // _component =
    //     component ?? XubeClientComponent(channel: _channel, auth: _auth);
    // _deviceComponents = deviceComponents ??
    //     XubeClientDeviceComponents(channel: _channel, auth: _auth);
    // _accountComponents = accountComponents ??
    //     XubeClientAccountComponents(channel: _channel, auth: _auth);
    // _codes = codes ?? XubeClientCodes(channel: _channel, auth: _auth);
    // _code = code ?? XubeClientCode(channel: _channel, auth: _auth);
    // _dataEndpoint =
    //     dataEndpoint ?? XubeClientDataEndpoint(channel: _channel, auth: _auth);
    // _accountDevices = accountDevices ??
    //     XubeClientAccountDevices(channel: _channel, auth: _auth);
    // _groups = groups ?? XubeClientGroups(channel: _channel, auth: _auth);
    // _group = group ?? XubeClientGroup(channel: _channel, auth: _auth);
    // ;
  }

  // _initSocket(WebSocketChannel? channel, String authToken) {
  //   // log('initSocket $authToken');

  //   _channel = channel ??
  //       WebSocketChannel.connect(
  //         Uri.parse('wss://socket.jez.xube.dev/subscriptions?token=$authToken'),
  //       );

  //   _channel.stream.listen(
  //       (event) {
  //         final data = jsonDecode(event);

  //         if (data == null) return;

  //         final subscription = data['subscription'];

  //         if (subscription == null) return;

  //         JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  //         String prettyprint = encoder.convert(data);
  //         log(prettyprint);

  //         SubscriptionManager.instance.feed(
  //           format: subscription['format'],
  //           contextKey: subscription['contextKey'],
  //           typeKey: subscription['typeKey'],
  //           typeId: subscription['typeId'],
  //           contextId: subscription['contextId'] ?? '',
  //           data: data,
  //         );
  //       },
  //       onDone: () => {log('Socket closed'), _initSocket(channel, authToken)},
  //       onError: (error) {
  //         log('Socket error: $error');
  //       });
  //   ;
  // }

  // Stream? findStreamById({
  //   required String format,
  //   required String contextKey,
  //   required String typeKey,
  //   required String typeId,
  // }) {
  //   return SubscriptionManager.instance.findStreamById(
  //     format: format,
  //     contextKey: contextKey,
  //     typeKey: typeKey,
  //     typeId: typeId,
  //   );
  // }
}
