library xube_client;

// 3rd-Party Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/services/account/account_service.dart';
// Services
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/device/device_service.dart';
// Utilities
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';

export 'package:xube_client/src/services/auth.dart';

class XubeClient {
  late final XubeClientAuth _auth;
  late final XubeAccountService _accountService;
  late final XubeDeviceService _deviceService;

  XubeClientAuth get auth => _auth;
  XubeAccountService get account => _accountService;
  XubeDeviceService get device => _deviceService;

  XubeClient({
    required String baseApiUrl,
    required String baseSocketUrl,
    XubeClientAuth? auth,
    XubeDeviceService? device,
    XubeAccountService? account,
    XubeLog? log,
  }) {
    log ??= XubeLog.getInstance();
    log.initialize(
        applicationVersion: '0.0.1',
        platformDiagnosticsUrl: '/diagnostics',
        minimumPrintLevel: 0,
        minimumSendDiagnosticsLevel: XubeLogLevel.error);
    log.info('Initializing Xube Client');

    final getIt = GetIt.I;
    if (!getIt.isRegistered<XubeClientAuth>()) {
      getIt.registerLazySingleton<XubeClientAuth>(
        () => _auth = XubeClientAuth(),
      );
    }

    if (!getIt.isRegistered<Dio>()) {
      getIt.registerLazySingleton<Dio>(
        () => Dio(
          BaseOptions(
              baseUrl: baseApiUrl,
              contentType: 'application/json',
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods':
                    'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Credentials': 'true',
              }),
        ),
      );
    }
    if (!getIt.isRegistered<SubscriptionManager>()) {
      getIt.registerLazySingleton<SubscriptionManager>(
        () => SubscriptionManager(
          baseApiUrl,
          baseSocketUrl,
          log,
        ),
      );
    }

    _accountService = account ?? XubeAccountService();
    _deviceService = device ?? XubeDeviceService();
  }
}
